# 10. VPC

날짜: 2022년 11월 20일
대분류: AWS
유형: AWS, Devops, 🍖AWS-VPC
작성자: 안병현

# 1. VPC 생성과 Subnet 생성

## 1-1. VPC 접속

AWS - 검색 - VPC

VPC를 처음 접속하면 기본으로 생성된 VPC를 볼 수 있다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled.png)

## 1-2. VPC 생성

1. 이름 태그 : VPC 이름
2. IPv4 CIDR : CIDR 입력, 16이므로 B Class
3. 1Pv6 : IPv6 사용 여부
4. 테넌시 : 기본값 설정

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%201.png)

생성 후 `메뉴 > 서브넷`을 확인해보면 방금 만든 VPC에 속한 서브넷은 없다는 것을 확인할 수 있다. 서브넷 생성 시 자동으로 생성해주는 항목과 생성이 안되는 항목이 있다. 생성이 안되는 항목은 서브넷, 라우팅 테이블, IGW 등이고 생성이 되는 항목은 NACL, 보안 그룹등의 보안 처리가 대표적이다.

## 1-3. Subnet 생성

`메뉴 > 서브넷` 에서 서브넷을 생성한다. VPC ID는 방금 생성한 VPC ID로 지정한다.

1. 서브넷 이름 : 서브넷 이름
2. 가용 영역 : Avaliable Zone을 말한다.
3. CIDR : 서브넷도 별도의 CIDR을 지정해야 한다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%202.png)

# 2. Internet Gateway 설정

## 2-1. IGW 생성

`메뉴 > 인터넷 게이트웨어 > 생성` 에서 이름만 지정하면 된다.

그 후 생성된 IGW 클릭 → VPC를 지정해서 붙여주면 완료

단 이때 상태는 IGW와 서브넷이 분리된 상태이다. RouteTable을 연결해야 서브넷에서 연결이 가능하다.

## 2-1. IGW 상태

1. `attached` : VPC에 연결이 된 상태
2. `dettached` : VPC에 연결이 안된 상태

# 3. Route Table과 Subnet 연결

생성된 VPC와 연결된 Route Table을 가보면 Subnet이 명시적으로 연결이 되어 있지 않은 것을 볼 수 있다. 즉 두 서브넷이 이 라우트 테이블에 연결이 된 상태이다.

- VPC
    - 우리가 원하는거
        - Route Table 1
            - Public Subnet
        - Route Table 2
            - Private Subnet
    - 현재 상황
        - Route Table
            - Subnet1
            - Subnet2

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%203.png)

## 3-1. 라우팅테이블 생성

`메뉴 > 라우팅테이블 > 생성` 에서 새로 만든 VPC 연결

## 3-2. Subnet과 Route Table 연결

라우트 테이블 항목 오른쪽 클릭 > 서브넷 편집 > 각각 서브넷 연결하면 아래처럼 명시적 라우팅 테이블을 처리할 수 있다. 

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%204.png)

# 4. Public Subnet 설정

Public, Private으로 설정할 각각의 Routing Table을 연결했으면 이제 Public Route Table의 경우 외부 접속 설정을 허용해야 한다. 

Public 접근을 허용할 Route Table을 오른쪽 클릭한 후 라우팅을 편집으로 들어가서 인터넷 게이트웨이를 추가해야 한다.

라우팅 항목에 0.0.0.0/0(모든 IP)을 방금 생성한 IGW로 지정하자, 라우팅 설정은 순서대로 적용되기 때문에 10.0.0.0으로 접근하면 local로 설정 가능다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%205.png)

여기까지 완료했으면 Public, Private Subnet 설정이 완료된다. 여기에 내가 원하는 Subnet을 각 igw로 설정된 route table에 추가하면 된다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%206.png)

# 5. NACL 설정

<aside>
🌐 NACL - stateless, Security Group - stateful
[https://honglab.tistory.com/153](https://honglab.tistory.com/153) 참고

</aside>

NACL도 Subnet 설정과 완전 동일하다.

1. NCAL 생성 : `메뉴 > 보안 > 네트워크 ACL > NACL 생성`
2. public nacl을 public subnet과 연결

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%207.png)

## 5-1. inbound,outbound 설정

