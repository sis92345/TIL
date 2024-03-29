Constraint
==========
> Constraint의 개념
>

> DEFAULT
>
> NOT NULL
>
> UNIQUE
>
> PRIMARY KEY
>
> FOREIGN KEY
>
> CHECK
>

### 1. Constraint
---------------
- **Constraint(제약조건)**

  - <u>테이블의 특정 열에 제약조건을 부여</u>해서 *제약 조건에 부합하지 않는 데이터의 저장을 방지*한다.
  - 제약조건을 *데이터 무결성을 보장*하기 위함이다.
    - **무결성의 종류**
      - **영역 무결성(domain intergrity):** **CHECK KEY 사용**, 열에 저장되는 값의 적정 여부를 확인 등 자료형, 적절한 형식의 데이터, NULL 여부같은 정해 놓은 범위를 만족하는 데이터 임을 규정
      - **개체 무결성(entity intergrity)**: **Primary Key가 존재해야 한다** --> 테이블에 데이터를 유일하게 식별할 수 있는 값이 있어야 하고 그 값은 NULL을 가질 수 없고 중복값도 가질 수 없다.
        - UNIQUE는 NULL값을 가질 수 있으므로 개채 무결성을 보장할 수 없다.
      - **참조 무결성(referential intergrity)**: **자식 테이블의** **외래키가 부모 테이블의 UNIQUE 또는 PRIMARY KEY를 참조**

- **오라클의 제약 조건 종류**

  - **DEFAULT**: 데이터를 입력하지 않았을 경우 기본값을 지정한다.
  - **NOT NULL**: NULL값 입력을 허용하지 않는다. 
    - 단 NULL이 아닌 데이터 중복값 입력은 가능하다
  - **UNIQUE**: 데이터 중복값 입력을 허용하지 않는다.
    - 단 중복값이 아닌 NULL값은 허용한다.
  - **PRIMARY KEY**: NOT NULL + UNIQUE
  - **FOREIGN KEY**: 다른 테이블의 컬럼을 참조
  - **CHECK**: 범위를 지정하거나 값을 지정한다. 조건이 참이어야 한다.

- **제약 조건을 부여하는 방식**

  - **테이블레벨 제약조건, Table-level Constraints**

    - 테이블 단위로 제약 조건을 부여한다.

    - NOT NULL은 테이블레벨 제약 조건으로 부여할 수 없다.

      ```PLSQL
      CREATE TABLE temp(
      	seq	    NUMBER(4),
      	name    VARCHAR2(20),
      	dept	VARCHAR2(20),
      	CONSTRAINT temp_seq_PK PRIMARY KEY(seq)
      	--CONSTRAINT temp_seq_NN NOT NULL(seq) 오류: NOT NULL은 테이블레벨 제약 조건으로 부여할 수 없다.
      );
      ```

  - **컬럼레벨 제약조건, Column-level Constraints**

    - 컬럼 단위로 제약 조건을 부여한다.

    - 모든 제약 조건은 컬럼 레벨 제약 조건으로 부여할 수 있다.

      ```PLSQL
      CREATE TABLE temp(
      	seq	    NUMBER(4) CONSTRAINT temp_seq_PK PRIMARY KEY,
      	name    VARCHAR2(20) CONSTRAINT temp_seq_nn NOT NULL,
      	dept	VARCHAR2(20)
      );
      ```

  -  테이블 레벨 제약조건과 컬럼 레벨 제약조건은 함께 사용할 수 있다.

    ```
    CREATE TABLE temp(
    	seq	    NUMBER(4),
    	name    VARCHAR2(20) CONSTRAINT temp_seq_nn NOT NULL, -- 컬럼레벨 제약조건
    	dept	VARCHAR2(20),
    	CONSTRAINT temp_seq_PK PRIMARY KEY(seq) -- 테이블레벨 제약조건
    );
    ```

