# restore를 이용한 git file 조작

프로젝트를 진행하던 도중 내가 원하는 설정을 로컬에 세팅하려면 공통 파일을 수정해야할 일이 생긴다. 당연히 이때 해당 설정이 있는 파일을 commit, push하면 안되지만 수정한 간 index파일에 올라가므로 다른 작업을 커밋할 때 거슬리는 문제가 생겼던 일이 몇몇 있었다.

이런 상황을 restore를 사용해서 처리할 수 있다. 

**restore는 복원 위치를 지정할 수 있다. ** --stage, --worktree로 복원 위치를 지정할 수 있으며 아무 옵션이 지정되지 않으면 worktree에서 복원한다. 두 옵션을 같이 사용할 수 있다.

**--source와 --stage 옵션을 사용할 수 있으며 기본적으로 --staged가 지정되면 내용이 HEAD에서 복원되고 그렇지 않으면 인덱스에서 복원된다**.

1. 기본 명령어로 현재 디렉토리의 모든 파일을 복구한다.

   ```shell
   git restore <pathspec>
   ```

2. stage된 파일을 HEAD Commit으로 복구한다.

   ```shell
   git --staged <pathspec> 
   ```

   새로운 파일이라면 index에서 unstage된다.

   <img width="684" alt="스크린샷 2022-05-13 오전 12 39 29" src="https://user-images.githubusercontent.com/68282095/168114463-1b985263-0e7c-4ba7-94cf-a356aa79eb2a.png">

3. 파일을 특정 Commit으로 복구

   ```shell
   git --source <commithash> <filename>
   ```

4. --worktree 옵션을 사용하면 worktree에서 복구된다.

   ```shell
   git restore --worktree <filename>
   ```

간단한 예

1. 모든 파일을 복구하려면

   ```shell
   git restore . 
   ```

2. Head Commit으로 복원하려면

   ```shell
   git restore --stage /src/a.java
   ```