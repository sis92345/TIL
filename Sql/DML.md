DML
==========
> DML의 개념

> INSERT
>
> UPDATE
>
> DELETE

### 1.DML
---------------
- **DML(Data Manipulation Language)**
  - <u>데이터 조작어</u>
  - 테이블의 데이터를 추가, 수정, 삭제하는 명령어
- DML의 종류
  - **INSERT**: 데이터 삽입
  - **UPDATE**: 데이터 수정
  - **DELETE**: 데이터 삭제

### 2  INSERT
---------------
- **INSERT**

  - 테이블에 데이터를 삽입

- **INSERT형식**

  ```plsql
  INSERT INTO table_name(column1, column2.... [선택, VALUES에 들어갈 컬럼의 순서를 결정한다.])
  VALUES (data1, data2...)
  ```

- **INSERT의 주의점**

  - 하나의 INSERT는 하나의  INSERT를 수행한다.

  - 테이블 이름 뒤에는 VALUES에 기입할 컬럼 데이터의 순서를 결정한다

    - 이를 사용하지 않는다면 table의 본래 컬럼 순서대로 기입한다.

    - 즉 아래의 경우는 같은 테이블에 같은 데이터를 기입한다.

      ```plsql
      INSERT INTO emp_copy
      VALUES(1111,'JIMIN','CLERK',7701,'2017-01-02',3200,300,40);
      
      INSERT INTO emp_copy(deptno, comm, sal, hiredate, mgr, job, ename, empno)
      VALUES(40, 300, 3200, 2017-01-02, 7701, '2017-01-02', 'CLERK', 'JIMIN', 1111);
      ```

  - 날짜형/문자형 데이터는 `''`를 사용해야 한다.

    ```plsql
    INSERT INTO emp_copy(empno, ename, hiredate)
    VALUES(1111, JIMIN, 2017-01-02) --오류: 날짜형/문자형 데이터는 ''를 사용해야 한다.
    --위 SQL은 아래와 같이 수정해야 한다.
    INSERT INTO emp_copy(empno, ename, hiredate)
    VALUES(1111, 'JIMIN', '2017-01-02') --오류: 날짜형/문자형 데이터는 ''를 사용해야 한다.
    ```

  - 테이블 리스트에 명시한 컬럼의 갯수와 VALUES절의 값 갯수는 같아야 한다.

    ```plsql
    --개수가 일치하지 않는 경우 오류: VALUEAS에 들어간 값이 컬럼 수보다 많거나 적을때 
    --INSERT INTO emp_copy(empno, ename, job, hiredate)
    --VALUES (2222, 'HANJIMIN', SYSDATE);
    ```

  - 입력될 값의 데이터 타입은 칼럼의 데이터 타입과 일치해야 한다.

    - 단 `'2222'`처럼 문자형 데이터에 숫자만 사용한 경우 자동형변환되어 들어간다.

    ```plsql
    --empno는 NUMBER지만 문자열 입력해도 자동형변환이 되어 입력된다.
    INSERT INTO emp_copy(empno, ename, job, hiredate)
    VALUES ('2223', 'HANJIMIN', 'MARKETTER',SYSDATE);
    
    
    --empno는 NUMBER지만 문자열 입력해도 자동형변환이 되어 입력된다. --단 데이터 타입이 아예 다른 경우는 자동형변환이 안된다.
    INSERT INTO emp_copy(empno, ename, job, hiredate)
    VALUES ('hale', 'HANJIMIN', 'MARKETTER',SYSDATE);
    ```

  - 입력될 값의 크기는 칼럼의 크기보다 크지 않아야 한다.

    - 한글은 3Byte

  - NULL값을 주의한다.

    - NULL값을 입력하는 방법

      - 암시적인 방법:  테이블 리스트에 적힌 컬럼 이외는 모두 NULL처리

        ```plsql
        INSERT INTO emp_copy(deptno,ename) 
        VALUES (1528, 'AMANDA') -- 나머지는 모두 NULL값을 입력됨
        ```

      - 명시적인 방법: VALUES에 직접 NULL을 입력

        ```plsql
        INSERT INTO dept
        VALUES (50, 'MARKETING', NULL) 
        ```

    -  날짜형 데이터 입력시 TO_DATE()를 이용하자

      - 이유: NLS_DATE_FORMAT을 알아야 날짜형 데이터를 기입할 수 있다. 이를 TO_DATE()를 이용하여 편하게 처리하는 것

        ```plsql
        --INSERT 날자형 데이터 입력
        INSERT INTO emp_copy(empno, ename, hiredate)
        VALUES (6666, 'BTS', TO_DATE('01-02-2019', 'MM-DD-YYYY')); -- '2019-01-02'? '01-02-2019'? --> 날짜형 데이터에는 NLS_DATE_FORMET을 알아야 한다.
        --일 두번 하지 않으려면 TO_DATE를 사용
        ```

    - Foreign Key에 유의한다.

      ```plsql
      --Foreign Key에 유의해야 한다.
      SELECT deptno FROM dept;
      
      INSERT INTO emp(empno, ename, deptno)
      VALUES (8888, 'JIMIN', 77); -- deptno는 Foreign Key,deptno에는 77번이 없다.
      ```