- **제약 조건을 부여하는 시점**

  - 테이블 생성 시

    ```plsql
    CREATE TABLE temp(
    	seq	    NUMBER(4),
    	name    VARCHAR2(20) CONSTRAINT temp_seq_nn NOT NULL, -- 컬럼레벨 제약조건
    	dept	VARCHAR2(20),
    	CONSTRAINT temp_seq_PK PRIMARY KEY(seq) -- 테이블레벨 제약조건
    );
    ```

  - 테이블 리모델링 시

    ```plsql
    -- 기존 테이블의 구조를 복사해서 생성한 테이블의 경우 제약조건이 삭제되므로 다시 제약조건을 부여해야 한다.
    CREATE TABLE temp_copy
    AS
    SELECT *
    FROM emp;
    -- 이미 만들어진 테이블에 제약 조건 부여는 ALTER를 이용한다.
    --ALTER TABLE ~ ADD CONSTRAINT/DROP CONSTRAINT
    ALTER TABLE temp_copy
    -- 이미 만들어진 테이블에 NOT NULL을 추가할 경우 ADD가 아닌 MODIFY를 사용한다.
    --NOT NULL제약 조건 추가
    ALTER TABLE emp_copy10
    ADD CONSTRAINT temp_seq_PK PRIMARY KEY(seq);
    --NOT NULL은 ADD CONSTRAINT를 사용하지 않는다.
    --MODIFY ename NOT NULL;
    MODIFY ename CONSTRAINT emp_copy10_ename_nn NOT NULL; 
    ```

- **제약 조건의 주의점**

  - <u>다른 테이블을 복사해 생성한 테이블은 제약 조건이 삭제되므로 다시 제약 조건을 부여해야 한다.</u>
  - 제약 조건에는 이름을 부여할 수 있다. 
    - 제약 조건의 삭제, 활성화, 비활성화시 제약조건의 이름이 필요하므로 제약 조건의 이름 부여는 필수 사항이다.
    - 제약 조건 이름 부여 규칙: `TABLENAME_COLUMN_ NN / PK / FK / UK / CK`
  
- 제약 조건 부여의 예

  ```plsql
  -- 제약조건 및 DEFAULT OPTION 복습
  DROP TABLE student;
  
  CREATE TABLE Student(
      hakbun          CHAR(7),
      name            VARCHAR2(20)          CONSTRAINT student_name_NN NOT NULL,
      math            NUMBER(3)    DEFAULT 0  CONSTRAINT student_math_NN NOT NULL,
      age             NUMBER(3)    DEFAULT 20  CONSTRAINT student_age_NN NOT NULL,
      seq             NUMBER(5),
      city            VARCHAR2(30),
      gender          CHAR(1)      DEFAULT 0,
      CONSTRAINT studnet_hakbun_PK PRIMARY KEY(hakbun), --PK
      CONSTRAINT studnet_math_CK CHECK(math BETWEEN 0 AND 100), --CK
      CONSTRAINT studnet_age_CK CHECK(age >19),
      CONSTRAINT studnet_city_CK CHECK(city IN ('서울', '부산', '부천')),
      CONSTRAINT studnet_city_UK UNIQUE(city),
      CONSTRAINT studnet_gender_CK CHECK(gender IN ('1', '0')),
      --CONSTRAINT studnet_zipcode_FK FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode): 참조할 부모 테이블의 값은 유니크, 기본키
      CONSTRAINT studnet_zipcode_FK FOREIGN KEY(seq) REFERENCES zipcode(seq)
  );
  ```

  

### 2 . DEFAULT Option

------

- **DEFAULT**

  - 특정 열에 저장할 값이 지정되지 않을 경우 <u>기본값(DEFAULT)를 지정할 수 있다.</u>
    - 해당 열에 NULL값이 들어가는 것을 방지

- **DEFAULT 규칙**

  - 날짜형 데이터에 저장한 DEFAULT 값은 날짜형 데이터만 가능하고, 문자형 데이터에 저장할 DEFAULT값은 문자형 데이터만 사용할 수 있다.

    - 리터럴, 표현식, SYSDATE같은 SQL 함수는 기본값으로 사용할 수 있다.

  - DEFAULT는 NULL이 암시적으로 들어갈 경우 자동적으로 대체될 값을 지정한다.

    - 만약 명시적으로 DEFAULT를 넣고 싶다면 `DEFAULT` 키워드를 사용한다.

    - 예

      ```plsql
      --테이블
      CREATE TABLE emp_copy10(
          empno       NUMBER(4),
          ename       VARCHAR2(200),
          hiredate    DATE            DEFAULT SYSDATE, --디폴트로 들어갈 데이터는 해당 컬럼의 데이터 타입과 일치해야 한다.
          job         VARCHAR2(50)    DEFAULT 'DEVELOPER',
          sal         NUMBER(7)       DEFAULT 800000
      );
      -- 1. 암시적으로 DEFAULT을 넣을 경우 
      INSERT INTO emp_copy10(empno)
      VALUES(1111); -- ename에 암시적으로 NULL값이 들어가며, hiredate와 job과 sal은 암시적으로 DEFAULT값이 들어간다.
      -- 2. 명시적으로 DEFAULT을 넣을 경우 
      INSERT INTO emp_copy10(empno, ename, job, hiredate)
      VALUES(3333, '박지민', DEFAULT, DEFAULT);
      ```

