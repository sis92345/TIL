# GIT PULL할 때 로컬 워크 스페이스를 원격 저장소 데이터로 강제로 덮어 쓰기

- git에서 원격 저장소의 데이터를 워크스페이스를 가져오기 위해서 pull 명령어를 사용한다

  - 만약 데이터를 반영 할 local repository의 branch에 pull할 경우 다음 두 경우가 발생한다
    - local repository branch에 커밋이 없을 경우 : fast-forward 병합
    - local repository branch에 커밋이 없을 경우 : 3 way merge 

  ```
  git pull // remote Repository의 데이터를 workspace에 반영
  ```

  - pull은 fetch와 merge가 합져진 명령어라고 생각하면 된다. 보통 remote repository에서 가져온 데이터 local repository에서 확인 후 merge를 할 필요가 있을 때 사용한다. <u>이 개념을 이용해서 remote repository에 있는 데이터로 workspace를 덮어쓸 수 있다</u>. `git fetch --all`로 remote의 모든 데이터를 가져온다. 그 후 브렌치 해드를 reset 하면 된다

  ```
  git fetch --all
  ```

  ```
  git reset --hard origin/develop // remote repository의 head로 local repository head를 이동
  ```

  ```
  git pull // 확인
  ```

  

