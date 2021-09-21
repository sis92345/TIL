git : PermissionDenied
==========

>  개요
>
> 

### 1. 개요

---------------

- 오랜만에 git을 IntelliJ 자체 기능이 아니라 zsh 쉘에서 commit , push 하려고 하는데 다음과 같은 오류가 발생했다.

  > remote: Permission to `https://${username}@github.com/${username}/${repository}.git` denied to xxxx.
  >
  > fatal: unable to access `https://${username}@github.com/${username}/${repository}.git`: The requested URL returned error: 403

- 이 오류는 코드를 푸쉬할 때 해당 주소에 대한 권한이 없기 때문에 403을 리턴하는 문제이다. 크게 ssh와 관련된 문제 , 인증 관련 문제일 수 있는데 이와 관련되서는 따로 링크를 남긴다. 오히려 여기서 보는게 좋을 것 같고 ㅎㅎ

  - ssh : https://recoveryman.tistory.com/392
  - Auth : https://cheonjoosung.github.io/blog/git-push-error

- 다만 2021년 부터(정확히는 2020-08-13)부터는 git 작업을 인증할 때 계정암호를 허용하지 않는다. 따라서 remote repository에 push할 때 password로 github password를 사용하면 다음과 같은 오류가 발생한다.

  > remote: Support for password authentication was removed on August 13, 2021. Please use a personal access token instead.
  > remote: Please see https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/ for more information.
  > fatal: Authentication failed for `https://${username}@github.com/${username}/${repository}.git`

- 실제로 저 2개 링크는 20년도 8월 이전글이다. 만약 git 인증으로 access token을 사용한다면 

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