- DEFAULT OPTION의 예: 

  ```plsql
  -- DEFAULT option예
  CREATE TABLE member -- 테이블을 복사해서 생성하면 모든 제약조건이 삭제된다.
  AS 
  SELECT  empno, ename
  FROM emp
  WHERE 1 = 0; -- 스키마만 가져온다.
  
  DESC member;
  -- 컬럼 추가
  ALTER TABLE member
  ADD (gender NUMBER(1));
  --추가한 컬럼 수정: 나중에 DEFAULT 값을 부여
  ALTER TABLE member
  MODIFY (gender VARCHAR(7) DEFAULT '여성');
  
  INSERT INTO member(empno, ename)
  VALUES (1111, '한지민');
  
  SELECT * FROM member;
  ```

### 3. NOT NULL

------

- NOT NULL 

  - NOT NULL은 중복값에 상관없이 데이터에 NULL의 저장을 허용하지 않는 제약조건이다.
  - NUT NULL은 Column-level Constraint만 가능하다.
  - NUT NULL의 추가는 ALTER TABLE ADD CONSTRAINT가 아니라 ALTER TABEL MODIFY를 사용한다. 

- NOT NULL 조건 부여

  ```plsql
  CREATE TABLE temp(
  	ename COSTRAINT temp_ename_NN NOT NULL
  	--NOT NULL은 테이블 레벨 제약 조건을 사용할 수 없으므로 컬럼 레벨 제약 조건을 사용한다
  )
  ```

- 이미 생성된 테이블에 NOT NULL 조건 추가: ALTER TABLE ~ MODIFY

  ```plsql
  ALTER TABLE emp_copy10
  --MODIFY ename NOT NULL; NOT NULL은 ADD CONSTRAINT를 사용하지 않는다.
  MODIFY ename CONSTRAINT emp_copy10_ename_nn NOT NULL; 
  ```

- NOT NULL 삭제

  ```
  ALTER TABLE emp_copy10
  DROP  CONSTRAINT emp_copy10_ename_nn;
  ```

  

### 4. PRIMARY KEY

------

- PRIMARY KEY

  - UNIQUE + NOT NULL
  - 테이블의 각 행을 식별하는데 활용한다.
  - PRIMARY KEY는 두 열을 지정할 수 있다.
    - 하지만 권장하지는 않는다.

- PRIMARY KEY 생성

  ```plsql
  --1. Column-level 제약조건으로 생성하기
  CREATE TABLE Member(
      userid  CHAR(14)        PRIMARY KEY, -- Column-level 제약조건: 모든 제약 조건을 컬럼명 옆에 사용
      passwd  VARCHAR2(20),
      name    VARCHAR2(20),
      age     NUMBER(2),
      city    VARCHAR2(20)    DEFAULT 'SEOUL'
  );
  --1-1. Column-level 제약조건에 이름 부여해서 생성
  -- 일반적인 형식: 테이블이름_컬럼이름_PK | UK | NN | FK | CK
  CREATE TABLE Member(
      userid  CHAR(14)       CONSTRAINT member_userid_PK PRIMARY KEY, 
      passwd  VARCHAR2(20),
      name    VARCHAR2(20),
      age     NUMBER(2),
      city    VARCHAR2(20)    DEFAULT 'SEOUL'
  );
  --2. Table-level 제약조건으로 생성하기
  CREATE TABLE Member(
      userid  CHAR(14),
      passwd  VARCHAR2(20),
      name    VARCHAR2(20),
      age     NUMBER(2),
      city    VARCHAR2(20) DEFAULT 'SEOUL',
      -- Table-level은 여기서부터 제약조건을 부여한다.
      CONSTRAINT member_userid_pk PRIMARY KEY(userid)
  );
  --값 입력
  INSERT INTO Member(userid, passwd)
  VALUES(1111, '12345');
  INSERT INTO Member(userid, passwd)
  VALUES(1111, '12345'); --userid는 프라이머리키이므로 중복값을 생성할 수 없다.
  INSERT INTO Member(userid, passwd)
  VALUES(NULL, '12345'); -- userid는 프라이머리키이므로 NULL값을 허용하지 않는다.
  ```

