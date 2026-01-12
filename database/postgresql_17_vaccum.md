# Postgresql 17 VACCUM

## **VACCUM이란**

Postgresql은 MVCC를 위해 삭제/업데이트된 Row를 디스크에서 제거하지 않고 마크하고 남깁니다. 이를 Dead Tuple이라고 합니다.

Dead Tuple은 해당 tuple을 참조하는 트랜잭션이 더이상 없을 경우 VACCUM이 자동으로 실행 될 때 대상이 되어 제거됨

이때 VACCUM은 다음 동작을 진행됩니다.

- **임계치 이상으로 발생한 Dead Tuple을 정리하여 FSM (Free Space Map) 으로 반환하여 재사용 가능한 공간으로 변환**
- **Transaction ID Wraparound 방지**
- 테이블, 인덱스통계 정보 갱신
- index scan 향상

### Dead Tuple이 많아질 경우 문제점

쿼리 성능과 디스크 사용량 두 측면에서 영향력을 미칩니다

- Dead Tuple이 많아질수록 Seq Scan / Bitmap Scan 시 **페이지 단위 visibility 체크 비용이 증가합니다.**
    - 단 처음만 해당, visibility 해당 후 별도로 제외
    - 쿼리 성능 영향
- Index 공간 차지
    - 디스크 사용률 증가
- WAL 사이즈 증가

## **15.4 -> 17에서 VACCUM 개선점**

> VACUUM 메모리 사용량 대폭 감소
> 

VACCUM시 사용되는 메모리가 대폭 감소했습니다.

일반적인 테이블에서는 큰 성능 개선이 없을 것이라고 예상되지만 대용량 테이블, 특히 인덱스가 걸려 있을 경우 메모리 성능 향상에 도움이 될 것 이라고 생각합니다.

---

## **테스트 계획**

> Proposal : 15.4, 17의 메모리 사용 비교
> 

### 테스트 관련 설정

1. autovacuum = off
2. maintenance_work_mem = 2GB

### **1. Dead tuple 실증**

1. 테스트 테이블 생성 후 10,000,000건 Row 삽입
    1. Autovacuum_enabled = false
2. **삭제전 카운트 조회 측정**
3. 9,999,999 제거
4. **삭제후 카운트 조회 측정**
5. **pg_stat_user_tables로 dead_tup 측정**
6. Dt+ {tablename}로 속도 측정
7. 인덱스 생성 후 비교해야함

### **결과**

1. dead tuple 확인 완료

---

### **2. 15.4에서 메모리 사용치**

1. **VACUUM 수동 실행**
    
    ```
    VACUUM (VERBOSE) test_table;
    VACUUM full test_table;
    ```
    
    → 로그에 block/tuple 처리 통계 출력됨 (전체 vacuum work 확인용)
    
2. **OS 레벨에서 메모리 사용량 측정**
    - RDS는 직접 OS 접근이 안 되므로, **CloudWatch 또는 `pg_backend_pid()` 이용**해 session 추적
    
    예시:
    
    ```
    sql
    
    복사편집
    SELECT pg_backend_pid();
    ```
    
    → 이 PID를 기준으로 해당 세션의 memory usage를 추적 (CloudWatch 또는 Performance Insights에서)
    
3. **vacuum 작업 중 `pg_stat_activity` 확인**
    
    ```
    SELECT pid, query, wait_event_type, wait_event
    FROM pg_stat_activity
    WHERE query LIKE 'VACUUM%';
    ```
    

### **결과**

![image.png](Postgresql%2017%20VACCUM/image.png)

9,999,999 dead tuple 테이블에 vacuum시 대략 300MB 정도 메모리 사용

| 타입 | 실험 | DELETE ROW (AF) | 실행시간 | MEMORY | SIZE |
| --- | --- | --- | --- | --- | --- |
| 10_000_000 | 업데이트 | 2_000_000 | 3 s 202 ms | 247MB-> 335MB | 1.8GB |
| 10_000_000 ROW | 삭제 | 9_999_999 | 4 s 640 ms | 300MB -> 400MB | 1.4GB -> 214 MB |
| 10_000_000 ROW + INDEX | 삭제 | 9_999_999 | 8 s 488 ms | 220MB -> 876MB | 1.6GB -> 297 MB |
|  |  |  |  |  |  |

---

### **3. 17에서 메모리 사용치**

같은 방식으로 vacuum 실행 + memory 측정