### 3. UPDATE

------

- UPDATE

  - 특정 테이블에 저장된 데이터를 수정

  - UPDATE는 여러행을 수정할 수 있다.

    - 아래의 경우 emp_copy 테이블의 모든 행의 deptno를 10으로 수정한다.

      ```plsql
      UPDATE emp_copy
      SET deptno = 10; -- 모든 행의 deptno가 10으로 수정된다.
      ```

    - 위와 같은 현상을 막기 위해서 UPDATE는 WHERE절을 같이 사용하는 것을 권장한다.

- UPDATA의 형식

  ```plsql
  UPDATE table_name ex) dept
  SET 변경할 컬럼의 이름과 데이터 ex) dname = 'MARKETING'
  WHERE 조건식 ex) deptno = 10; --WHERE절을 생략할 경우 모든 열의 데이터가 수정된다.
  ```

- UPDATE 사용 시 주의점

  - 수정하려는 열의 갯수 파악(전체, 일부, 단 하나) --> WHERE 조건절에 따라 결정

  - 수정하려는 컬럼의 갯수 파악(전체 칼럼 변경은 없다. 단 한개의 컬럼, 일부 컬럼을 변경할 것인가?) --> 쉼표(,)를 사용할 것인가?

  - INSERT와 마찬가지로 무결성 제약 조건에 유의하자

    - 부모 테이블 deptno에는 98949가 없다. (FK)

      ```plsql
      --UPDATE에서 무결성 제약 조건
      UPDATE emp
      SET deptno = 98949
      WHERE ename = 'SMITH';
      ```

      

### 4. DELETE

------

- DELETE

  - 데이터의 삭제
  - UPDATE와 마찬가지로 WHERE절을 사용해서 무단 삭제를 방지하자
  - 여러행을 삭제할 수 있다.

- DELETE 형식

  ```plsql
  DELECT FROM table_name 
  WHERE 조건식
  ```

### 5. DML 문제

------

```plsql
--10장 문제
-- 
CREATE TABLE CHAP10HW_EMP AS SELECT * FROM emp;
CREATE TABLE CHAP10HW_DEPT AS SELECT * FROM dept;
CREATE TABLE CHAP10HW_SALGRADE AS SELECT * FROM salgrade;
DROP TABLE CHAP10HW_SALGRADE;
--Q1 CHAP10HW_DEPT테이블에 50,60,70,80번 부서를 등록
INSERT INTO CHAP10HW_DEPT 
VALUES(50, 'ORACLE', 'BUSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(60, 'SQL', 'ILSAN');

INSERT INTO CHAP10HW_DEPT 
VALUES(70, 'SELECT', 'INCHEON');

INSERT INTO CHAP10HW_DEPT 
VALUES(80, 'DML', 'BUNDANG');

SELECT * FROM CHAP10HW_DEPT;

--Q2 CHAP10HW_EMP 테이블에 2명의 사원을 입력하시오
--명시적 NULL처리
INSERT INTO CHAP10HW_EMP
VALUES(7201, 'TEST_USER1', 'MANAGER', 7788, TO_DATE('2016-01-02','YYYY-MM-DD'), 4500, NULL, 50);
--암시적 NULL처리
INSERT INTO CHAP10HW_EMP(empno, ename, job, mgr, hiredate, sal, deptno)
VALUES(7202, 'TEST_USER2', 'CLERK', 7201, TO_DATE('2016-02-21','YYYY-MM-DD'), 1800, 50);

SELECT * FROM CHAP10HW_EMP;
--Q3 CHAP10HW_EMP에 속한 사원 중 50번 부서에서 근무하는 사원들의 평균 급여보다 많은 급여를 받고있는 사원들을 70번 부서로 옮기는 SQL문 작성
--서브쿼리 미사용으로 할 것
SELECT AVG(sal)
FROM CHAP10HW_EMP
WHERE deptno = 50;

UPDATE CHAP10HW_EMP
SET deptno = 70
WHERE sal > 3150;

ROLLBACK;

--Q4.(수정) 20번 부서의 사원 중 입사일이 가장 늦은 사원보다 더 늦게 입사한 사원의 급여를 10% 인상하고 80번 부서로 옮겨라
UPDATE CHAP10HW_EMP
SET sal = sal * 1.1, deptno = 80
WHERE hiredate > (SELECT MAX(hiredate)FROM CHAP10HW_EMP WHERE deptno = 20);

--Q5. CHAP10HW_EMP에 속한 사원 중, 급여 등급이 5인 사원을 삭제하는 SQL문 작성
DELETE FROM CHAP10HW_EMP
WHERE empno IN (SELECT e.empno FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  WHERE grade = 5); 

SELECT ename, grade 
FROM CHAP10HW_SALGRADE INNER JOIN CHAP10HW_EMP e ON e.sal BETWEEN losal AND hisal  
WHERE grade = 5;

SELECT *
FROM CHAP10HW_EMP;
```





