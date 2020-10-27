톰캣 설치
==========
> 4-Tire Web Application Architecture
>
> WAS

> Apache 설치
>
> Tomcat 설치

### 1. 4-Tire Web Application Architecture
---------------
- **4-Tire Web Application Architecture**

    - 일반적인 web은 요청을하는 클라이언트와 요청을받아 이를 수행하여 클라이언트에 결과를 전달하는 서버의 상호작용이다.

    - 이 서버를 각각의 기능과 역할에 맞게 여러대로 분산하여 사용하며 이중 4-Tire Web Application Architecture는 4계층으로 구성된 4-Tire Web Application Architecture다.

    - 일반적인 4-Tire Web Application Architecture의 구조는 다음과 같다.

        ![](D:\git_env\TIL\img\tomcat1.jpg)
        
        - 클라이언트가 웹 서버에 요청을하면 웹 서버는 정적 페이지를 보내고 웹 컨테이너에서 동적 페이지를 처리한다. 이 웹 서버와 웹 컨테이너를 합쳐 WAS라고하며 WAS는 실제 비즈니스 업무 로직을 처리하고 결과로 응답한다. 여기에 영구적으로 데이터를 보관, 조회, 관리하기 위해 DB와 연결한다.

- **WAS(Web Application Server)**

    - WAS는 DB 조회나 다양한 로직 처리를 요구하는 동적인 컨텐츠를 제공하기위한 Application Server으로 web server와 web Container가 합쳐진 것이다. 각 서버의 역할은 다음과 같다.
        - Web Server: 웹 브라우저 클라이언트로부터 HTTP 요청을 받아 정적인 컨텐츠를 제공한다.
            - 종류: *Apache Server*, Nginx, IIS 등
        - Web Container: Servlet, JSP를 실행할 수 있는 소프트웨어다.
    - WAS이외에도 규모가 크고 엔터프라이즈 환경에 필요한 트랜잭션, 보안, 트래픽 관리, DB 커넥션 풀, 사용자 관리 등등의 강력한 기능을 제공하는 S/W이다.
        - WAS의 종류: *Tomcat*, JBoss Jeus 등
    - WAS의 역할
        - 클라이언트에 이미지 파일(정적 컨텐츠)을 보낸다고 가정하자, 이미지 파일과 같은 정적 페이지는 웹 문서가 클라이언트로 보내질 때 함께 가는 것이 아닌다.
        - 클라이언트는  HTML 문서를 먼저 받고 그에 맞게 필요한 이미지 파일을 다시 서버로 요청하면 그때서야 이미지 파일을 받아온다. 
        - Web Server는 이런 정적인 파일을 Application Server에 가지 않고 앞단에서 빠르게 보내고 Application Server는 동적 콘텐츠를 담당하여 서버의 부하를 줄일 수 있다.
    - WAS의 장점
        - https://gmlwjd9405.github.io/2018/10/27/webserver-vs-was.html
    - 정리
        - 클라이언트는 Web Container에 요청하는 것이 아닌 Web Server에 요청을 하며 Web Server는 정적 페이지를 처리하고 Web Container는 동적 페이지를 생성하고, DB를 조회하여 처리한 후 결과를 응답한다. Web Server는 이 결과를 클라이언트에 전달한다.
            - 실제 Tomcat의 포트는 8080이지만 Web Server인 Apache와 연동하면 Apache의 포트로 WAS에서 처리할 수 있는 JSP, Servlet파일을 응답받을 수 있다. 이것이 위에 설명한 방식인 것

    

    

### 2. Apache 설치

------

- 설치 페이지: https://www.apachelounge.com/download/

- 설치 파일

  - 윈도우 10 Education Edition, 64bit 기준 httpd-2.4.46-win64-VS16.zip(2020-10-26 기준 최신 버전)

- 과정

  1. 압축을 푼다.
  2. Apache2.4 폴더를 C:/Program Files에 붙여넣기
  3. httpd.conf 
    1. Apache 환경 설정 파일
    2. 초기 설정
          1. 37라인: Define SRVROOT
        1. Apache가 설치된 경로
        2. 예: `Define SRVROOT "C:\Program Files\Apache24"`
          2. 60라인: Listen: 80
        1. Apache의 포트번호
        2. 다른 프로그램과 충돌가능성 있음
          3. 239라인: ServerName www.example.com:80
        1. 확인
          4. 257라인: DocumentRoot
        1. Apache 서버가 찾아갈 index.html의 경로
        2. 내가 원하는 곳으로 설정
        3. 설정하면 해당 경로의 index.html이 www.example.com 또는 localhost의 파일이 됨
  4. 시스템 환경 변수 편집
    1. 시스템 변수 > path -> C:\Program Files\Apache24\bin 추가
  8. cmd set path
    9. 
  
  

### 3. 예제로 살펴보기

---------------