**조건 동일화 필수**: `shared_buffers`, `work_mem`, `maintenance_work_mem`, 테이블 row 수/인덱스 수까지 동일하게

## **결과**

![image.png](Postgresql%2017%20VACCUM/image%201.png)

| 타입 | 실험 | DELETE ROW (AF) | 실행시간 | MEMORY | SIZE |
| --- | --- | --- | --- | --- | --- |
| 10_000_000 | - | - | - | - | - |
| 10_000_000 ROW | 삭제 | - | - | - | - |
| 10_000_000 ROW + INDEX | 삭제 | 9_999_999 | 4 s 283 ms | 240MB 변화 없음 | 1.6GB -> 299 MB |
|  |  |  |  |  |  |

# Conclusion

> PostgreSQL 17에서는 VACUUM의 내부 메모리 사용 방식이 개선되어,
> 
> 
> **대형 테이블과 인덱스를 가진 환경에서도 VACUUM 실행 시 피크 메모리 사용량이 줄어드는 효과**
> 
> 를 기대할 수 있습니다.
> 

PostgreSQL 17에서 VACUUM 작업 시 메모리 사용량이 대폭 감소하였습니다. 특히 인덱스가 있는 대용량 테이블에서 메모리 절약 효과를 관측했다.

- **대용량 테이블** (수백만 행 이상)
- **빈번한 데이터 변경** (INSERT/UPDATE/DELETE가 활발)
- **복수의 인덱스** 보유 테이블
- **메모리 제약** 환경에서 운영

### **튜닝 전략 변화**

메모리 사용량 감소로 인해 다음과 같은 공격적인 튜닝이 가능해졌습니다

- `autovacuum_vacuum_scale_factor` 값을 더 낮게 설정 (0.2 → 0.1 또는 그 이하)
- 동일한 `maintenance_work_mem` 설정에서도 VACUUM의 내부 메모리 사용량이 줄어들어, 피크 메모리 사용량의 압박이 줄어든다.
- 더 빈번한 자동 VACUUM 실행으로 dead tuple 축적 최소화

### 한계점

- **디스크 공간 회수 불가**: 일반 VACUUM으로는 실제 디스크 사용량이 줄어들지 않습니다.
    - VACUUM FULL을 사용해야 하지만 테이블에 베타락이 걸려서 운영에는 불가능합니다.
- **소규모 테이블 체감 효과 제한적**: 수만 행 이하의 테이블에서는 개선 효과가 미미

### **Dead Tuple이 성능에 미치는 영향**

**쓰기 성능에 미치는 직접적 영향:**

- **INSERT 성능 저하**: 새로운 tuple 저장을 위한 빈 공간 탐색 시간 증가
- **UPDATE 성능 악화**: HOT update 불가로 인한 인덱스 갱신 작업 추가 발생
- **인덱스 갱신 지연**: Dead tuple이 누적된 인덱스에서 삽입/수정 작업 오버헤드 증가
- **페이지 분할 빈발**: Dead tuple로 인한 공간 부족으로 페이지 분할이 자주 발생

**간접적 영향:**

- **버퍼 풀 효율성 저하**: Bloated 테이블로 인한 메모리 캐시 효율 감소
- **WAL 생성량 증가**: 비효율적인 공간 사용으로 더 많은 WAL 레코드 생성

# 참고 사항

1. [VACCUM 관련 SQL](https://blog.gaerae.com/2015/09/postgresql-vacuum-fsm.html)
2. [테스트 시나리오](https://blog.ex-em.com/2002)

### 참고 1 : 언제 VACCUM 작동하는가

> vacuum_trigger = vacuum_threshold + (vacuum_scale_factor × number_of_rows)\
> 

```
# 기본값
# 대략 20% 정도의 row에 + 50개 dead tuple 존재시 발생
autovacuum = on
autovacuum_vacuum_threshold = 50
autovacuum_vacuum_scale_factor = 0.2
```

vacuum_trigger를 만족하는 테이블일 경우 auto vacuum이 작동됩니다.

예를들어 천만 Row인 테이블이 Vaccum이 돌려면 2백만 Row의 dead tuple이 존재하여야 합니다.

### 참고 2: 튜닝 팩터

```
#recursive_worktable_factor = 10.0
#autovacuum_vacuum_scale_factor = 0.2
#autovacuum_vacuum_insert_scale_factor = 0.2
#autovacuum_analyze_scale_factor = 0.1
#maintenance_work_mem (or autovacuum_work_mem)
```