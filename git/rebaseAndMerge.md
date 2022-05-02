# Rebase와 Merge

이번 프로젝트에 git flow로 협업을 진행했는데 다른 브랜치와 병합을 대부분 merge로 진행하였다. 이때 약간 거슬리는 문제가 발생하였는데 불필요한 merge 커밋이 발생하고 커밋 히스토리가 어지러워져서 rebase와 merge의 차이점을 구분하고 왜 어떨 때 쓰는 건지 알기 위해서 이번 글을 작성하였다.

## Merge와 Rebase가 무엇일까?

git은 작업을 해야할 때 브랜치를 생성하고 , 브랜치로 체크아웃해서 해당 브랜치에 커밋을 해서 작업한다. 기능이 완성되었다면 브랜치를 분기한 브랜치로 다시 체크아웃 한 후 작업한 브랜치와 분기된 브랜치의 코드를 병합해야하는 작업이 필요하다. 이때 git에서 병합을 위한 명령어가 바로 `merge` 와 `rebase` 이다.

```
git merge feature/child-server-sis92345
git rebase develop
```

### merge와. rebase는 브랜치 병합을 수행한다는 목적은 같지만 병합을 수행하는 방법이 다르다.

> merge는 <u>현재브랜치</u>에서 [병합하고자하는 브랜치]의 <u>변경사항을 병합</u>한다

> rebase는 <u>베이스를 재배치</u> 한다

### merge 개요

merge는 <u>현재브랜치</u>에서 [병합하고자하는 브랜치]의 <u>변경사항을 병합</u>한다. merge는 여러 종류가 있지만 99%는 아래 merge를 사용한다.

- `fast-forward-merge` : 현재브랜치의 커밋이 없을 경우 현재 브랜치의 `head`를 병합하고자 하는 브랜치의 `head`로 옮기는 merge
- `3-way-merge` : 현재 브랜치의 커밋과 병합하고자하는 브랜치의 조상 커밋이 다를 경우 공통 조상 커밋을 사용하여 병합을 진행하는 merge이다. 즉 <u>현재 브랜치의 head</u>, <u>병합하고자 하는 브랜치의 head</u>, <u>공통 조상 커밋(base)</u>를 사용하기 때문에 3 way merge

### Fast-forward merge의 예

<img width="874" alt="스크린샷 2021-10-17 오후 3 22 45" src="https://user-images.githubusercontent.com/68282095/137614375-1d402697-c431-4637-8101-e87210c13c29.png">

- 위 상황에서 master 브랜치의 커밋이 없으므로 master와 dev를 merge하면 fast-forward merge가 진행된다

  <img width="881" alt="스크린샷 2021-10-17 오후 3 23 08" src="https://user-images.githubusercontent.com/68282095/137615082-bfb9c257-3fbe-42af-a674-ab97ab190740.png">

  - Fast-forward merge가 진행된 예

  <img width="659" alt="스크린샷 2021-10-17 오후 3 43 15" src="https://user-images.githubusercontent.com/68282095/137614988-73ea2507-ec51-446e-8407-80618149a55c.png">

  <img width="657" alt="스크린샷 2021-10-17 오후 3 45 51" src="https://user-images.githubusercontent.com/68282095/137615049-3106fb6b-54fe-4b55-86c0-eb11c66ce6a2.png">

### 3 way merge의 예

만약 fast-forward merge가 불가능한 상황이라면 대부분 3 way merge로 진행된다. 어플리케이션의 구조가 클 경우 대부분의 merge가 3 way merge로 진행된다. 3 way merge는 현재 브랜치 해드의 커밋 조상과 병합할 브랜치의 커밋 조상이 다를 경우 각 head와 공통 커밋 조상을 이용하여 merge를 진행한다. 아래 사진의 1번을 보자

<img width="905" alt="스크린샷 2021-10-17 오후 3 23 20" src="https://user-images.githubusercontent.com/68282095/137615239-8c1bbd9d-9e93-4499-a935-9160072ea606.png">

- Master 브랜치 해드의 커밋 조상은 m4 , dev 브랜치의 커밋 조상은 a1을 가르킨다. 이 경우 fast-forward merge가 불가능 하므로 master 테이블의 head와 dev 테이블의 head와 두 커밋의 공통 조상인 m4(베이스) 3개의 커밋을 이용하여 병합을 진행 한 후 2번 상황의 c1 병합 커밋을 새로 생성한다.

### 그러면 도대체 rebase는 무엇인가

사실 merge만 사용해서 브랜치를 병합해도 문제는 없다. 다만 merge는 3 way merge처럼 병합한 커밋을 새로 생성하므로 커밋 히스토토리가 지저분해 질 수 있다. 반면 rebase는 base를 재설정하므로 커밋 히스토리를 하나로 만들 수 있다.  아래가 실제 프로젝트에서 merge만 사용해서 관리한 커밋 히스토리이다.

