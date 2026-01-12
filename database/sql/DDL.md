DDL
==========
> DDL의 개념
>
> Data Dictionary

> CREATE
>
> ALTER
>
> RENAME
>
> TRUNCATE
>
> DROP

### 1.DDL 개요
---------------
- DDL(Data Definition Language)
  - <u>데이터 정의어</u>
  - 데이터베이스의 데이터를 보관하고 관리하기 위해 제공되는 여러 객체의 생성, 변경, 삭제 관련 기능을 제공
  - **DDL은 트렌젝션의 대상이 아니다.**
    - <u>즉 DDL은 ROLLBACK과 COMMIT이 불가능하다.</u> 
    - DELETE와 TRUNCATE는 모두 테이블의 데이터를 삭제할 수 있지만 DELETE는 ROLLBACK이 가능한 반면, TRUNCATE는 ROLLBACK이 불가능하다.
- Database의 객체
  - **SQL의 5대 객체**
    - TABLE
    - VIEW
    - SEQUENCE
    - INDEX
    - SYNONYM
  - PL/SQL의 5대 객체
    - Stored Procedure
    - Cursor
- **DDL의 종류**
  - CREATE
  - ALTER
  - DROP
  - RENAME
  - TRUCATE
  - COMMENT

### 2  Data Dictionary
---------------
- **Data Dictonary(데이터 사전)**: <u>DB를 구성하고 운영하는데 필요한 모든 정보를 저장하는 특수한 테이블</u>이다.

  - 데이터 사전에는 DB 메모리, 성능, 사용자, 권한, 객체 등 오라클 DB 운영에 중요한 데이터를 보관하고 있다.
  - 오라클 DB에서는 사용자가 데이터 사전 정보를 직접 접근하거나 작업하는 것을 차단한다.
    - 따라서 데이터 사전 뷰를 제공하여 SELECT문으로 정보 열람을 해야 한다.

- 데이터 사전을 이용한 객체 정보의 확인

  ```plsql
  --USER_XXXX
  SELECT *
  FROM USER_VIEWS; -- 현재 접속중인 계정이 소유한 객체를 읽는다 
  --XX_TABLES는 테이블의 집합을 보여준다. 만약 유저의 뷰만 볼려면
  --USER_VIEWS, 시퀀스를 볼려면
  --USER_SEQUENCE, 인덱스를 볼려면
  --USER_INDEXIS,  SYNONYM를 볼려면
  --USER_SYNONYM
  --SYS에서 유저를 볼려면
  --DBA_USERS
  ```

  

- 데이터 사전 접두어

  1. **USER_XXX**X: 현재 DB에 접속한 사용자가 소유한 객체의 정보

    - 따라서 계정마다 USER_XXXX는 다를 수 있다.

      ```plsql
      SELECT *
      FROM USER_TABLES; -- USER가 가진 테이블의 집합을 출력한다.
      --XX_TABLES는 테이블의 집합을 보여준다. 만약 유저의 뷰만 볼려면
      --USER_VIEWS, 시퀀스를 볼려면
      --USER_SEQUENCE, 인덱스를 볼려면
      --USER_INDEXIS,  SYNONYM를 볼려면
      --USER_SYNONYM
      ```

      

  2. **ALL_XXXX**: 현재 DB에 접속한 사용자가 소유한 객체 + 다른 사용자가 소유한 객체 중 사용 허가를 받은 객체

    ```plsql
    SELECT *
    FROM ALL_VIEWS;
    ```

  3. **DBA_XXXX**: DB 관리를 위한 정보로, DB관리 권한을 지닌 SYSTEM, SYS계정만 열람할 수 있다.

    ```
    SELECT *
    FROM DBA_USERS; --scott계정에서는 테이블이 존재하지 않는다고 한다. 테이블 정보 자체를 숨기기 위함이다.
    ```

    

  4. **V$_XXXX**: DB 성능 관련 정보

### 3. DDL - CREATE

------

- **CREATE** 

  - <u>SQL, PL/SQL의 객체를 생성하는 명령어다.</u>

- **기본 형식**

  ```plsql
  CAREATE TABLE 소유계정.테이블 이름( --소유 계정은 명확할 경우 생략 가능(예: scott계정 접속하고 scott 계정 테이블 생성)
  열1이름 열1 자료형, 
  열2이름 열2 자료형,
  열3이름 열3 자료형,
  열4이름 열4 자료형,
  )
  ```