- PRIMARY KEY의 예

  ```plsql
  --테이블 복사해서 테이블 생성한 후, 새로 생선한 테이블에는 제약조건이 삭제됬으니까 새로 제약조건을 추가하는 방법
  --테이블 복사해서 생성
  CREATE TABLE emp_copy10
  AS 
  SELECT empno, ename, job, hiredate
  FROM emp
  WHERE deptno = 10;
  --복사한 테이블은 제약조건이 삭제되었으므로 다시 제약조건을 부여
  ALTER TABLE emp_copy10
  ADD CONSTRAINT emp_copy10_empno_PK PRIMARY KEY(empno); --ADD CONSTRAINT는 제약 조건 추가
  --확인
  DESC USER_CONSTRAINTS;
  SELECT OWNER, Constraint_name, constraint_type, table_name
  FROM USER_constraints
  WHERE table_name = 'MEMBER';
  
  INSERT INTO emp_copy10(empno, ename)
  VALUES (7782, '한지민'); -- 기본키 제약조건이 설정되어 있으므로 삽입할 수 없다.
  
  --제약조건 삭제 ALTER의 DROP을 이용
  ALTER TABLE emp_copy10
  DROP CONSTRAINT emp_copy10_empno_PK;
  ```

  

### 5. FORIGN KEY

------

- FORIGN KEY: 외래키

  - 외래키는 서로 다른 테이블 간 관계를 정의한는데 사용한다.

  - 자식 테이블의 외래키는 반드시 부모 테이블의 UNIQUE 또는 PRIMARY KEY이어야 한다.

    ```plsql
    CREATE TABLE test1(
        no NUMBER(7) CONSTRAINT test1_no_PK PRIMARY KEY,
        job VARCHAR(20) CONSTRAINT test1_job_FK REFERENCES emp(job) --emp테이블의 job은 기본키나 유니크가 아니므로 test1 테이블에서 외래키로 사용할 수 없다.
    );
    ```

  - 만약 참조할 테이블에 값이 하나도 존재하지 않는다면 외래키를 지정할 수 없다

- FROEIGN KEY 생성

  - 기본 형식: `columnName VARCHAR2(30) (CONSTRAINT tablename_columnName_FK REFERENCES) referencedTableName(referencedColumn)`

  - 테이블 생성 시 외래키 생성

    - 컬럼레벨 제약 조건으로  FOREIGN KEY 생성

      - 컬럼레벨 제약 조건으로 외래키를 생성할 때는 `FOREIGN KEY` 키워드를 사용하지 않고 바로 `REFENENCES`를 사용한다.

        ```plsql
        CREATE TABLE CART(
            cartid 		NUMBER(10) CONSTRAINT CART_cart_id_PK PRIMARY KEY 
            memberid	NUMBER(10) CONSTRAINT CART_member_id_FK REFERENCES member(member_id) --컬럼 레벨 제약 조건은 FOREIGN KEY 키워드를 생략
        )
        ```

    - 테이블 레벨 제약 조건으로 FOREIGN KEY 생성

      - 테이블 레벨 제약 조건으로 FOREIGN KEY 생성할 때에는 FOREIGN KEY 키워드를 사용해야 한다.

        ```plsql
        CREATE TABLE Cart(
            cart_id     NUMBER(10),
            member_id   NUMBER(5) CONSTRAINT cart_member_id_FK REFERENCES member(member_id),
            product_id  NUMBER(5),
            CONSTRAINT cart_cart_id_PK PRIMARY KEY(cart_id),
            CONSTRAINT cart_product_id_FK FOREIGN KEY(product_id) REFERENCES Product(product_id)
        ); 
        ```

  - 이미 만든 테이블에 FOREIGN KEY 제약 조건을 부여: 

    - 기본 형식: `ALTER TABLE tablName ADD (CONSTRAINT table_name_deptno_FK) FOREIGN KEY(deptno) REFERENCES dept(dpetno)`

    - 예

      ```plsql
      --FOREIGN KEY 부여
      ALTER TABLE emp_copy
      ADD CONSTRAINT emp_copy_deptno_FK FOREIGN KEY(deptno) 
      REFERENCES dept_copy(deptno);
      ```

