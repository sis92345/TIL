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

### 2. git 명령어:  생성과 관리
---------------
#### 	2.1 git repository 생성 
---------------
- ### git init
    +  git init: 로컬 저장소 구성을 위한 .git 폴더가 생성
        ```git
        $git init
        ```
- ### git config
    +  git config: github 계정 정보를 설정하는 명령어
        ```git
        $git config --global user.name "username"
        $git config --global user.name "username"
        ```
    + 만약 프로젝트마다 다른 계정을 사용하고 싶다면 --global 옵션을 제거하면 된다.
        ```git
        $git config user.name "username"
        $git config user.name "username"
        ```
    
    #### 2.2 git remote

------

- git remote: 프로젝트의 리모트 저장소를 관리하는 명령어

  - git remote -v: 현재 위치에 등록된 저장소 이름과 URL을 표기

    ```
    $git remote -v
    ```

  - git remote add (리모트 이름)(github 경로)

    ```
    $git remote add TILhttps://github.com/sis92345/TIL
    ```
    - 현재 위치하는 폴더에 해당하는 github 저장소를 설정한다.

  - git remote rm (리모트 이름): 해당하는 리모트 경로를 삭제한다.

    ```
    $git remote rm TIL
    ```

  - git remote show (리모트 이름): 해당하는 리모트 경로의 모든 branch와 정보를 표시

    ```
    $git remotr show TIL
    ```

3. git 파일 관리 명령어

------

#### 	3.1 삭제 명령어: git rm

------

- git rm (파일 이름): 로컬 디렉토리와 git 저장소에서 모두 해당하는 파일을 삭제한다.

  - 커밋을 해주어야 github에 반영

  ```git
  $git rm sample.txt
  ```

- git rm -r (폴더경로): 해당하는 폴더를 삭제한다.

  ```
  $git rm -r 정보처리기사
  ```

  

