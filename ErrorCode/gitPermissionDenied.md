git : PermissionDenied
==========

### 1. 문제 및 해결

---------------

- 오랜만에 git을 IntelliJ 자체 기능이 아니라 zsh 쉘에서 commit , push 하려고 하는데 다음과 같은 오류가 발생했다.

  > remote: Permission to `https://${username}@github.com/${username}/${repository}.git` denied to xxxx.
  >
  > fatal: unable to access `https://${username}@github.com/${username}/${repository}.git`: The requested URL returned error: 403

- 이 오류는 코드를 푸쉬할 때 해당 주소에 대한 권한이 없기 때문에 403을 리턴하는 문제이다. 크게 ssh와 관련된 문제 , 인증 관련 문제일 수 있는데 이와 관련되서는 따로 링크를 남긴다. 오히려 여기서 보는게 좋을 것 같고 ㅎㅎ

  - ssh : https://recoveryman.tistory.com/392
  - Auth : https://cheonjoosung.github.io/blog/git-push-error

- **다만 2021년 부터(정확히는 2020-08-13)부터는 git 작업을 인증할 때 계정암호를 허용하지 않는다**. 따라서 remote repository에 push할 때 password로 github password를 사용하면 다음과 같은 오류가 발생한다.

  > remote: Support for password authentication was removed on August 13, 2021. Please use a personal access token instead.
  > remote: Please see https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/ for more information.
  > fatal: Authentication failed for `https://${username}@github.com/${username}/${repository}.git`

- 실제로 저 2개 링크는 20년도 8월 이전글이다. **만약 git 인증으로 access token을 사용했는데 해당 토큰의 `Select Scopes`로 권한을 설정하지 않았을 경우 위 Permission denied 오류가 똑같이 발생한다. 이 문제를 해결하기 위해서는 해당 토큰의 권한에서 repo 권한을 설정하면 된다.** 추가로 간단하게 access token을 생성하는 방법을 올린다.

- repo 권한을 체크하면 다음과 같이 정상적으로 푸쉬할 수 있다.

  <img width="500" alt="스크린샷 2021-09-21 오후 1 20 23" src="https://user-images.githubusercontent.com/68282095/134111101-d6aa9607-0218-4a22-9b48-92f08b88a134.png">

### 2. git access token 생성

1. User setting으로 이동

   <img width="181" alt="스크린샷 2021-09-21 오후 12 58 32" src="https://user-images.githubusercontent.com/68282095/134109852-7fb27c8e-8733-4b5b-ba43-218f350b52c4.png">

2. Developer settings

   <img width="762" alt="스크린샷 2021-09-21 오후 12 59 16" src="https://user-images.githubusercontent.com/68282095/134109934-3545fd00-d2c2-4fe6-b763-f69fbecfbb62.png">

3. Personal access token을 클릭

   <img width="228" alt="스크린샷 2021-09-21 오후 12 59 44" src="https://user-images.githubusercontent.com/68282095/134110026-c41d09f7-e017-4e47-8a99-7deaed4ad2af.png">

4. Generate new token으로 새 토큰을 생성 , 기존 토큰을 클릭 시 해당 토큰 설정을 업데이트 할 수 있다.

   <img width="1040" alt="스크린샷 2021-09-21 오후 1 00 14" src="https://user-images.githubusercontent.com/68282095/134110069-eebc5f2c-986a-475f-9084-302826a31f4d.png">

5. 토큰 이름 , 토큰 만료 기간 , 토큰 권한을 설정한 뒤 저장하면 토큰이 생성된다.

   - 권한 관련 
     - repo : Repository 제어 권한 
       - Permission denied 문제가 발생한다면 토큰에 이 권한이 없을 경우가 높다.
     - workflow : GitHub workflow 업데이트 권한
     - package : GitHub package registry 업로드 , 다운로드, 삭제 권한
     - admin : org : org와 terms에 대한 제어 권한 
     - public key : public key 제어 권한
     - gist : gist 생성 권한
     - notification : notification 접근 권한
     - User : user 데이터 권한
     - delete repo : repository 삭제 권한
     - discussion : discussion 작성 , 접근 권한 

   <img width="1072" alt="스크린샷 2021-09-21 오후 1 00 44" src="https://user-images.githubusercontent.com/68282095/134110151-86f30f9d-4d7b-4f3a-9d1f-65c2feb59bc2.png">

6. 생성된 토큰값을 확인할 수 있다. 단 한번만 확인할 수 있으므로 따로 저장해둔다, 그래도 잊어버리면 토큰을 재생성 할 수 있긴하다.

