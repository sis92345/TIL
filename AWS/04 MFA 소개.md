# 1. MFA( Multi Factor Autentication ) 소개

다단계 인증으로 정규 자격증명 방법 외에 서비스 제공자가 지원하는 추가 보안 인증 방법을 수행하는 것이다.

하기는 크게 사용되는 MFA의 종류이다.

- OTP
- SMS / EMAIL / ARS

# 2. MFA In Amazon

AWS 사용시 해킹 방지를 위해 MFA를 사용하는 것을 추천한다.

1. 가상 MFA 디바이스
    - Google Authenticator ( 비추천 )
    - Authy
2. U2F 보안 키
3. 다른 하드웨어 MFA 디바이스
4. SMS 문자 메시지 기반

## 2-1. Authy APP MFA 설정 방법

1. 내 계정 → 보안자격증명 → 멀티 팩터 인증 → 가이드에 따라 활성화
2. Authy → QR 코드로 MFA QR 코드 인식
3. 첫번째 6자리 코드와 그 다음 6자리 코드를 MFA1,2에 입력
4. 완료