# Mac 개발 환경 설정

### 1. Java 설치

- 설치는 윈도우와 똑같다. `java -version` 을 터미널에서 입력했을때 오류가 난다면 자바를 설치한 후 환경 변수만 잡아주면 된다.

- 환경 변수 설정 

  - Mac은 기본 shell로 zsh를 사용한다.

    - Catalina이전에는 bash를, 그 이후에는 zsr 쉘을 사용한다,

      - zsr 의 환경 설정은 zhsrc에서 한다.

    - 따라서 vi 편집기로 환경변수를 등록할 필요가 있다.

      1. 홈 최상위 디렉토리에 zsh 설정 파일을 설정	

         ```
         vi ~/.zshrc	
         ```

      2. 자바 환경 변수 설정을 추가

         ```
         export PATH=${PATH}:/Library/Java/JavaVirtualMachines/jdk1.8.0_301.jdk/Contents/Home/bin
         ```

      3. 설정을 확인 : `java -version , javac -version`

### 2. Homebrew 설치

- 루비기반 Mac 패키지 설치 관리자
  - 공식 문서 : https://docs.brew.sh

- 설치 과정

  1. 다음을 터미널에 입력

     ```
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```

  2. 설치 후 설정

     ```
     echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/anbyeonghyeon/.zprofile
         eval "$(/opt/homebrew/bin/brew shellenv)"
     ```

- homebrew와 관련된 정보

  - 페키지는 홈브류에서 `formulae` 라고 한다

  - 포뮬라와 관련된 명령어는 다음과 같다

    1. `brew search ${formulae}` : 포뮬라를 검색한다.
    2. `brew install ${formulae}` : 포뮬라를 설치한다.
    3. `brew cask install ${formulae}` : GUI application을 설치한다.
    4. `brew info ${formulae}` :  해당 포뮬라 정보를 조회한다.
    5. `brew remove ${formulae}` : 해당 포뮬라를 삭제한다.
    6. `brew list` : 설치된 포뮬라를 조회한다.

  - homebrew와 관련된 명령어는 다음과 같다

    1. `brew update`: 홈브류를 업데이트 한다.
    2. `brew update ${formulae}` : 해당 포뮬라를 업데이트한다. 

  - 예 : `node.js` 설치

    ```
    #노드 관련 포뮬라 검색
    brew search node 
    
    #노드 설치
    brew install node
    ```

    

### 3. zsh 설정

- zsh를 좀 더 편하게 사용하기 위해 `on-my-zsh`를 설치한다.

- 설치

  ```
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- Theme 설정 : 보통 argoster를 많이 사용한다.

  ```
  ZSH_THEME='argoster'
  ```

  

### 4. Iterm2 설정

- 터미널을 꾸미기 위한 설정이다.
- https://ooeunz.tistory.com/21를 참고

### 5. mySql 설치

- homebrew를 통해서 쉽게 설치할 수 있다.

  - `brew search mysql`를 입력한다 : 설치할 수 있는 정보들을 조회할 수 있다.

  - `brew install mysql` : 검색한 결과 중 특별히 설치하고 싶은게 없으면 바로 다운로드 한다,
  - 다운로드가 완료되면 mySql설정을 진행한다

- mySql 서버 명령어 : 맥 기준

  - mysql.server start : 서버 시작
  - mysql.server restart : 서버 재시작