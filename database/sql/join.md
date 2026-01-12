JOIN
==========
> JOIN의 개념

> JOIN의 종류
>
> 교차 조인
>
> 등가 조인
>
> 비등가 조인
>
> 외부 조인
>
> 자체 조인
>
> 3개 이상을 조인하는 경우

### 1.조인의 개념
---------------
- **JOIN**

    - <u>조인은 두 개 이상의 테이블을 연결하여 하나의 테이블처럼 출력하는 것을 말한다.</u>

- JOIN과 집합 연산자의 다른 점

    - 집합 연산자: 집합 연산자는 SELECT절을 세로로 연결 한 것이다.
        - 따라서 집합 연산자의 대상이 되는 테이블들의 컬럼의 개수와 컬럼은 같아야 한다.
    - JOIN: JOIN은 여러 테이블을 하나의 테이블로 세로로 묶는다. 
        - 따라서 두 개의 테이블을 붙이면서 내가 원하는 칼럼만 출력할 수 있다.

- JOIN은 **비표준 조인**과 **표준 조인**이 다르다.

    - 조인 조건을 <u>WHERE절에 사용하면 비표준 조인</u>이다.

    - 조인 조건을 <u>FROM절에 사용하면 표준 조인</u>이다.

    - *비표준 조인은 오라클에서 사용하는 조인, 표준 조인은 그 외의 DBMS에서 사용하는 조인이다.*

    - 비표준 조인, 표준 조인에 사용하는 형식은 다르다: 조인 조건을 사용하는 곳에 유의

        ```plsql
        --비표준 조인의 예
        SELECT empno
        FROM emp, dept
        WHERE emp.deptno = dept.deptno AND deptno = 60; --비표준 조인은 조건을 WHERE절에 사용한다.
        --표준 조인의 예
        SELECT empno
        FROM emp INNER JOIN dept ON emp.deptno = dept.deptno -- 표준 조인은 조건을 FROM절에 사용한다.
        WHERE deptno = 60;
        ```

- **기본적인 JOIN의 규칙**

    - 여러 테이블에 공통된 컬럼을 SELECT절에 사용할 경우 명시해야 한다.

        - 단 하나의 테이블에만 존재하는 컬럼명의 경우 생략이 가능하다
    - **NATURAL JOIN, JOIN USING의 경우 조인 조건에 사용한 기준 열에 식별자를 사용할 수 없다.**
    
        ```plsql
        --SELECT deptno --> 오류, deptno는 두 테이블에 모두 존재한다.
        --FROM emp JOIN dept ON emp.deptno = dept.deptno;
        
        --여러 테이블에 공통된 컬럼을 SELECT절에 사용할 경우 명시해야 한다.
        SELECT dept.deptno
        FROM emp JOIN dept ON emp.deptno = dept.deptno;
    ```
    
- <u>JOIN으로 식별자를 사용할 수 있다. 단 기준 열에 식별자를 사용하면 안되는 것도 있다.</u>
    
    - 식별자는 두 컬럼에 공통된 값이 존재할 경우 반드시 명시해야 한다: 기준 열에 식별자가 사용 불가능 한 경우는 예외
    
        - 식별자  사용 가능: 비표준/표준 교차 조인, 비표준 등가조인, JOIN ~ ON
    
        - 식별자 사용 불가능: NATURAL JOIN, JOIN USING(기준열만)
    
    - 식별자 선언
    
        - `table_이름 OR table_별칭.Colunms`
    
            ```plsql
            SELECT empno, d.deptno --오류
            FROM dept d RIGHT OUTER JOIN emp e USING (deptno); --deptno는 조인 기준 열 이므로 식별자를 가질 수 없다. 
            
            --단 식별자를 가질 수 없는 JOIN도 기준 열 이외에는 식별자를 사용할 수 있다.
            
            SELECT e.empno,deptno --empno는 기준 열이 아니므로 식별자를 가질 수 있다.
            FROM dept d RIGHT OUTER JOIN emp e USING (deptno);
        ```
    
            

