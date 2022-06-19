# NVM을 사용한 Node Version 관리

최근 회사와 토이프로젝트에서 사용하는 노드 버전이 달라서 nvm으로 사용해야 겠다는 결심이 들어서 이번에 nvm 관련 정보를 정리한다. 회사에서 사용하는 node 버전에 v14였고, 토이 프로젝트에서 v16을 사용해야 했다. 

# MAC 에서 NVM 설치

1. brew에서 설치

   ```shell
   brew install nvm
   ```

2. 설치가 완료되면 자체적인 스크립트로 실행에 필요한 변수나 환경가 /.zshrc에 정의된다. `source ~/.zhsrc`를 사용하자.

   ```shell
    #Node Version Manager
    #export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm               bash_completion
   ```

3. 현재 노드 버전을 확인한다.

   ```shell
   node --version
   ```

4. 다음 명령어를 사용해서 로컬의 현재 노드 버전을 확인할 수 있다.

   ```shell
   nvm ls
   ```

   ```shell
   
            system
   default -> v14.18.1
   iojs -> N/A (default)
   unstable -> N/A (default)
   node -> stable (-> v16.15.1) (default)
   stable -> 16.15 (-> v16.15.1) (default)
   lts/* -> lts/gallium (-> v16.15.1)
   lts/argon -> v4.9.1 (-> N/A)
   lts/boron -> v6.17.1 (-> N/A)
   lts/carbon -> v8.17.0 (-> N/A)
   lts/dubnium -> v10.24.1 (-> N/A)
   lts/erbium -> v12.22.12 (-> N/A)
   lts/fermium -> v14.19.3
   lts/gallium -> v16.15.1
   ```

   - 현재 system 상 node version은 14.18.2이다. 이를 최신 버전인 16.15.1로 설치해서 변경한다.

5. nvm를 사용해서 설치할 수 있는 노드 버전 리스트를 확인한다.

   ```shell
   nvm ls-remote
   ```

   - 설치 가능한  node 16의 버전을 확인한다.

     - [ ] ```shell
       nvm ls-remote 16 --lts
       ```

6. 설치한 node 16버전을 계속 사용하기 위해서 default 버전을 변경한다.

   ```shell
    nvm alias default v16.15.1
   ```

7. 이제 nvm ls와 실제 node 명령어를 확인하자. 내가 로컬에서 사용할 수 있는 버전과 default node version을 확인할 수 있다.

   ```shell
   npm ls
   node --version
   ```

   ```shell
          v14.18.2
          v14.19.3
   ->     v16.15.1
            system
   default -> v16.15.1
   iojs -> N/A (default)
   unstable -> N/A (default)
   node -> stable (-> v16.15.1) (default)
   stable -> 16.15 (-> v16.15.1) (default)
   ```

   ```shell
   v16.15.1
   ```

# NVM 명령어

### nvm ls
로컬에 설치된 node의 목록을 가져온다.
```shell
  nvm ls
```

### nvm ls-remote
remote에서 설치 가능한 node 목록
   - option
     - node version ( `nvm ls-remote 16` ): node vesion 16 중 설치 가능한 목록을 가져옵니다.
     - `--lts` ( `nvm ls-remote 16 --lts` ): 최신 버전을 가져옵니다.
```shell
   nvm ls-remote <node version> <-- lts>
```

# 관련 문서

1. [NVM 공식 Git](https://github.com/nvm-sh/nvm)