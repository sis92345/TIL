# AWS 임시 자격 증명을 활용한 보안 모범 사례

### 모범 사례 : AWS 임시 자격증명

**Access Key는 되도록 사용하지 않는게 좋다.  Access Key는 영구 자격 증명이다. 이는 노출시 큰 이슈를 발생시킨다.** 그래서 AWS는 임시 자격 증명을 발급해서 사용하기를 권장한다.  각 워크로드 및 일반 사용자의 모범 사례는 다음과 같다

### 일반 작업자의 aws resource 접근 모범 사례

- `AWS IAM Identity Center` 사용
- `AWS STS`를 사용하여 임시 자격 증명 부여

### 워크로드에서 임시 자격 증명을 사용하는 모범 사례

- 내부 워크 로드(AWS Resource to Resource)
  - IAM Role을 사용하여 서비스에 직접 역할 부여
- 외부 워크 로드 (On-premise 또는 AWS 외부 리소스)
  - IAM Roles Anywhere
  - 최소한 Access key rotate
  - [외부 워크로드에서 임시 자격 증명을 사용하는 모범 사례](https://docs.aws.amazon.com/ko_kr/IAM/latest/UserGuide/best-practices.html#bp-workloads-use-roles)

## 임시 자격 증명을 위한 서비스

### **AWS Identity Center**

> 여러 AWS 계정과 Application에 대한 권한을 한곳에서 집중에서 관리하는 서비스

여러 AWS 계정과 Application에 대한 권한을 한곳에서 집중에서 관리하는 서비스이다.

AWS Identity Center는 다음 서비스를 제공한다

- Organization에 대한 중앙 관리

- 단기 자격 증명

- SSO

- 외부 IDP 연동

- IAM과 비교


  | **구분**        | **IAM User**                | **IAM Identity Center**         |
  | --------------- | --------------------------- | ------------------------------- |
  | **사용자 위치** | **각 AWS 계정 내부**        | **Identity Center 중앙 저장소** |
  | **인증 과정**   | 계정마다 로그인 (ID/PW/MFA) | 중앙 포털에서 1회 로그인 (SSO)  |
  | **권한 할당**   | 사용자에게 직접 정책 연결   | 사용자에게 **권한 세트**를 할당 |
  | **최종 결과**   | IAM User 권한으로 작업      | **IAM Role** 권한을 빌려 작업   |

## AWS STS (Security Token Service)

### 1. 정의

AWS 리소스에 접근할 수 있는 **임시 보안 자격 증명**을 생성하여 제공하는 웹 서비스다

### 핵심 개념

- **임시성:** 발급된 자격 증명은 정해진 시간(15분~12시간) 동안만 유효하며 이후 자동 만료된다.
- **보안성:** 장기 Access Key를 환경에 노출하지 않고, 필요할 때만 권한을 빌려 쓰기 때문에 유출 피해를 최소화한다.
- **구성 요소:** STS 자격 증명은 반드시 다음 **3종 세트**가 한 쌍으로 움직인다.
  1. **Access Key ID**: `ASIA...`로 시작하는 임시 ID
  2. **Secret Access Key**: 임시 비밀 키
  3. **Session Token**: 임시 권한임을 증명하는 핵심 토큰

---

## 2. STS 사용법 (AssumeRole 기준)

가장 표준적인 모범 사례인 `"IAM 사용자가 역할을 assume하는 방식"`에 대한 절차

### Step 1. IAM 역할(Role) 생성 및 정책 설정

실제 리소스에 접근할 권한(예: S3 조회)을 가진 **역할**을 생성한다.

- **권한 정책(Permission Policy):** `AmazonS3ReadOnlyAccess` 등
- **신뢰 정책(Trust Policy):** 누가 이 역할을 빌릴 수 있는지 정의

### Step 2. IAM 사용자에게 수임 권한 부여

사용자(User)에게는 리소스 접근 권한을 모두 빼고, 오직 **역할을 빌릴 권한(`sts:AssumeRole`)**만 부여한다.


### Step 3. CLI를 통한 임시 자격 증명 요청

터미널에서 아래 명령어를 실행하여 임시 키를 발급받는다.

```bash
aws sts assume-role \
  --role-arn "생성한 assume target role arn" \
  --role-session-name "session name"
```

### Step 4. 환경 변수 설정

응답받은 JSON 결과값을 환경 변수에 적용한다. (적용 후부터 해당 역할의 권한으로 동작한다.)

---

## 💡 요약 및 팁

- **전략:** IAM 사용자에게는 아무 권한도 주지 말고 `sts:AssumeRole`만 허용
- **강화:** 신뢰 정책에 `Condition`을 추가하여 **MFA 인증**이 완료된 경우에만 임시 키를 주도록 설정하는 것이 보안상 가장 강력
- **권장:** 사람이 직접 작업할 때는 이 과정을 자동화해주는 **IAM Identity Center(SSO)** 사용을 우선적으로 고려