- FOREIGN KEY의 주의점

  - 자식 테이블의 외래키는 반드시 부모 테이블의 UNIQUE 또는 PRIMARY KEY이어야 한다.

  - 만약 참조할 테이블의 열 값이 하나도 존재하지 않는다면 외래키를 지정할 수 없다

    ```plsql
    CREATE TABLE dept2
    AS
    SELECT *
    FROM dept
    WHERE 1<0;
    
    CREATE TABLE emp2
    AS
    SELECT *
    FROM emp;
    
    ALTER TABLE emp2
    ADD CONSTRAINT emp2_deptno_FK FOREIGN KEY(deptno) REFERENCES dept2(deptno); --dept2 테이블의 deptno열에는 아무런 데이터도 없다. 따라서 외래키를 만들 수 없다.
    
    ALTER TABLE emp2
    ADD CONSTRAINT emp2_deptno_FK FOREIGN KEY(deptno) REFERENCES dept(deptno); --dept 테이블의 deptno에는 값이 있다, 따라서 외래키를 만들 수 있다.
    ```

  - 외래키가 지정되어 있으면 테이블을 삭제할 수 없다. 

    - 외래키 제약 조건을 삭제해야 한다.

  - 외래키가 참조하는 부모 테이블의 열에 없는 값을 데이터로 입력할 수 없다.

    ```
    INSERT INTO emp2(empno, ename, deptno)
    VALUES(1111, '한지민', 80); --dept 테이블의 deptno는 10, 20, 30, 40이므로 외래키인 deptno에 80값을 넣을 수 없다.
    ```

    

- 외래키 제약 조건 삭제

  ```plsql
  ALTER TABLE emp1
  DROP CONSTRAINT emp1_deptno_FK;
  ```

- 외래키로 참조되는 부모 테이블 데이터의 제거

  - 현재 삭제하려는 열 값을 참조하는 데이터를 먼저 삭제한다.
    - emp테이블의 deptno가 dept의 deptno테이블의 deptno 열의 참조하는 경우
    - emp 테이블의 deptno 열에서 dept.deptno삭제하려는 데이터를 먼저 삭제한 후 dept 테이블에서 deptno를 제거
  - 현재 삭제하려는 열 값을 참조하는 데이터를 수정한다. 
    - emp테이블의 deptno가 dept의 deptno테이블의 deptno 열의 참조하는 경우
    - emp 테이블의 deptno 열에서 dept.deptno삭제하려는 데이터를 변경
  - FOREIGN KEY 제약 조건 자체를 삭제

- 외래키 제약 조건의 조건들

  - ON DELETE CASCADE: 부모 테이블의 데이터를 삭제하면 참조하는 자식 데이터도 같이 삭제된다.

    ```plsql
    ADD CONSTRAINT emp1_deptno_FK FOREIGN KEY(deptno) 
    REFERENCES dept1(deptno) ON DELETE CASCADE;
    ```

  - ON DELETE SET NULL: 부모 데이터를 삭제할 시 자식 테이블의 값을  NULL로 바꾼다.

    ```plsql
    ALTER TABLE emp1
    ADD CONSTRAINT emp1_deptno_FK FOREIGN KEY(deptno) 
    REFERENCES dept1(deptno) ON DELETE SET NULL; 
    ```

### 6.UNIQUE

------

- UNIQUE

  - 열에 데이터의 중복을 허용하지 않는다.
  - 단 NULL값은 허용한다.

- UNIQUE 제약 조건 부여

  - 테이블 생성 시 제약 조건 부여

    ```plsql
    CREATE TABLE test1(
        no NUMBER(7),
        job VARCHAR(20) CONSTRAINT test1_job_UK UNIQUE, -- 컬럼 레벨 제약 조건
        CONSTRAINT test1_no_UK UNIQUE(no) -- 테이블 레벨 제약 조건
    );
    ```

  - 이미 존재하는 테이블에 UNIQUE 생성

    ``` plsql
    ALTER TABLE dept1
    ADD CONSTRAINT dept1_dname_UK UNIQUE(danme);
    ```

- UNIQUE 제약조건의 추가, 삭제

  - 이미 존재하는 컬럼에 UNIQUE 부여

    ```plsql
    ALTER TABLE TABLE_UNIQUE
    MODIFY(TEL UNIQUE);
    ```

  - UNIQUE 제약 조건 삭제

    ```plsql
    ALTER TABLE TABLE_UNIQUE
    DROP CONSTRAINT TABLE_UNIQUE_TEL_UK;
    ```

    

### 7. CHECK

------

- CHECK

  - 데이터의 형태와 범위를 정한다.

- 예

  ```plsql
  --CHECK: 부서의 위치는 서울, 부산,대전, 대구, 인천, 광주, 울산만 가능해야 한다.
  ALTER TABLE dept1
  ADD CONSTRAINT dept1_loc_CK CHECK (loc IN ('SEOUL','PUSAN', '대구','인천','대전','울산'));
  
  INSERT INTO dept1
  VALUES(40, '디자인팀', '대구');
  
  
  INSERT INTO dept1
  VALUES(60, '디자인팀', '평양'); --CHECK 제약 조건에 위배
  ```