# 03. AWS CLI 도구 설치 ( MAC )

날짜: 2022년 10월 23일
유형: Devops
작성자: 익명
태그: AWS

# 1.  AWS CLI V2

AWS에서 AWS Service를 제어하는 CLI를 제공한다. 이번에는 AMI에서 AWS CLI를 설치하는 방법을 알아본다.

참고 : 공식문서

[최신 버전의 AWS CLI 설치 또는 업데이트](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html)

# 2. AWS Access Key 설정

1. 내 계정 명 > 보안 증명 > 엑세스 키 생성 > 안전한 곳에서 보관

# 3. AWS CLI 자격증명 설정

AWS CLI를 사용하기 위해서 자격 증명을 설정해야 한다.

Mac에서 homebrew를 사용해서 AWS CLI를 설치하면 된다.

`brew install awscli`

## 3-1. AWS CLI 자격증명 설정 우선순위

**CLI 명령어 옵션**

환경 변수

**CLI 자격증명 파일**

**CLI 설정 파일**

컨테이너 자격증명

인스턴스 프로파일 자격증명

## 3-2. CLI 설정 파일을 이용한 설정

1. `{USER_HOME}/.aws/config` 에 데이터를 붙여넣어서 생성
    
    ```jsx
    [default]
    aws_access_key_id={}
    aws_secret_access_key
    ```
    
2. 설정이 잘 되었는지 테스트 한다 
    - `aws sts get-caller-identiry` : 현재 사용중인 유저 계정을 확인한다.

## 3-3. 환경변수를 이용한 설정 방법

아래 환경 변수를 사용

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## 3-4. CLI 명령어 옵션

`—profile`

## 3-5. EC2 인스턴스 프로파일

인스턴스 세부정보 구성 > IAM 역할을 부여하기 위한 목적인 **인스턴스 프로파일**에서 EC2 내에서 AWS 서비스에 대한 권한을 수행할 수 있게 됨

## 3-6. AWS CLI 기본 리전 설정

기본 리전 설정을 하지 않으면 `—region` 옵션을 추가해야 한다.

- `aws ec2 describe-key-pairs --regions {regions}`
1. AWS 설정 파일 ( `{USER_HOME}/.aws/config` ) default에 region을 추가한다.
    
    ```jsx
    [default]
    region=ap-northeast-2
    ```
    
2. `aws ec2 describe-key-pairs` 를 통해 테스트 한다.

## 3-7. AWS CLI 사용자 프로파일 설정

1. AWS 설정 파일 ( `{USER_HOME}/.aws/config` )에 `[profile {name}]` 으로 설정하여 여러 사용자 프로파일을 변경하여 자격증명을 관리할 수 있다.
    
    ```jsx
    [default]
    ... 설정
    
    [profile user1]
    ... user1 프로파일1
    
    [profile user2]
    ... user2 프로파일2
    ```
    
2. 사용 방법
    - 환경 변수 : `AWS_PROFILE`
    - 옵션         : `—profile`
    - 여러 AWS 계정 운영

## 3-7.  AWS CLI 기타

1. 기본 사용 방법
    - `aws <command> <subcommand> [options and parameter]`
2. `output` : 결과 출력 형식 설정
    - json ( default ) , text, table, yaml , yaml-stream
3. 자주 사용하는 명령어
    1. `aws —version` : AWS 버전 확인
    2. `aws help` : AWS CLI 메뉴얼
        - `aws <command> help` : command help
        - `aws <command> <subcommand> help` : subcmmand help
    3. `aws sts get-caller-identity` : 현재 자격증명 정보 확인