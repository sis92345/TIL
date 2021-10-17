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

  - Fast-forward merge가 진행된 예

  <img width="659" alt="스크린샷 2021-10-17 오후 3 43 15" src="https://user-images.githubusercontent.com/68282095/137614988-73ea2507-ec51-446e-8407-80618149a55c.png">