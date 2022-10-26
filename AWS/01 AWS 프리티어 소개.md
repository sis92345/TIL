# 01. AWS 프리티어 소개

날짜: 2022년 10월 23일
유형: Devops, 입문
작성자: 익명
태그: AWS

# 0. AWS 가격 모델

- 종량제 : 사용량에 따른 과금 방식
    
    [AWS 제품 및 서비스 요금 | Amazon Web Services](https://aws.amazon.com/ko/pricing/?aws-products-pricing.sort-by=item.additionalFields.productNameLowercase&aws-products-pricing.sort-order=asc&awsf.Free%20Tier%20Type=*all&awsf.tech-category=*all)
    
- 과금 방식
    - 수요에 따른 공급
        - 약정 X
        - 선불 X
        - 비용 비쌈
    - 예약 구매
        - 약정 : 1, 3년
        - 선불 O
        - 비용 저렴
    - 절감 계획
        - 약정 : 1, 3년
        - 선불 O
        - 비용 저렴
    - 경매
        - 약정 X
        - 선불 X
        - 가장 저렴

# 1. AWS 프리티어 소개

AWS는 첫 사용자를 위해 서비스를 무료 체험하는 프리티어를 제공한다. EC2는 월 750시간 인스턴스를 제공한다.

참고

[무료 클라우드 컴퓨팅 서비스 - AWS 프리 티어](https://aws.amazon.com/ko/free/?trk=b088c8c6-1a6b-43e1-90e7-0a44a208e012&sc_channel=ps&s_kwcid=AL!4422!3!563761819807!e!!g!!aws%20%ED%94%84%EB%A6%AC%20%ED%8B%B0%EC%96%B4&ef_id=CjwKCAjwzNOaBhAcEiwAD7Tb6BGn06HX-FK5JBdwGsrAYjwO9ttfJMED6b15VZusyTBbrMZAVak7sxoCPFAQAvD_BwE:G:s&s_kwcid=AL!4422!3!563761819807!e!!g!!aws%20%ED%94%84%EB%A6%AC%20%ED%8B%B0%EC%96%B4&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)

## 1-1. 프리티어 사용 중 유의사항

1. 모든 AWS 서비스가 프리티어를 제공하지 않음
2. 프리티어 중 요금 발생 가능
    - 하나 이상의 서비스에서 프리티어 사용량 한도 초과
    - 프리티어가 아닌 서비스를 사용
    - 프리티어 기간 만료

따라서 사용량을 항상 체크하는 것이 좋다.

## 1-2. EC2 프리티어

- t2.micro 타입 인스턴스
- 월별 750 시간
- 유의 사항
    - 함께 사용하는 EBS 저장소 ( 아마존 독립 서비스 )의 사용량은 프리티어 수준인가
    - 공인 IP를 위해 사용한 Elastic IP는 모두 EC2 인스턴스에 연결되어 있는가?
        - 미사용중인 Elastic IP는 과금
    - 네트와크 사용량 체크 ( 송신 월 1GB 무료 )
    - T2 계열 인스턴스 생성 시 Unlimited Credits 방식 활성화 하면 과금 가능성

## 1-3. S3

파일 업로드 구현 시 사용

- 매달 무료 사용
- 15GB 데이터 송신

## 1-4. VPC

- 언제나 무료
- 유의사항
    - 네트워크 사용량은 과금될 수 있으니 주의
    - NAT Gateway / PrivateLink / Client VPN / Site-to-SIte VPN / Elastic IP 등 과금 서비스가 존재

## 1-5. IAM

접근제어서비스

- 언제나 무료

# 2. AWS 비용 사고 대처법

1. 프리티어 사용량 알림 설정
    - 내 정보 > 결제 > 결제 기본 설정 > 프리티어 사용량 알림 설정 받기
2. 결제 알림 설정
    - 내 정보 > 결제 > 결제 기본 설정 > 결제 알림 받기
    - Cloud Watch > 경보 > 결제 > 경보 생성
3. 테스트 전 비용 검토
    1. **http://aws.amazon.com/ko/vpc/pricing**
4. 테스트 후 리소스 정리
5. 프리티어 계정 종료 후 대처

# 3. 인스턴스 사용 중지 후 EBS 처리

AWS는 저장소로 인스턴스의 스토어와 EBS ( Elastic Block Store )를 가지고 있다. 인스턴스 스토어는 인스턴스 종료 후 사라지므로 인스턴스의 임시 데이터 보관용도로 적합하다. 만약 영구적인 데이터를 필요로 한다면 EBS를 사용해야한다. EBS는 EC2 > 볼륨에서 제어할 수 있다. 

## 3-1. 인스턴스 중지를 해도 EBS는 가동중이다.

인스턴스 중지를 해도 EBS는 가동중이다. 따라서 사용 중지된 EBS의 스냅샵을 생성하고 EBS는 분리 후 삭제하는 것이 관리에 좋다.

[중지된 인스턴스에 대한 EBS 요금 청구 중지](https://aws.amazon.com/ko/premiumsupport/knowledge-center/ebs-charge-stopped-instance/)