### 2  JOIN 의 종류
---------------
| JOIN                                                 | 비표준                        | 표준                                                         | 설명                                                       |
| ---------------------------------------------------- | ----------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------- |
| 교차조인(CROSS JOIN, Cartesian Product, 데카르트 곱) | 조인 조건이 없다.             | CROSS JOIN                                                   | 단순히 여러 테이블을 이어 붙인 것                          |
| 등가조인(Equi Join, Inner Join, Simple Join )        | = 로 조인 조건을 연결         | NATURAL JOIN, (INNER )JOIN USING, (INNRE) JOIN  ON           | 조인 조건으로 =을 사용하는 조인                            |
| 비등가조인(Non-Equi Join)                            | = 이외의 조인 조건을 사용     | (INNRE) JOIN  ON                                             | 조인 조건으로 =을 사용하지 않는 조인                       |
| 외부조인(Outer Join,포괄 조인)                       | 정보가 부족한 쪽에 (+)를 붙임 | RIGHT OUTER JOIN ON/USING, LEFT OUTER JOIN ON/USING,, FULL OUTER JOIN ON/USING, | 조인 기준 열의 어느 한쪽이 NULL이어도 강제로 출력하는 방식 |
| 자체조인(Self Join)                                  | 자기 테이블을 연결            | INNER  JOIN ON                                               | 하나의 테이블을 여러개의 테이블처럼 활용하는 것            |



### 3. 교차 조인

------

- **교차조인, CROSS JOIN, Cartesian Product, 데카르트 곱**

- **교차 조인(Cartesian Product) 개념**

  - 단순히 두 테이블을 연결 시킨 것
  - **조인조건이 없을 경우 교차 조인이다.**
  - <u>교차 조인 열의 수 = 테이블 1의 행 개수 * 테이블 2의 행 개수</u>

- 교차 조인의 형식

  - 비표준: 단순히 테이블을 나열

    ```plsql
    SELECT *
    FROM table1, table2 
    --교차 조인은 조인 조건을 사용하지 않는다.
    ```

  - 표준: CROSS JOIN

    ```plsql
    SELECT *
    FROM table1 CROSS JOIN table2
    ```

- 교차 조인 시 주의점

  - 교차 조인은 각 FROM절에 명시한 각 테이블을 구성하는 행의 모든 경우의 수로 조합되어 출력된다,
    - 따라서 많은 데이터가 출력된다.

### 4. 등가 조인

------

**등가조인, Equi Join, 내부조인, 단순조인**

등가 조인(Equi Join, Inner Join)

- 가장 많이 사용하는 조인

- 두개의 테이블을 `=`연산자를 사용해서 연결하면 등가 조인이다.

- 등가 조인이 필요한 경우

  ```plsql
  -- 스미스는 어느 위치에 있는 어느 부서에서 일하는가?
  -- 어느 부서?
  SELECT ename, deptno
  FROM emp
  WHERE ename = 'SMITH';
  -- 어느 위치?
  SELECT deptno, loc
  FROM dept
  WHERE deptno = 20;
  -- 즉 어느 부서 = emp 테이블, 그 부서의 위치 = dept 테이블
  -- 위 두개의 결과를 하나의 SELECT문으로 표현하기 위해서 등가조인을 사용: 스미스는 어느 위치에 있는 어느 부서에서 일하는가?
  SELECT ename, emp.deptno, dname, loc
  FROM emp, dept
  WHERE emp.deptno = dept.deptno AND ename = 'SMITH';
  ```

등가 조인의 형식

- 비표준: `=`를 WHERE에 사용

  - WHERE절에 조인 할 테이블을 =으로 연결 한다.

  ```plsql
  SELECT empno, d.deptno, job, sal
  FROM emp e, dept d
  WHERE e.deptno = d.deptno AND sal >= 2000;-- AND뒤의 조건은 조인 조건이 아니다.
  ```