### 6. 외부 조인

------

- **외부조인(OUTER JOIN, +, 포괄조인)**

  - 두 테이블간 조인 수행에서 조인 기준 열의 어느 한 쪽이 NULL이어도 강제로 출력하는 방식

    ```plsql
    -- scott 계정의 dept 테이블에는 부서가 4개 있으나 40번 부서는 사원이 존재하지 않는다.
    -- 이때 등가 조인을 하면 조인의 조건이 =이므로 emp 테이블에서 공통된 부서 번호가 없는 40번 부서는 출력되지 않는다.
    -- 이때 외부조인을 사용하면 40번 부서를 강제로 출력할 수 있다.
    ```

- 외부 조인의 종류: 

  - 외부 조인은 정보가 부족한 테이블에 `(+)`를 붙여준다.

    - 의미: *(+)를 붙이지 않은 테이블을 기준으로 (+)를 붙인 테이블의 데이터 존재 여부와 상관 없이 출력*
    - **왼쪽 외부 조인, 오른쪽 외부 조인, 전체 외부 조인**이 존재한다.

  - **왼쪽 외부 조인(LEFT OUTER JOIN)**

    - 왼쪽 열을 기준으로 오른쪽 열의 모든 데이터 존재 여부에 상관없이 출력

  - **오른쪽 외부 조인(RIGHT OUTER JOIN)**

    - 오른쪽 열을 기준으로 왼쪽 열의 모든 데이터 존재 여부에 상관없이 출력

  - **전체 외부 조인(FULL OUTER JOIN)**

    - 왼쪽 외부 조인 + 오른쪽 외부 조인 = 조인한 테이블의 모든 데이터 출력

  - 예

    ```plsql
    SELECT empno, emp_copy.deptno, dname
    FROM emp_copy INNER JOIN dept ON dept.deptno = emp_copy.deptno; -- deptno가 null인 사원은 출력되지 않는다.
    --수정
    SELECT emp_copy.deptno, dname, empno, ename 
    FROM emp_copy INNER JOIN dept ON dept.deptno(+) = emp_copy.deptno; --emp_copy.deptno를 기준으로 dept.deptno의 데이터와 상관없이 모든 데이터를 출력한다. 따라서 부서가 없는 사원을 출력할 수 있다.
    
    SELECT emp_copy.deptno, dname, empno, ename 
    FROM emp_copy INNER JOIN dept ON dept.deptno = emp_copy.deptno(+); --dept.deptno를 기준으로 emp_copy.deptno의  데이터와 상관없이 모든 데이터를 출력한다.
    ```

    

