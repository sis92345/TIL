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

- `zsh`의 주요 기능
  - 경로 자동 완성
    - `~/Document/00.Repository/TIL`은 `doc/00/TIL` + `TAB`ㅇㅡ로 자동으로 완성된다.
  - 타이핑 교정
    - `git abd`로 잘못 입력하면 가장 유사한 명령어를 알려준다,
  - 명령어 추천
    - `git a`를 입력하고 탭을 누르면 명령어를 추천한다. 탭을 눌러서 각 명령어를 이동할 수 있고 return키로 명령어를 선택할 수 있다.

### 4. Iterm2

### 4. Iterm2 설정

- Mac에서 터미널을 보조 , 대체할 수 있는 application이다.

- https://ooeunz.tistory.com/21를 참고하면 좋다

- iterm2에서 한글이 깨지는 문제 해결

  - 최초로 iterm2를 설치한 후 실행하면 한글이 깨져서 나온다. 이 문제가 발생하면 폰트를 바꿔주면 해결된다. 폰트는 네이버에서 나온 `D2Coding`을 추천한다. 
  - 설정 방법
    - Iterm2 -> preperence -> profile -> text -> font에서 수정한다. 밑에 한글 자소 분리 문제때문에 Unicode normlization form을 `NFC`로 변경하는 것을 추천한다,

- iterm2 한글 자소 분리 현상 원인

  `Window os` 와 `Mac os` 에서 유니코드를 처리하는 방식이 다르기 때문에 iterm2에서 한글 자소 분리 현상이 나타난다

  - `Window os` : `NFC` 방식으로 처리 
    - `NFD(Normalize Form C)` : 모든 음절을 Canonical Decomposition(정준 분해) 후 Canonical Composition(정준 결합)하는 방식 , 
      - 예 )  `ㄱ` + `ㅏ` + `ㄱ` -> `각` ,  `각` 에 해당하는 코드 포인트를 저장한다.
  - `Mac os` : `NFD` 방식으로 처리 
    - `NFD(Normalize Form D)` : 모든 음절을 Canonical Decomposition(정준 분해)하여 한글 자모 코드를 이용하여 저장하는 방식
      - 예 ) `각` -> `ㄱ` + `ㅏ` + `ㄱ` , 즉 3개의 코드 포인트를 저장한다.

- 자소 분리 현상 해결

  - Iterm2 -> preperenece -> profiles -> text -> Unicode normalization form을 NFC로 변경하면 된다,

- 터미널 `${user}@${user}-ui-MacbookPro`에서 이름만 남기기 + 커스터마이징

  - 각 테마 설정 파일에서 prompt_context를 수정하면 된다.

    ```
    prompt_context() {
      if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
      fi
    }
    ```

  - `agonostar` 테마 기준으로 설정 파일은 다음과 같다

    - 경로 : ` ~/.oh-my-zsh/theme/agnoster.zsh-theme`
    - 경로 파일을 vi 편집기로 열어서 prompt_context가 적힌 부분을 찾아서 기존 부분을 주석처리 하고 위 코드를 새로 입력한다,
    - `source  ~/.oh-my-zsh/theme/agnoster.zsh-theme`로 적용한다.

  - 개인적으로 사용하고 있는 커스터마이징 형식은 다음과 같다

    ```
    ### Prompt components
    # Each component will draw itself, and hide itself if no information needs to be shown
    
    # Context: user@hostname (who am I and where am I)
    
    ## Ver.Default : 기본 설정
    #prompt_context() {
    #  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    #    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
    #  fi
    #}
    
    ## Ver.NotShowName : 이름을 안보이고 싶을 때
    #prompt_context() {
    #  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    #    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    #  fi
    #}
    
    ## Ver.Emoji : 랜덤 이모지
    prompt_context() {
      emojis=("⚡️" "🔥" "🐱" "👑" "😎" "💻" "🍎" "🦄" "🌈" "🇰 🇷 " "🚀" "💡" "🎉" "🔑" "🚦" "🌙")
      RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
      prompt_segment black default "ted ${emojis[$RAND_EMOJI_N]} "
    }
    ```

    

- terminal new line 적용 

  - 코드가 창을 넘어갈 때 newline을 생성하는 명령어

  - 각 테마 파일에서 작업하면 된다.

    - 경로 : ` ~/.oh-my-zsh/theme/agnoster.zsh-theme`

    - 경로 파일을 vi 편집기로 열어서 다음 코드를 추가

      ```
      prompt_newline() {
        if [[ -n $CURRENT_BG ]]; then
          echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR
      %{%k%F{blue}%}$SEGMENT_SEPARATOR"
        else
          echo -n "%{%k%}"
        fi
      
        echo -n "%{%f%}"
        CURRENT_BG=''
      }
      ```

  - Build_propmt의 prompt_hg와 prompt_end사이에 prompt_newline추가

  - `source  ~/.oh-my-zsh/theme/agnoster.zsh-theme`로 적용한다.

- Syntax highlighting 적용

  - 사용 가능한 명령어에 highlight를 넣어주는 기능이다.

- 최종 적용

  <img width="747" alt="최종적용" src="https://user-images.githubusercontent.com/68282095/134105377-092aa2fa-8e8e-4a19-951d-a3d1536ac0a9.png">

### 5. mySql 설치

- homebrew를 통해서 쉽게 설치할 수 있다.

  - `brew search mysql`를 입력한다 : 설치할 수 있는 정보들을 조회할 수 있다.

  - `brew install mysql` : 검색한 결과 중 특별히 설치하고 싶은게 없으면 바로 다운로드 한다,
  - 다운로드가 완료되면 mySql설정을 진행한다

- mySql 서버 명령어 : 맥 기준

  - mysql.server start : 서버 시작
  - mysql.server restart : 서버 재시작



