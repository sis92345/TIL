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

### 3. git branch 조작

------

#### 3.1. branch 생성과 삭제: checkout -b & branch -delete

------

- Git branch를 생성하고 삭제하는 명령어이다.

- 생성, 삭제한  branch를 원격 remote branch에 반영하기 위해서는 push를 해야한다.

  - push를 하지 않으면 로컬 저장소에만 결과가 반영된다.

- branch 생성

  ```
  git checkout -b feature-01
  git push origin feature-01
  git branch --set-upstream-to origin/feature-01 //브랜치 연동
  ```

- branch 삭제

  - branch를 삭제하고자 할 때는 다른 branch로 이동한 다음 삭제 명령어를 사용한다.
  - 예를 들어 main과 master branch가 있고 master branch를 삭제해보자

  ```
  git checkout master //master branch로 이동
  git branch --delete main //main branch 삭제
  git branch --D main //main branch를 강제 삭제
  git push web :main //push
  ```

   

#### 3.2. branch 이동: checkout

------

- `git checkout [branch_name]`: 해당하는 브렌치로 이동

### 4. git 파일 관리 명령어

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

  