- inbound 설정 : ssh, http, https 추가
    - **규칙번호**
        - 낮은 숫자대로 적용됨, 즉 100 평가 → 200 평가 → 300 평가
        - 예를들어 101 규칙번호로 ssh를 deny로 하면 ssh 접근 가능, 반대로 99번은 불가
    
    ![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%208.png)
    
- outbound 설정 : **nacl은 stateless**하기 때문에 outbound설정을 정확하게 해야한다.
    
    모든 임시포트는 1024~65535포트이기 때문에 임시 포트는 모두 허용한다.
    
    ![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%209.png)
    

## 5-3. 테스트

이제 새로만든 VPC로 설정한 EC2 인스턴스를 생성해보자 인스턴스를 생성한 후 네트워크 설정을 편집해서 새로 생성한 VPC와 public subnet으로 설정하면 된다.

1. public nacl inbound에서 22번 포트를 허용하면 정상 접근이 된다.
    
    ```bash
     ssh -i ./test.pem ubuntu@test
    The authenticity of host '54.180.1.154 (54.180.1.154)' can't be established.
    ED25519 key fingerprint is SHA256:zITmEypNlNDezXedBhb55gx5qY4HX99KGZqSWJ9WmCY.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added '54.180.1.154' (ED25519) to the list of known hosts.
    Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1019-aws x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
      System information as of Sun Nov 20 14:54:23 UTC 2022
    
      System load:  0.525390625       Processes:             113
      Usage of /:   19.5% of 7.57GB   Users logged in:       0
      Memory usage: 21%               IPv4 address for eth0: 10.0.0.246
      Swap usage:   0%
    
    0 updates can be applied immediately.
    
    The list of available updates is more than a week old.
    To check for new updates run: sudo apt update
    
    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.
    
    To run a command as administrator (user "root"), use "sudo <command>".
    See "man sudo_root" for details.
    
    ubuntu@ip-10-0-0-246:~$ exit
    logout
    Connection to 54.180.1.154 closed.
    ```
    
2. 이제 public nacl의 inbound 규칙에서 22번 포트를 거절하면 응답이 없는 것을 확인할 수 있다.
    
    ```bash
     ssh -i ./fastcampus.pem ubuntu@54.180.1.154
    //... 응답 없음
    ```
    

# 6. Bastion Host

<aside>
🗣️ Private Subnet에 존재하는 EC2 인스턴스를 접근하기 위한 방법

</aside>

- 생성 방법 요약
    1. Private EC2 생성
    2. Public EC2 생성 후 Bastion host 생성
    3. Public EC2 Bastion host로 Private EC2 생성

## 1. Private EC2 생성

기존의 EC2 생성과 동일하다. 단 VPC는 외부 설정을 막은 Private Subnet을 사용해야 한다.

Private EC2의 보안 그룹의 허용 대상은 모두 Public EC2의 보안그룹으로 설정해서 외부 접근을 막는다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%2010.png)

- Bastion Host로 Private EC2를 접근한 사진이다. 아래 방법은 Public EC2 (Bastion Host)에서 Private EC2로 직접 접속한 결과이다
    1. `scp -i [public ec2 key] [send file(private ec2 key)] {user}@{public subnet public ip}` 로 Private EC2 Key를 Bastion Host로 전송
    2. `ssh -i [public ec2 key] {user}@{public subnet public ip}` 로 public EC2 접속
    3. `ssh -i [private ec2 key] {user}@{public subnet private ip}` 로 private EC2 접속

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%2011.png)

- public subnet nacl에서 22, 80, 443 포트만 허용했더니 ssh timeout이 발생, 원인은 모르겠음 확인 필요

# 2. 터널링을 사용한 EC2 접근

# 7. NAT Gateway 설정

Bastion Host는 Public EC2에서 Private EC2로 접근하는 방법이다. 이제 반대로 Private EC2에서 외부 인터넷으로 접근하는 방법이 필요한데 이 방법이 NAT Gateway이다.

private ec2에서 mysql을 설치하면 설치가 안되는 것을 확인할 수 있다.

![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%2012.png)

## 7-1. NAT Gateway 설정

1. VPC > NAT Gateway > NAT Gateway 추가
    - subnet : nat gateway는 public subnet에 위치해야 한다.
    
    ![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%2013.png)
    
2. private route table outbound 변경
    
    0.0.0.0 요청은 모두 nat으로 처리한다. 
    
    ![Untitled](10%20VPC%20c5bec48806ca4298b38690ca42febc9e/Untitled%2014.png)