<img width="90" alt="스크린샷 2021-10-17 오후 3 59 26" src="https://user-images.githubusercontent.com/68282095/137615510-03f6390a-135c-400d-ae10-11a00fc1977e.png">

- 규모가 큰 프로젝트일 경우 merge만 사용해서 remote repository에 push할 경우 commit history가 지저분해진다. 그래서 커밋 히스토리를 단순하게 할 경우 브랜치 병합 전략을 Rebase and Merge를 사용해서 커밋을 한다.

- rebase 활용

  - commit history를 단순하게 만든다
  - 원하는 브랜치의 커밋만 병합하고자 할 때
    - Master 브랜치에서 client 브랜치가, server 브랜치에서 client 브랜치가 분기되었다고 하자
    - 내가 server 브랜치만을 병합하고자 할 때 rebase를 사용할 수 있다
      - `git rebase --onto master server client`
        - git master 브랜치에서 부터 server와 client 브랜치의 공통 조상 커밋을 client에서 없앤 후 client의 베이스를 master로 재배치

  ### rebase의 예

  - 3 way merge를 이용할 경우 병합 커밋을 생성한다(C1). rebase를 브랜치의 베이스를 변경하여 병합을 진행한다.계속 나오는 베이스란 브랜치를 분기한 commit을 말한다. rebase는 병합될 브랜치의 커밋을 임시 저장소인 patch로 저장한 후 베이스를 병합할 브랜치의 head로 옮긴 후  patch에 임시 저장된 커밋을 옮겨진 베이스에서 다시 병합시키는 방법을 말한다. 따라서 병합된 브랜치의 커밋은 병합 할 브랜치의 head보다 앞서게 되며 이 상태에서 병합 할 브랜치는 병합 될 브랜치와 fast-forword merge가 가능한 상황이 된다.

  <img width="764" alt="스크린샷 2021-10-17 오후 4 22 08" src="https://user-images.githubusercontent.com/68282095/137616360-e20db660-d29c-4a54-83cc-c2b2ae713fb0.png">

- 따라서 위 상황을 rebase하면 다음과 같은 과정이 일어난다

  1. A1, A2 커밋을 patch에 복사
  2. dev 브랜치의 베이스를 master 브랜치의 head인 M5로 변경
  3. M5에서 다시 A1, A2 커밋을 병합하는 작업을 진행
  4. 최종적으로 master를 fast-forword merge가 가능한 상황이 된다.

  <img width="760" alt="스크린샷 2021-10-17 오후 4 22 17" src="https://user-images.githubusercontent.com/68282095/137616752-a6cb9fb3-5d87-428f-b6b6-ee3bd013768b.png">

- `git -c credential.helper= -c core.quotepath=false -c log.showSignature=false -c core.commentChar= rebase master`로 rebaseTest와 master 테이블을 rebase한 후 master로 체크아웃 한 후 fast-forword merge를 한 상황

<img width="658" alt="스크린샷 2021-10-17 오후 4 41 34" src="https://user-images.githubusercontent.com/68282095/137617029-a47a6815-0a08-40bd-85f7-1b52da62e94b.png">

### 커밋 히스토리를 통한 비교

- Merge

<img width="661" alt="스크린샷 2021-10-17 오후 4 46 06" src="https://user-images.githubusercontent.com/68282095/137617224-ffb1d361-2e92-4a7e-a65c-b20599e28670.png">

- rebase

  - rebase후 Fast forword merge를 하기 전

    <img width="657" alt="스크린샷 2021-10-17 오후 4 52 31" src="https://user-images.githubusercontent.com/68282095/137617568-47ba9db6-97a2-4cb2-9721-79b07878299f.png">

  - Fast forword merge를 한 후

    <img width="656" alt="스크린샷 2021-10-17 오후 4 53 38" src="https://user-images.githubusercontent.com/68282095/137617579-ef3b43ab-6f62-463f-928a-2def8f1f93b7.png">

### 📌 절대 remote 브랜치에 push된 브랜치에 rebase를 하지 않는다.

rebase할 때 절대 하지 말아야 할 위험 요소가 있다.

> **"Do not rebase commits that exist outside your repository and that people may have based work on."**
> **"다른 동료가 작업 중인 외부에 공개 된 저장소 브랜치를 대상으로 리베이스하면 안됩니다."**

rebase해서 생성된 커밋은 내용은 같지만 다른 커밋을 새로 만든다. 즉 a라는 사람이 feature 브랜치를 merge한 후 reset한 후 rebase한다면 중복된 커밋이 존재한다. 자세한 사항은 아래 링크를 참고

https://git-scm.com/book/ko/v2/Git-브랜치-Rebase-하기
