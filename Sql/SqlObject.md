DB OBJECT
==========
> SQL의 OBJECT
>

> TABLE
>
> SEQUENCE
>
> VIEW
>
> INDEX
>
> SYNONYM
>

### 1. SQL의 OBJECT
---------------
- DB Object	
- 데이터 베이스르 구성하는 독립요소를 말한다.
  - 데이터베이스 객체의 종류
    - TABLE
    - SEQUENCE
    - VIEW
    - INDEX
    - SYNONYM

### 2 . TABLE

------

- TABLE
  - 실제 데이터가 저장되는 공간을 말한다.
  - 테이블은 표 형식처럼 컬럼과 그 컬럼에 각각 값이 들어간 ROW 형태의 레코드로 구성된다.
  - DB에서 가장 기본이 되는 객체로 우리가 데이터를 저장한다는 것은 그 데이터를 그룹핑으로 구별되게 잘 쪼개서 각각의 테이블 컬럼에 대응되게 순차적으로 넣는다는 의미이기도 하다.
- TABLE과 관련된 명령어: DDL
  - TABLE의 생성, 삭제, 변경
    - CREATE
      - 테이블의 생성
    - ALTER
      - 테이블의 변경
      - 이미 생성된 테이블에 새로운 컬럼을 추가하거나 변경하거나 삭제하거나 길이를 변경하거나 열의 자료형을 변경하는 역할을 한다.
      - ALTER의 종류: ADD, RENAME, MODIFY, DROP
    - RENAME
      - 테이블의 이름을 변경
    - TRUNCATE
      - 테이블의 모든 데이터를 삭제
    - DROP
      - 테이블을 삭제
  - TABLE의 DATA를 삽입, 변경, 삭제:DML
    - INSERT
      - 데이터의 삽입
    - UPDATE
      - 데이터의 수정
    - DELETE
      - 데이터의 삭제
  - DML, DDL과 관련된 명령어는 다음을 참고할 것
    - [DML](https://github.com/sis92345/TIL/blob/master/Sql/DML.md)
    - [DDL](https://github.com/sis92345/TIL/blob/master/Sql/DDL.md)

### 3. SEQUENCE

------

- SEQUENCE

  - 시퀀스는 특정 규칙에 맞는 연속 숫자를 생성하는 객체이다.
  - 시퀀스는 DB 객체로써 한번 만들면 모든 테이블에서 사용할 수 있다.
  
- SEQUENCE의 생성

  - 기본 형식:`CREATE SEQUENCE 시퀀스 이름` ;

    - 이렇게만 사용할 경우 SEQUENCE 옵션은 전부 기본값이 된다.

    - SEQUENCE 옵션: 선택사항으로 지정하지 않으면 기본값으로 들어간다.

      ```plsql
      CREATE SEQUENCE dept_seq
      	INCREMENT BY n
      	START WITH n
      	MAXVALUE n
      	MINVALUE n
      	CYCLE|NOCYCLE
      	CHCHE|NOCACHE;
      ```

      - INCRENMENT BY: 시퀀스 번호의 증가값

        - INCREMENT BY 10: 시퀀스 번호가 10씩 증가
        - 기본값: 1

      - START WITH: 시퀀스 번호의 시작값

        - START WITH 10: 시퀀스 번호는 10부터 시작
        - 기본값: 1

      - MAXVALUE: 시퀀스 번호의 최대값

        - MAXVALUE 500: 시퀀스 번호는 500을 넘을 수 없다.

      - MINVALUE: 시퀀스 번호의 최솟값

        - MINVALUE 5: 시퀀스 번호는 5이하가 될 수 없다.

        - MINVALUE는 START WITH의 값 이상이 될 수 없다.

        - 만약 MINVALUE가 5이고 START WITH가 8이고 MAXVAULE가 1이고 CYCLE이라면 1이아닌 5부터 시작

          ```plsql
          CREATE SEQUENCE dept1seq
              START WITH 5
              MAXVALUE 10
              MINVALUE 3
              CYCLE
              NOCACHE;
          --값 입력
          INSERT INTO deptSEQ1(deptno)
          VALUES(dept1seq.NEXTVAL); --부서번호가 5에서 시작해서 10까지 입력되고 다시 입력될때는 3부터 시작한다.
          ```

      - CYCLE|NOCYCLE

        - CYCLE: 최대값에 도달할 경우 START WITH, MINVALUE가 있을 경우 MINVALUE부터 시작
        - NOCYCLE: 최대값에 도달하면 번호 생성을 중단

      - CHCHE|NOCACHE

        - CHCHE: 시퀀스가 생성할 번호를 미리 메모리에 할당해 놓은 수를 지정
        - NOCAHCE: 시퀀스가 생성할 번호를 미리 메모리에 할당하지 않도록 지정
        - 기본값: 20

  - SEQUENCE 생성의 예

    ```plsql
    CREATE SEQUENCE DEPTSEQ
        START WITH 1 --시작값이 1
        INCREMENT BY 1 --증가값이 1
        MAXVALUE 99 --최대값이 99
        MINVALUE 1 --최솟값이 1
        NOCYCLE --사이클 없음
        NOCACHE; --캐시 없음
    ```

- SEQUENC 수정

  - `ALTER SEQUENCE`를 이용한다.

  - START WITH는 수정할 수 없다.

  - 기본 형식

    ```plsql
    ALTER SEQUENCE dept_seq
    	INCREMENT BY n
    	START WITH n
    	MAXVALUE n
    	MINVALUE n
    	CYCLE|NOCYCLE
    	CHCHE|NOCACHE;
    ```

  - 예

    ```plsql
    ALTER SEQUENCE dept_deptno_SEQ
    	-- START WITH : SEQUENCE의 START WITH는 수정할 수 없다.
        MAXVALUE 1000;
    ```

- SEQUENCE의 삭제

  - `DROP SEQUENCE 시퀀스 이름`을 이용

    ```plsql
    --SEQUENCE 삭제
    DROP SEQUENCE dept_deptno_SEQ; -- 시퀀스 삭제
    --삭제 확인
    DESC USER_SEQUENCES; 
    SELECT *
    FROM USER_SEQUENCES;
    ```

- SEQUENCE의 이용

  - NEXTVAL, CURRVAL

    - NEXTVAL: 시퀀스는 CURRVAL 다음 번호를 반환
      - 즉 시퀀스는 다음 번호를 반환한다.
    - CURRVAL: 시퀀스에서 마지막으로 생성한 번호를 반환
    - CURRVAL을 하면 마지막 번호만 반환하므로 숫자를 증가할 수 없다.
      - 따라서 NEXTVAL을 해서 값을 바꾸어야 한다.
      - 처음 시퀀스를 이용할때 NEXTVAL을 안하면 CURRVAL을 할 수 없다.

  - 예

    ```plsql
    -- SEQUENCE 활용
    CREATE TABLE dept_clone
    AS
    SELECT *
    FROM dept
    WHERE 1<0;
    
    ALTER TABLE dept_clone
    ADD CONSTRAINT dept_clone_deptno_OK PRIMARY KEY(deptno); --기본 키는 절대로 중복값, NULL이 없어야 한다 --> SEQUENCE 사용
    
    CREATE SEQUENCE DEPT_DEPTNO_SEQ
        START WITH 10
        INCREMENT BY 10
        MAXVALUE 99 -- 부서 테이블의 부서 번호는 NUMBER(2)이니까 
        CACHE 20;
        
    INSERT INTO DEPT_CLONE(deptno, dname, loc)
    VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'개발팀','SEOUL'); --10
        
    INSERT INTO DEPT_CLONE(deptno, dname, loc)
    VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'총무팀','SEOUL'); --20
        
    INSERT INTO DEPT_CLONE(deptno, dname, loc)
    VALUES(DEPT_DEPTNO_SEQ.NEXTVAL,'운영팀','PUSAN'); --30
    
    SELECT *
    FROM DEPT_CLONE;
    ```

### 4. VIEW

------

- VIEW

  - 하나 이상의 테이블을 조회하는 SELECT문을 저장한 객체로 가상테이블이다.
  - SELECT문을 저장하기 때문에 물리적 데이터를 저장하지 않는다.

- VIEW를 사용하는 이유

  - 편리성
    - SELECT문의 복잡도 완화 --> 속도 향상
  - 보안성
    - 물리적으로 데이터를 저장하지 않는다.

- VIEW의 종류

  - 단순 VIEW
    - 하나의 테이블로 생성한다.
    - 그룹함수, 다중행함수를 사용할 수 없다.
    - DISTINCT의 사용이 불가능
    - DML사용이 가능하다
  - 복합 VIEW
    - 여러 개의 테이블로 구성
    - 그룹함수 이용이 가능
    - DISCTINCT의 사용이 가능
    - DML사용이 불가능

- VIEW의 유의점

  - VIEW를 정의하는 하위 질의는 ORDER BY 절을 포함할 수 없다,

    - ORDER BY를 이용하기 위해서는 뷰에서 데이터를 검색할때 사용한다.

  - VIEW는 ALTER를 사용하지 않는다.

    - 대신 `OR REPLACE`를 사용하여 해당 VIEW를 같은 이름의 새로운 VIEW로 대채할 수 있다.

  - 일반계정에서는 VIEW 생성 권한이 없다.

    - 일반계정에 VIEW 권한을 부여하는 방법은 다음과 같다.

      ```plsql
      --일반 계정은 VIEW를 사용할 수 없다.
      CREATE VIEW test_view
      AS
      SELECT * FROM emp;
      --VIEW 생성 권한 부여: SQLPLUS에서
      GRANT CREATE VIEW TO SCOTT;
      ```

  - VIEW의 생성

    - 기본 형식

      ```plsql
      CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰 이름(열 이름1, 열 이름2....)
      AS
      저장할 SELECT문
      WITH CHECK OPTION: 
      WITH READ ONLY
      ```

    - OR REPLACE: 같은 이름의 뷰가 존재할 경우 현재 VIEW로 대체하여 생성(선택)

    - FORCE | NOFORCE(선택)

      - FORCE: 뷰가 저장할 SELECT문의 테이블이 없어도 VIEW를 강제로 생성
      - NOFORCE: 뷰가 저장할 SELECT문의 테이블이 있어야 VIEW를 생성(기본값)

    - 열 이름(선택)

      - SELECT문에 사용할 이름이 아닌 열 이름으로 저장

    - WITH CHECK OPTION: 지정한 조건을 만족한 DML만 가능, VIEW를 만들때 사용한 SELECT문의 WHERE절의 조건과 일치하지 않으면 실행 거부

      ```plsql
      CREATE OR REPLACE VIEW test_view
      AS 
      SELECT empno, ename, sal, deptno
      FROM emp
      WHERE deptno = 20
      WITH CHECK OPTION; --지정한 조건을 만족한 DML만 가능, VIEW를 만들때 사용한 WHERE절의 조건과 일치하지 않으면 실행 거부:deptno는 반드시 20이어야 한다.
      COMMIT; --12:25분
      ROLLBACK;
      INSERT INTO test_view(empno,ename,sal,deptno)
      VALUES(9999, '김지민',2000,30); --VIEW에 DML을 시행하려 했으나 WITH CHECK OPTION이므로 VIEW의 SELECT문의 WHERE절대로 deptno가 20이 아니므로 VIEW생성을 거부
      ```

    - WITH READ ONLY: 뷰의 열람, 즉 SELECT문만 가능하도록 지정

    - 예

      ```plsql
      CREATE OR REPLACE NOFORCE VIEW EMP1982_VIEW(EMPOLYEE_ID,EMPOLYEE_NAME, HIRE_DATE, DEPARTMENT_NAME, LOCATION, DEPARTMENT_ID)
      AS
      SELECT empno, ename, hiredate, dname, loc, deptno
      FROM emp NATURAL JOIN dept
      WHERE TO_CHAR(hiredate, 'YYYY') = '1981';
      ```

  - VIEW의 삭제

    - `DROP VIEW 삭제할 뷰 이름;`

    - 예

      ```PLSQL
      DROP VIEW test1_view;
      ```

  - VIEW 예

    ```plsql
    --부서별로 부서명, 최소 급여, 최대 급여, 부서의 평균 급여를 포함하는 DEPT_SUM VIEW 생성
    CREATE OR REPLACE VIEW DEPT_SUM(deptno, dname, min_sal, max_sal, avg_sal)
    AS
    SELECT  emp.deptno, dept.dname, MAX(sal),MIN(sal), TRUNC(AVG(sal))
    FROM emp INNER JOIN dept ON (emp.deptno = dept.deptno)
    GROUP BY emp.deptno, dept.dname;
    
    DESC dept_sum;
    SELECT * FROM dept_sum;
    ```

  - TOP-N SQL문

    - TOP-N SQL
      - 인라인 뷰: CREATE로 객체로 만들어지는 SQL문 이외에 일회성으로 만들어서 사용하는 뷰
      - ROWNUM: pseudo column이라고 하는 특수 열로 의사 열을 데이터가 저장되는 실제 테이블은 존재하지 않지만 특정 목적을 위해 테이블에 저장되어 있는 열처럼 사용 가능한 열
        - ROWNUM은 테이블에 저장된 행이 조회된 순서대로 매겨진 일련번호
      - https://m.blog.naver.com/PostView.nhn?blogId=superman4u&logNo=40046438958&proxyReferer=https:%2F%2Fwww.google.com%2F

    ```plsql
    --TOP-N QUERY: 
    --아래는 제일 먼저 생성한 3개의 데이터를 sal 내림차순 정렬
    SELECT ROWNUM, ename, sal
    FROM emp
    WHERE ROWNUM <=3
    ORDER BY sal DESC;
    
    CREATE OR REPLACE view emp_sal_dec_view
    AS
    SELECT ename, sal
    FROM emp
    ORDER BY sal DESC;
    --새로만든 뷰의 새로만든 ROWNUM이므로 월급을 내림차순으로 정렬 --> ROWNUM 상위 3개 출력 == 월급 제일 많은 3사람 출력 
    SELECT ROWNUM, ename, sal
    FROM emp_sal_dec_view
    WHERE ROWNUM<=3;
    ```

### 5. INDEX

------

- INDEX

  - 데이터 검색 성능의 향상을 위해 테이블 열에 사용하는 객체
  - 빠른 검색이 가능

  - 인덱스 데이터 사전: USER_INDEXES, USER_IND_COLUMNS
  - 인덱스는 특정 테이블에 지정할 수 있지만 기본적으로 기본키, UNIQUE는 자동으로 인덱스가 부여된다.
  - 인덱스를 위해서는 추가적인 공간이 필요하다는 점, 인덱스를 만들기 위한 추가적인 시간이 필요하다는 점은 인덱스의 단점이다.
  - 보통 컬럼, 행이 많은 경우에 사용한다.

- 인덱스 종류

  - 단일 인덱스
    - 컬럼 하나 
  - 복합 인덱스
    - 컬럼 두개 이상
  - 유니크 인덱스(고유  인덱스)
    - 열에 중복값이 존재하지 않아야 한다.
    - INDEX앞에 UNIQUE를 붙임: CREATE UNIQUE INDEX ~ ON
  - 낫 유니크 인덱스
    - 열에 중복값이 존재
    - 일반적인 인덱스
  - 함수기반 인덱스
    - 열에 산술식 같은 데이터 가공이 진행된 결과로 인덱스 사용
  - 비트맵 인덱스

- INDEX 생성

  - `CREATE INDEX 인덱스 이름 ON 테이블 이름(열 이름1 ASC OR DESC .....)`
    - 인덱스는 여러 열을 지정할 수 있다.
      - 단 성능이 떨어질 수 있으므로 속도를 측정

- INDEX 삭제

  - DROP INDEX IDX_NAME

- INDEX 수정

  - INDEX는 수정하지 않는다: 지우고 새로 만들어야 한다.

### 6.SYNONYM

------


