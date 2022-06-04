# Git Config

git config 명령은 git의 기본적인 설정을 추가, 등록, 삭제할 수 있다. git을 처음 시작하면 

- `git config --global user.name=""`
-  `git config --global user.email=""`

git 설정은 --system -> --global -> --local 순으로 설정을 찾으며 해당 설정을 원하는 레벨로 맞출 수 있다.

1. `--system`
   - `$(prefix)/etc/gitconfig` 설정에 읽고 쓰기
2. ` --global`
   - `~/.gitconfig` 설정에 읽고 쓰기
3. `--local` 
   -  repository의 `git/config` 에 읽고 쓰기

명령어로 git의 이름과 이메일을 설정하는데 이번에 추가적인 설정을 진행하게 되어 추가적으로 정리하게 되었다.

# 2. SYNOPSIS

```shell
git config [<file-option>] [--type=<type>] [--fixed-value] [--show-origin] [--show-scope] [-z|--null] <name> [<value> [<value-pattern>]]
git config [<file-option>] [--type=<type>] --add <name> <value>
git config [<file-option>] [--type=<type>] [--fixed-value] --replace-all <name> <value> [<value-pattern>]
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] --get <name> [<value-pattern>]
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] --get-all <name> [<value-pattern>]
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] [--name-only] --get-regexp <name-regex> [<value-pattern>]
git config [<file-option>] [--type=<type>] [-z|--null] --get-urlmatch <name> <URL>
git config [<file-option>] [--fixed-value] --unset <name> [<value-pattern>]
git config [<file-option>] [--fixed-value] --unset-all <name> [<value-pattern>]
git config [<file-option>] --rename-section <old-name> <new-name>
git config [<file-option>] --remove-section <name>
git config [<file-option>] [--show-origin] [--show-scope] [-z|--null] [--name-only] -l | --list
git config [<file-option>] --get-color <name> [<default>]
git config [<file-option>] --get-colorbool <name> [<stdout-is-tty>]
git config [<file-option>] -e | --edit
```

# 3. Options

### 3-1. `--list` : 설정 목록 조회

- 설명 : 현재 git에 설정된 리스트를 불러옵니다.
- 예 : `git config --list`

### 3-2. 설정 등록

- 설명 : git 환경설정을 등록하는 방법이다.
- SYNOPSIS : `git config [<file-option>] [--type=<type>] [--fixed-value] [--show-origin] [--show-scope] [-z|--null] <name> [<value> [<value-pattern>]]`
- 예 : `git config --global user.name="ted"`

### 3-3. `--unset` : 설정 제거

- 설명: 등록된 설정을 제거한다 ( `~/.gitconfig` )
- 예 : `git config --global --unset <key>`

### 3-4. `--global` : 전역 설정 등록

- 설명 : 모든 repository에 전역적으로 등록한다. 

# 4. 실제 변경해야할 config 변수 모음

1. `core.excludeFile` : git에서 추적하지 않을 파일의 경로를 정의한 파일, 즉 `.gitignore`
   - .gitignore(디렉토리 단위) 및 .git/info/exclude와 함께 추적되지 않는 경로를 설명하는 패턴이 포함된 파일의 경로 이름을 지정합니다. 기본값은 $XDG_CONFIG_HOME/git/ignore입니다. $XDG_CONFIG_HOME이 설정되지 않았거나 비어 있으면 $HOME/.config/git/ignore가 대신 사용됩니다
2. `core.quotepath` : 값이 값이 0x80보다 큰 바이트이거나 제어문자일 경우 비주얼 문자를 사용하는 방식, 즉 이게 true이면 한글이  `\354\235\274\` 로 나온다.
   - 경로(예: ls-files, diff)를 출력하는 명령은 경로 이름을 큰따옴표로 묶고 C가 제어 문자(예: TAB의 경우 \t, LF의 경우 \n, 백슬래시의 경우 \\) 또는 값이 0x80보다 큰 바이트(예: octal\26)를 이스케이프하는 것과 같은 방식으로 백슬래시를 사용하여 경로 이름에 "비주얼" 문자를 인용합니다. UTF-8). 이 변수를 false로 설정하면 0x80보다 큰 바이트는 더 이상 "비정상"으로 간주되지 않습니다. 큰따옴표, 백슬래시 및 컨트롤 문자는 이 변수의 설정에 관계없이 항상 이스케이프됩니다. 단순한 공간 문자는 "비정상적"으로 간주되지 않는다. 많은 명령은 -z 옵션을 사용하여 완전히 정확한 경로 이름을 출력할 수 있습니다. 기본값은 true입니다.

# 5. 예제 : git 전역 ignore 파일 설정

전체 repository에서 사용할 수 있는 gitignore 파일을 생성하고 전역으로 등록하자

1. .gitignore 파일을 설정한다.

   ```shell
   vim ~/.gitignore
   ```

2. 필요한 설정을 진행한다.

   ```shell
    1 .gitignore                                                                    X
    # DS_STORE 파일 > MAC 폴더 접근 파일
    **/.DS_Store
   
    # gitignore
    **/.gitignore
   ```

3. `config` 명령어로 전역 설정으로 등록한다.

   - 필요한 설정은 `core.excludesFile` 이다.

   ```shell
   git config --global core.excludesFile="~/.gitignore"
   ```

### 99. 유용한 문서

1. [git 맞춤 설정](https://git-scm.com/book/ko/v2/Git%EB%A7%9E%EC%B6%A4-Git-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0)