- 표준: NATURAL JOIN, JOIN ~ USING, JOIN ~ ON

  - **NATURAL JOIN**

    - 조인된 테이블을 검색해서 공통된 컬럼을 감지, 연결한다. 

    - 형식: `table1 NATURAL JOIN table2`
  
      ```plsql
      SELECT empno, deptno, job, sal -- NATURAL JOIN은 공통된 칼럼에 특별히 값을 식별자를 사용 할 필요가 없다.
    FROM emp NATURAL JOIN dept -- 자동으로 테이블을 연결한다.
      WHERE sal >= 2000; --이 조건은 조인 조건이 아니다.
    ```
  
  - `=`으로 연결해야 하는 공통 컬럼을 자동으로 연결한다. 
  
  - 주의점: 
  
    - **NATURAL JOIN에 사용된 기준열에 식별자를 사용할 수 없다.**
  
    - 만약 공통 컬럼이 2개 이상인 경우 그 2개 모두 --> 확인
  
- **JOIN ~ USING**
  
  - NATURAL JOIN과는 다르게 USING에 조인 기준으로 사용할 열을 명시한다.
  
  - 형식: `table1 (INNER) JOIN table2 USING (조인 기준 열)`
  
  - USING뒤 ()안에 기준으로 사용할 열을 입력한다.
  
    - 주의점: JOIN USING에 사용되는 기준열은 식별자를 사용할 수 없다.
  
      ```plsql
    SELECT *
      FROM emp JOIN USING (deptno)
    ```
  
  - **JOIN ~ ON**
  
    - 형식: `table1 (INNER)JOIN table2 ON 조인 조건`
    
    - 식별자르 사용할 수 있다.
    
    - 비표준 등가 조인의 WHERE절에 사용하는 조인 조건을 ON 뒤에 사용한다.
    
      ```plsql
      SELECT
      FROM TABLE1 (INNER) JOIN TABLE2 ON 조건
      WHERE 
      ```
  
- JOIN 비교

  ```plsql
  -- JOIN ~ ON
  -- 직무가 SALESMAN, CLERK, MANAGER인 사원 중 월급이 2000이상인 사원의 사번, 이름, 직무, 월급, 부서 이름, 부서 위치, 부서 번호를 출력하시오
  --기존 비표준 등가 조인
  SELECT empno, ename, job, sal, dname, loc, dept.deptno
  FROM emp, dept
  WHERE emp.deptno = dept.deptno AND sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
  
  -- 표준 NATURAL JOIN 이용
  SELECT empno, ename, job, sal, dname, loc, deptno
  FROM emp NATURAL JOIN dept
  WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
  -- 표준 JOIN ~ USING이용
  SELECT empno, ename, job, sal, dname, loc, deptno
  FROM emp INNER JOIN dept USING (deptno)
  WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
  -- 표준: JOIN ~ ON 이용
  SELECT empno, ename, job, sal, dname, loc, dept.deptno
  FROM emp INNER JOIN dept ON emp.deptno = dept.deptno -- ON 조건
  WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
  ```

### 5. 비등가 조인

------

- **비등가 조인(Non-Equi Join)**

  - 조인의 조건이 `=` 이외의 조건을 사용할 때가 비등가 조인이다.

- 비등가 조인의 형식

  - 표준: WHERE절에 `=`이외의 조인 조건을 사용
  - 비표준: JOIN ~ ON (`=`이외의 조인 조건)

- 비등가 조인의 예

  ```plsql
  -- 비표준 비등가 조인
  SELECT empno, ename, sal, grade 
  FROM emp , salgrade 
  --WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
  WHERE sal >= losal AND sal <= hisal;
  --표준 비등가 조인: JOIN ~ ON 사용
  SELECT empno, ename, sal, grade 
  FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;
  ```

- 문제

  ```plsql
  -- 급여가 2000불 이상인 사람의 사번, 이름, 급여, 급여 등급을 출력하라
  --비표준
  SELECT empno, ename, emp.sal, salgrade
  FROM emp, dept
  WHERE emp.sal BETWEEN losal AND hisal;
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

  

  