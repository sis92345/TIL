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

#### 	2.1 git repository 생성

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

### 3. git 파일 관리 명령어

#### 	3.1 삭제 명령어: git rm

- git rm (파일 이름): 로컬 디렉토리와 git 저장소에서 모두 해당하는 파일을 삭제한다.

    - 커밋을 해주어야 github에 반영

  ```git
  $git rm sample.txt
  ```

- git rm -r (폴더경로): 해당하는 폴더를 삭제한다.

  ```
  $git rm -r 정보처리기사
  ```

### 4. 로그 관련 명령어

- 커밋 히트로리를 확인할 때 사용한다.

  ```
  git log
  ```

- `git log` option

  1. `--oneline` : git에서 커밋 해시값, 커밋 아이디 , 커밋 이름 한 줄로 표현할 때 사용한다.

     ```
     git log --oneline
     
     
     4b5fb43 (HEAD -> master) 네번째 커밋
     569bc61 a.txt 수정
     376961b b.txt 추가
     97398b5 첫번째 커밋
     ```

### 5. checkout

- git에서 형상관리의 대상이 되는 `branch` , `commit` , `file`의 버전을 변경하는 명령어이다,

  - branch를 변경하는 명령어라고 생각할 수 있지만 ( 실제로 거의 브랜치 전환에 사용되는 명령어이다.  ) <u>정확히는 파일이나 커밋까지 checkout 할 수 있다</u>.

  - 한 명령어에서 많은 기능을 수행하므로 git이 업데이트 되면서 명령어를 분리했다. 

    - 브랜치 전환 : `git switch {변경할 브랜치}`
    - 워킹 트리 파일 복구 : `git master`

    #### 5-1. 브랜치 전환

    ```
    git checkout feature/video-sis92345 // feature/video-sis02345
    ```

    #### 5-2. 다른 커밋 버전의 파일로 변경

    ```
    git checkout {커밋 아이디} {파일 경로}
    ```

    #### 5-3. 다른 커밋으로 전환

    ```
    git checkout HEAD^2
    ```

