# PLSQL

> PLSQL의 개념
>
> PLSQL의 기본

> Stored Procedure
>
> CURSOR

## 1. PLSQL의 개념

------

- **PL/SQL(Stands For Procedural Language Extension to Structured Query Language)**
  - 기존의 SQL만으로 처리하기 어렵거나 구현 불가능한 작업을 수행하기 위해 오라클에서 제공하는 프로그래밍 언어로 기존의 SQL에 절차적인 프로그래밍 언어를 가미했다.
- PLSQL의 장점
  - 장점
    - *네트워크 트레픽 감소, 시스템 응답시간 향상*
      - 네트워크를 통한 라운드 트립(서버와 클라이언트간의 데이터 왕복 과정)이 최소화
        - PLSQL을 이용하여 서버에서 데이터를 처리하고, 클라이언트는 그 결과만 받아서 사용할 수 있다.
    - *여러 SQL문을 처리하는 것보다 응용프로그램의 성능을 향상*
      - 여러 SQL 작업을 하나의 PLSQL문에 작성하고 필요할 때 마다 반복적으로 사용할 수 있다.
    - 모듈화 가능
    - 변수 선언 가능
    - 성능 향상
- PLSQL의 주의점
  1. DDL, DCL을 사용할 수 없다.
     - 오직 DML만 가능하다
  2. SELECT의 결과로 나와야 하는 ROW의 수는 1건이어야 한다.
     - CURSOR를 이용해서 이 문제를 해결한다.


## 2.  PLSQL의 기본

------

- **PLSQL의 블록**

  - 데이터베이스와 관련된 특정 작업을 수행하는 명령어와 실행에 필요한 여러 요소를 정의하는 명령어로 구성하며 이러한 명령어를 모아 둔 **PLSQL 프로그램의 기본 단위**

  - **이름이 없고 오직 블록으로만 구성된 PL/SQL을 익명 블록(Anonymous)이라고 한다.**

  - **구성 요소**

    1. <u>DECLARE: 선언부</u>

       - 선택

       - 실행에 사용될 변수, 상수, 커서 등을 선언

    2. <u>BEGIN: 실행부</u>

       - 필수
       - 조건문, 반복문, SELECT, DML, 함수 등을 정의

    3. <u>EXCEPTION: 예외부</u>

       - 선택
       - PLSQL 실행 도중 발생하는 오류를 해결하는 문장 

  - 블록의 예

    ```PLSQL
    DECLARE 
    	[실행에 필요한 요소 선언];
    BEGIN
    	[작업을 위한 실제 명령어]
    EXCEPTION
    	[예외 처리]
    END;
    ```

- PL/SQL의 실행

  - *SQLPLUS에서는 기본적으로 표준 출력이 막혀있다.*
    - `SET SERVEROUTPUT ON`을 이용해서 표준 출력을 사용할 수 있다.
    - 표준 출력 명령어: `DBMS_OUTPUT.PUT_LINE('출력내용');`
    - SQLPLUS에서는 ed.명령어로 SQL BUFFER를 이용해서 처리하는게 편하다.

## 3. 

------

- 

  



## 3.  PRIMARY KEY

------

- 파일 및 교재: p.377 ~, 12.Constraints.pdf


## 5. exerd

------

- 파일 및 교재: p.323 ~ 



## 6.  NOTNULL

------

- 파일 및 교재: 12.Constraints.pdf, P.362 ~

  


## 7.  MVC

------

- 파일 및 교재: basic_sources/환자관리프로젝트

## 8.  DDL 문제

------

- 파일 및 교재: p.324


## 9. 제약 조건

------

- 파일 및 교재: p.360 ~ 

## 10. UML 관계

------

- 파일 및 교재: Day39의 .cld파일을 반드시 볼 것
  

## 11. MVC

------

- JAR파일로 만들어 TEMP에 위치
