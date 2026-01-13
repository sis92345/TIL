## CQRS : Comment Query Responsibility

> CQRS는 Application이 Commend와 Query로 분리해야한다는 Software Pattern이다
>

CQRS는 Application이 Commend와 Query로 분리해야한다는 Software Pattern이다.

Commend는 entity를 수정하고 Query는 entity를 반환한다

### Why CQRS

- **데이터는 변경되는 것보다 쿼리되는 경우가 더 많거나 그 반대의 경우도 마찬가지**
    - 즉 read database와 write database를 각각 다르게 스케일할 수 있다
        - 일반적으로 고트레픽은 read side만 크지 write가 크지않다. 그 반대의 경우도 마찬가지이다
        - 읽기와 쓰기를 독립적으로 확장할 수 있어, 트래픽 분산 및 리소스 효율적 사용이 가능하다.
- **Comment와 Query를 분리함으로서 각각 성능을 최적화 할 수 있다**
    - Commend → RDB
    - Query → NOSQL
- Read와 Write의 데이터 구조는 대체로 다르다
- Command와 Query 동작을 같은 모델에서 시행하면 데이터 경합 발생 가능함

### CQRS Overview


![image](https://github.com/user-attachments/assets/b5f18aba-664a-49e3-9399-b2d35c571c19)

## EventSourcing

> Event Sourcing은 객체의 현재 상태 대신, 해당 객체에 발생한 모든 변경 사항을 변경 불가능한 이벤트의 시퀀스로 저장하는 방식이다.
>

### Why EventSourcing

- 모든 변화를 로그로 추적 가능
- EventStore를 재생하여 object의 상태를 재생성 가능
- write 성능 향상
- failure case에서 event store는 read database를 복구하는데 사용 가능