- 외부 조인의 형식

  - 비표준

    - 비표준 외부조인은 정보가 부족한 테이블에 (+)를 붙여준다.

    - 비표준 외부조인은 기본적으로 전체 외부 조인을 지원하지 않는다

      - 왼쪽 외부 조인과 오른쪽 외부 조인의 결과를 UNION으로 묶어서 표현한다.

    - 형식

      ```plsql
      --비표준 왼쪽 외부 조인: (+)가 오른쪽으로 간다.
      SELECT
      FROM emp, dept
      WHERE emp.deptno = dept.deptno(+); -- emp.deptno를 기준으로 dept.deptno의 모든 데이터를 출력한다: emp.deptno이 기준으로 dept.deptno를 모두 출력한다. 즉 연결되어 있지 않은 40번 부서를 출력해준다. 
      --비표준 오른쪽 외부 조인: (+)가 왼쪽으로 간다.
      SELECT
      FROM emp, dept
      WHERE emp.deptno(+) = dept.deptno; -- dept.deptno를 기준으로 emp.deptno의 모든 데이터를 출력한다: dept.deptno이 기준으로 emp.deptno를 모두 출력한다. 즉 부서와 연결되어 있지 않은 사원을 출력해준다. --> 이게 등가 조인으로 작성되었다면 부서에 속해있지 않은 사원은 출력되지 않는다.
      
      --비표준 전체 조인: UNION을 이용
      --비표준 왼쪽 외부 조인: (+)가 오른쪽으로 간다.
      SELECT
      FROM emp, dept
      WHERE emp.deptno = dept.deptno(+); 
      UNION
      SELECT
      FROM emp, dept
      WHERE emp.deptno(+) = dept.deptno; 
      ```

  - 표준: RIGHT OUTER JOIN, LEFT OUTER JOIN, FULL OUTER JOIN

    - 전체 외부 조인을 사용할 수 있다.

    - 형식

      ```plsql
      --표준 RIGHT OUTER JOIN
      SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
      FROM emp RIGHT OUTER JOIN dept ON emp.deptno = dept.deptno;
      --표준 LEFT OUTER JOIN
      SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
      FROM emp LEFT OUTER JOIN dept ON emp.deptno = dept.deptno;
      --표준 외부 조인
      SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
      FROM emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno;
      ```

### 7. 자체 조인

------

- **자체 조인, SELF JOIN**

  - 하나의 테이블을 여러개의 테이블처럼 활용하는 것
  - 자체 조인은 반드시 식별자를 사용해야 한다.

- 예

  ```plsql
  --자체 조인, SELF JOIN
  --비표준
  SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
  FROM emp 부하, emp 상사 --자체조인은 반드시 별칭을 사용해야 한다.
  WHERE 상사.empno = 부하.mgr(+); --부하의 메니저가 상사의 사원번호와 일치한다면 
  --표준
  SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
  FROM emp 부하 INNER JOIN emp 상사 ON 부하.mgr = 상사.empno; --자체조인은 반드시 별칭을 사용해야 한다.
  --상사가 없는 mgr은 정보가 없다 --> 외부 조인으로 살펴보자
  ```

### 8. 3개 이상의 테이블을 조인하는 경우

------

- 비표준 조인에서 3개 이상의 테이블을 조인하는 경우 WHERE절에 간단히 조건을 사용하면 된다.

  - 옆으로 계속 붙인다.

  ```plsql
  SELECT grade
  FROM emp e, dept d, salgrade s
  WHERE e.deptno = d.deptno AND e.sal BETWEEN losal AND hisal;
  ```

- 표준 조인에서는 조인의 조건을 추가로 작성하면 된다. 

  ```plsql
  SELECT grade
  FROM emp e INNER JOIN dept d 
  ```

- 조인 문제:

  ```plsql
  모든 부서 정보, 사원 정보, 급여 등급 정보, 각 사원의 직속 상관의 정보를 부서 번호, 사원 번호 순서로 정리하여 출력하라
  SELECT d.deptno, dname, a.ename, a.mgr, a.sal, b.deptno AS "상사 부서번호", s.losal, s.hisal, s.grade, b.empno AS "상사 사번", b.ename AS "상사 이름"
  FROM emp a, dept d, emp b, salgrade s --e는 부하, b는 상사
  WHERE (a.deptno(+) = d.deptno) AND (a.sal BETWEEN losal(+) AND hisal(+)) AND a.mgr = b.empno(+)
  --WHERE (e.deptno(+) = d.deptno)AND (e.sal BETWEEN losal(+) AND hisal(+)) AND e.mgr = b.empno(+)
  ORDER BY d.deptno ,a.empno;
  
  SELECT dept.deptno, dname, 부하.empno, 부하.ename, 부하.mgr, 상사.deptno, losal, hisal, grade, 상사.empno, 상사.ename
  FROM dept LEFT OUTER JOIN emp 부하 ON (부하.deptno = dept.deptno) 
       LEFT OUTER JOIN salgrade ON (부하.sal BETWEEN losal AND hisal)
      LEFT OUTER JOIN emp 상사 ON (부하.mgr = 상사.empno)    --셀프조인이면서 포괄조인
  ORDER BY dept.deptno, 부하.empno;
  ```

  

  