- **테이블 생성 규칙**

  - <u>테이블은 문자로 시작해야 한다.</u>
    - 숫자로 시작하는 테이블은 불가능
    - 한글도 가능하나 권장하지 않는다.
  - <u>테이블 이름은 30자를 넘어갈 수 없다.</u>
    - 영어는 34Byte
    - 한글은 유니코드(3byte)이므로 10글자
  - <u>같은 소유주에서는 테이블 이름은 중복될 수 없다.</u>
  - <u>테이블 이름에는 영문자, 숫자, 특수문자($, #, _)를 사용할 수 있다.</u>
  - <u>SQL 키워드를 테이블 이름으로 사용할 수 없다.</u>

  - 열 이름 생성 규칙

    - 테이블 생성 규칙과 같다.

- **CREATE를 이용하여 테이블을 만드는 4가지 방법**

  - **자료형을 각각 정의하여 테이블 생성(일반적인 방법)**

    ```plsql
    CREATE TABLE Student1(
        hukbun         CHAR(7)      , --2020-01
        name           VARCHAR2(20) , --김빛나라               
        address        VARCHAR2(200), --서울시 강남구 역삼동 한독빌딩 8층
        age            NUMBER(3)    ,
        birthday       DATE         ,
        email          VARCHAR2(100),
        hight          NUMBER(4, 1) , --178.3
        weight         NUMBER(4, 1)   --110.3
    );
    ```

  - **기존 테이블 열 구조와 데이터를 복사하여 새 테이블을 생성**

    - 복사된 테이블은 원본의 값만 복사한 테이블이다 == 값복사

    - 테이블의 제약조건은 복사되지 않는다.

    - 기본 형식: `AS`사용

      ``` plsql
      CREATE TABLE TABLE_NAME
      AS SELECT * FROM DEPT; --기존의 DEPT구조와 데이터를 복사해서 TABLE_NAME을 생성 
      ```

    - 예

      ```plsql
      --기존 테이블 열 구조와 데이터를 복사하여 새 테이블을 생성
      CREATE TABLE emp_copy
      AS 
      SELECT * FROM emp; -- emp table의 구조와 데이터를 그대로 복사한다. 단, 제약조건은 복사되지 않는다.
      -- 아래의 예를 확인하자
      DESC emp_copy; --기본 emp 테이블의 NUT NULL은 나오지 않는다. 
      DESC emp;
      
      ```

  - **기존 테이블의 열 구조와 일부 데이터만 복사하여 새 테이블 생성**

    - 기본 형식

      ```plsql
      CREATE TABLE TABLE_NAME_30
      AS SELECT * FROM emp WHERE empno = 30; --복사할 원본 테이블에 조건을 부여한다.
      ```

    - 예

      ```plsql
      --직무가 SALESMAN인 사람들만 들어있는 테이블 생성하되, 사번, 이름, 직무, 봉급, 입사날짜만 생성
      CREATE TABLE emp_salsman
      AS
      SELECT empno, ename, job, sal, hiredate
      FROM emp
      WHERE job = 'SALESMAN';
      SELECT *
      FROM emp_salsman;
      ```

  - **기존열 테이블의 열 구조만 복사하여 새 테이블 생성**

    - **조건을 언제나 FALSE로 처리**하도록 만들면 열 구조만 복사할 수 있다.

    - 예

      ```plsql
      --기존열 테이블의 열 구조만 복사하여 새 테이블 생성
      --조건이 언제나 false이도록 작성하면 된다.
      CREATE TABLE emp_empty
      AS
      SELECT * FROM emp
      WHERE 1 = 0; --구조만 복사
      SELECT * FROM emp_empty;
      ```


  - CREATE의 예

    ```plsql
    --DDL
    --CREATE
    CREATE TABLE member(
        id               VARCHAR2(14), --가변길이 문자형 
        password         VARCHAR2(20)
    );
    
    -- 생성한 테이블은 반드시 확인해야 한다.
    DESC USER_TABLES;
    
    SELECT table_name
    FROM user_tables; -- == SELECT * FROM tab;
    
    --예제: 테이블을 생성하되, 사번, 이름, 부서이름, 위치, 부서번호를 포함하는 테이블을 생성하되, 단 부서번호가 10번과 20번만
    CREATE TABLE emp_dept
    AS
    SELECT empno, ename, dname, loc, deptno --서브쿼리를 먼저 작성하자
    FROM emp e INNER JOIN dept d USING(deptno)
    WHERE deptno IN (10,20)
    ORDER BY deptno ASC;
    SELECT * FROM emp_dept;
    
    --테이블을 복사해서 생성하되, 데이터는 복사하지 말고, 구조만 복사하라, 사번, 이름, 직무, 부서이름, 부서위치, 부서번호로 생성
    CREATE TABLE emp_dept1
    AS
    SELECT empno, ename, job, dname, loc, deptno
    FROM emp NATURAL JOIN dept
    WHERE 1 < 0;
    ```

### 4. ALTER

------

- **ALTER**

  - 이미 생성된 객체를 변경할 때 사용한다.
  - 테이블에 새 열을 추가하거나 삭제, 열의 자료형 또는 길이를 변경한다.
  - 오라클에서는 테이블 변경을 권장하지 않는다.

- ALTER의 종류

  - **ADD**: 열을 추가한다.

    - 열이 새로 만들어지면 그 전에 존재했던 데이터들의 새 열 값은 NULL이다.

      ```
      CREATE TABLE testTable
      AS
      SELECT empno, ename, dname, loc 
      FROM emp NATURAL JOIN dept
      WHERE deptno = 30; --6개 행 생성
      
      SELECT *
      FROM testTable; 
      
      ALTER TABLE testTable
      ADD hiredate DATE;  --기존 6개 행의 hiredate는 전부 NULL이다.
      ```

  - **RENAME**: 컬럼명을 변경한다.

    ```plsql
    ALTER TABLE testTable
    RENAME COLUMN hiredate TO startday; -- hiredate 칼럼의 이름을 startDay로 바꾼다.
    ```

  - **MODIFY**: 테이블의 특정 열의 자료형이나 길이를 변경한다.

    - **MODIFY의 주의점**

      - 길이 변경 시

        - 자료형의 길이를 늘이는 것은 문제가 없다,

        - 하지만 *자료형의 길이를 줄일때는 열이 널 값을 포함하고 테이블에 행이 없을 경우에만 열의 너비를 줄일 수 있다.*

          ```
          ALTER TABLE testTable
          MODIFY ename VARCHAR(9); -- MODIFY: ename의 자료형 길이를 줄인다.
          
          DESC testTable;
          INSERT INTO testTable(empno, ename)
          VALUES(11, '김빛나라'); -- ename은 9바이트므로 삽입할 수 없다.
          
          ALTER TABLE testTable
          MODIFY ename VARCHAR(5); --이미 5바이트가 넘는 자료형이 있으므로 길이를 변경할 수 없다.
          ```

      - **열의 기본값이 변경되면 변경 이후에 테이블에 삽입된 항목에만 영향을 준다.**

      - 기존 데이터가 존재할 시 CHAR와 VARCHAR에만 타입 변경이 가능하다.

  - **DROP**: 특정 열을 삭제한다.

- ALTER의 기본 형식

  ```plsql
  ----ADD
  ALTER TABLE table_name
  ADD 컬럼이름   자료형
  --ADD 예
  ALTER TABLE emp_copy10
  ADD (job VARCHAR2(9));
  ----RENAME
  ALTER TABLE table_name
  RENAME COLUMN 이전컬럼명 TO 변경할컬럼명 
  --
  ALTER TABLE emp_copy10 
  RENAME COLUMN sal TO salary;
  ----MODIFY
  ALTER TABLE table_name
  MODIFY (변경할)컬럼이름   (변경할)자료형
  --
  ALTER TABLE emp_copy10
  MODIFY job CHAR(30);
  ----DROP
  ALTER TABLE table_name
  DROP COLUMN (삭제할 컬럼)
  --
  ALTER TABLE emp_copy10
  DROP COLUMN job;
  ```

### 5. RENAME

------

- **RENAME**

  - 테아블의 이름을 변경한다,

- 기본 형식

  ```
  RENAME 이전테이블명 TO 변경테이블명
  ```

### 6. TRUNCATE

------

- **TRUNCATE**

  - 특정 테이블의 모든 데이터를 삭제한다.
  - 트렌젝션의 대상이 아니므로, 롤백, 커밋이 불가능하다
  - 속도는 빠르다.

- TRUCNATE와 DROP과 DELETE의 삭제

  - TRUNCATE와 DROP는 DDL로 트랜젝션의 대상이 아니므로 롤벡을 할 수 없다,
  - 반면 DML인 DELETE는 트렌젝션의 대상으로서, 롤백이 가능하다
  - TRUNCATE와 DELETE는 테이블 내 데이터의 삭제를 담당하지만 DROP는 테이블 자체를 삭제한다.
  - TRUNCATE는 무조건 테이블의 모든 데이터를 삭제하지만 DELETE는 조건을 부여해 일부만 삭제할 수 있다.

- 기본 형식

  ```plsql
  TRUNCATE TABLE emp_boksa; --emp_boksa 테이블의 모든 데이터를 삭제
  ```

### 7. DROP

------

- **DROP**

  - 테이블을 삭제한다.
  - 내 테이블을 자식 테이블이 참조하고 있을 경우 삭제가 안된다.
    - 이 경우 연결을 끊고 삭제해야한다.

- 기본형식

  ```plsql
  DROP TABLE table_name
  --주의점: 외래 키에의해 참조되는 고유/기본 키가 테이블에 있으면 삭제할 수 없다.
  --즉 자식 테이블이 참조하고 있으면 삭제가 안된다.
  --따라서 다음의 명령어는 삭제가 불가능하다.
  DROP TABLE dept;
  ```

  

### 8. COMMENT

------

- COMMENT문을 이용해서 열, 테이블, 뷰에 2000Byte까지 주석을 추가할 수 있다.

- COMMENT문을 확인하는 방법

  - ALL_COL_COMMENTS, ALL_TAB_COMMENTS

- COMMENT 기본 형식: `COMMENT ON (COLUMNS)` 

  - 테이블에 주석: `COMMENT ON TABLE_NAME IS '주석입니다.';` 
  - 열에 주석: `COMMENT ON COLUMN TABLE_NAME.columns IS '주석입니다.';`

- **COMMENT 생성**

  ```plsql
  --COMMENT: TABLE
  COMMENT ON TABLE emp_boksa IS '이 테이블은 EMP 테이블을 복사한 테이블입니다.';
  
  --COMMENT: COLUMNS
  COMMENT ON COLUMN emp_boksa.hiredate IS '입사날짜를 저장하는 칼럼';
  ```

- **COMMENT 확인**

  ```plsql
  --COMMENT 확인
  DESC USER_tab_comments; -- 구조 확인
  --반드시 주석을 달았다면 Dictionary에서 확인하자
  SELECT table_name, table_type, comments
  FROM user_tab_comments
  WHERE table_name = upper('emp_boksa');
  
  
  --컬럼 주석 확인
  DESC USER_COL_COMMENTS;
  SELECT table_name, column_name, comments
  FROM user_col_comments
  WHERE table_name = upper('emp_boksa');
  ```


### 9. DDL 문제

------

```plsql
--DDL 문제
--Q1. 다음의 열 구조를 가지는 EMP_HW 테이블을 만드시오
CREATE TABLE EMPHW(
    empno       NUMBER(4),
    ename       VARCHAR2(10),
    job         VARCHAR2(10),
    mgr         NUMBER(4),
    hiredate    DATE,
    sal         NUMBER(7,2),
    comm        NUMBER(7,2),
    deptno      NUMBER(2)
);
SELECT TABLE_NAME FROM USER_TABLES
WHERE TABLE_NAME = 'EMPHW';

--Q2. EMP_HW 테이블에 BIGO열을 추가하라.BIGO 열의 자료형은 가변형 문자열이고 길이는 20이다.
ALTER TABLE EMPHW
ADD (BIGO VARCHAR2(20));

--Q3. EMPHW테이블의 BIGO열 크기를 30으로 변경하라
ALTER TABLE EMPHW
MODIFY BIGO VARCHAR(30);
DESC EMPHW;

--Q4. EMPHW테이블의 BIGO 열 이름은 RWMARK로 변경하라
ALTER TABLE EMPHW
RENAME COLUMN BIGO TO REMARK;

--Q5. EMPHW 테이블에 EMP 테이블의 데이터를 모두 저장하라 단 REMARK 열은 NULL로 처리하라
--서브쿼리 + INSERT: P.275
--VALUES대신 서브쿼리 사용 가능
--암시적인 방법
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp;
--명시적인 방법
INSERT INTO EMPHW(empno, ename, job, mgr, hiredate, sal, comm, deptno, remark)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno, NULL
FROM emp;

--Q6. EMPHW 테이블을 삭제하시오
DROP TABLE EMPHW;

--사원번호, 이름, 업무, 입사일자, 부서번호만 포함하는 emp_temp table을 생성하되, 자료는 포함하지 않고 스키마만 생성하라
CREATE TABLE emp_temp
AS
SELECT empno, ename, job, hiredate, dname
FROM emp
WHERE 1<0;

--emp_temp 테이블에 '복사한 테이블' 주석을 추가하고 테이블의 empno칼럼에 '복사한 컬럼' 주석을 추가하라. 추가한 후 주석을 확인하라
--COMMENT 추가
COMMENT ON TABLE emp_temp IS '복사한 테이블';
COMMENT ON COLUMN emp_temp IS '복사한 컬럼';
--COMMENT 확인
SELECT * 
FROM user_tab_comments 
WHERE table_name = 'emp_temp';

SELECT * 
FROM user_col_comments 
WHERE table_name = 'emp_temp';
```

