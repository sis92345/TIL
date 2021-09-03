Mapped Statements collection does not contain value for ~ 오류
==========

>  개요
>
> 

### 1. 개요

---------------

- 프로젝트 진행 중 다음과 같은 오류가 발생했다. `Mapped Statements collection does not contain value for com.~~~.deviceDAO.listAll` 이 에러는 쿼리문을 기술한 Mapper 파일(.xml)에서 쿼리문이 아닌 Mapper 파일 자체에서 오타나 오류가 있을 때 발생하는 오류다. 만약 쿼리문에 문제가 있다면 `SqlExecption`을  구글에 검색하면 이 오류가 나오는 원인이 5개가 나오는데 결론부터 말하면 검색하면 나오는 5개 오류가 아니여서 문제였다.... 😂 


### 2. Mapped Statements collection does not contain value for~ 가 나올 수 있는 5가지 케이스

- 그래도 이 오류가 자주 발생하는 5가지 원인은 아래 블로그를 참조하면 된다. 이 경우는 Mapper 파일 설정, 작성 시 발생하는 문제이기도 하고 , 디버깅 이나 테스트를 진행하면 대부분 잡을 수 있기에 따로 적지는 않는다.

  - https://solog4something.tistory.com/m/65?category=859913

- Case

  1. mapper id가 다를경우
     - mapper파일(MyBatis의 쿼리문을 등록한 XML파일)에 <select id=''.. 에 id와 
     - mapper파일에 직접 접근하는 java파일(DAO나 service)에 적어놓은 id값이 다른 경우 

  2. Parameter와 bean의 필드명이 틀린 경우

  3. mapper파일(MyBatis의 쿼리문을 등록한 XML파일)에 정의된 네임스페이스(namespace)와 

    mapper파일에 직접 접근하는 java파일(DAO나 service)에서 호출하는 **네임스페이스(namespace)**가 다를 경우

  4. MyBatis config파일에 mapper가 정의가 되어 있지 않거나 Spelling이 틀린 경우

  5. mapper에 정의된 namespace 명칭이 같은 Application 내에 중복 될 경우

- 추가 정보 : namespace

  - Mapper.xml은 MyBatis에서 CRUD SQL 문을 구성하기 위한 일련의 쿼리문이 포함된 문서이다. 이 Mapper.xml이 여러개 일 경우 각 Mapper.xml을 구분하는 식별자가 필요한데 이 역할을 namespace를 이용한다.

### 3.  오류 발생 원인

- 그런데 저  5가지 오류가 아닐경우 , 즉 Mapper를 잘 작성했음에도 이 오류가 뜬다면 빌드 문제일 확률이 높다. 내가 발생했던 문제가 바로 이 부분이었는데 빌드할 때 .xml 파일이 빌드가 안되는 문제였다. Mapper 파일을 resoure 내부가 아니라 java package에 작성했는데 이 경우에는 xml 파일 빌드가 정상적으로 되지 않는다.

  <img width="182" alt="mapper" src="https://user-images.githubusercontent.com/68282095/132023042-c535ab6e-67ad-42f8-8493-b67f4eb74832.PNG">

- service.impl.sql.test에 board.xml이 있지만 target에 빌드가 되지 않았다. 이 문제를 해결하는 방법은 2가지가 있다.

  1. Mapper 파일을 resource 내부로 옮긴다.

     - 프로젝트를 크게 건들지만 권장하는 설정이다. 하지만 나처럼 프로젝트 구조를 바꾸기 힘든 상황이라면 pom.xml에 다음의 설정을 추가하면 된다.

  2. pom.xml 빌드 설정 추가

     ```xml
     <!-- 프로젝트 빌드 정보 -->
     <build> 
         <!-- 선택 : resource 정보 기제 -->
         <resources> 
             <resource> 
                 <directory>src/main/resources</directory> 
             </resource> 
             <resource> 
                 <directory>src/main/java</directory> 
                 <includes> <!-- src/main/java 안에 있는 모든 xml 파일을 빌드 -->
                     <include>**/*.xml</include> 
                 </includes> 
             </resource> 
         </resources> 
     </build>
     ```

     빌드 완료 후 target에 xml 파일이 빌드 했음을 볼 수 있다.

     <img width="125" alt="mapper" src="https://user-images.githubusercontent.com/68282095/132024201-4b0727b0-1128-4cc3-a2da-dd865765483b.PNG">