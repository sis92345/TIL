git
==========
[git logo]: https://media.vlpt.us/images/jivyyyy/post/1e1374ba-f4c1-4d03-b47b-00dc38975841/GT.png
### 1. git이란  
---------------
- git 이란
 + 형상관리도구(Configguration Management Tool)으로 버전 관리 시스템
- git과 github
    + git: 형상 관리 도구
    + github: 형상 관리 도구 웹 호스팅 서비스
    + > 즉 git은 로컬 저장소에서 버전 관리 시스템을 운영하는 방식이고, github은 저장소를 깃허브에서 제공해주는 클라우드 서비스를 이용한다.
   
### 2. git 명령어
---------------
#### 2.1 git repository 생성 
---------------
- ### git init
    +  git init: 로컬 저장소 구성을 위한 .git 폴더가 생성
        ```
        $git init
        ```
- ### git config
    +  git config: github 계정 정보를 설정하는 명령어
        ```
        $git config --global user.name "username"
        $git config --global user.name "username"
        ```
    + 만약 프로젝트마다 다른 계정을 사용하고 싶다면 --global 옵션을 제거하면 된다.
        ```
        $git config user.name "username"
        $git config user.name "username"
        ```
