# Docker 

# 1. 도커란 무엇인가

도커는 컨테이너 기술, 컨테이너를 생성하고 관리하는 기술이다. 

# 2. Container

개발에서 컨테이너는 표준화된 소프트웨어 유닛, 기본적으로 코드 페키지이며 해당 코드를 실행하기 위한 종속성과 도구가 포함

예를 들어 NodeJS App일 경우 컨테이너에는 NodeJs App과 NodeJS가 있다. 이렇게 관리할 경우 NodeJS에서 사용하는 Node의 Version을 하나로 관리할 수 있다.

쉽게 말하면 피크닉갈 때 가져가는 바구니이다. 이 바구니에 접시와 음식이 모두 있고 피크닉때 이걸 가져가서 단지 사용할 뿐이다.

컨테이너는 배에 실린 컨테이너와 동일한 개념이라고 할 수 있다. 컨테이너에 물건을 실으면 표준화된 컨테이너에 넣을 수 있으며 자체적으로 보관, 격리된다. 다른 컨테이너의 물건과 섞이지 않는다. **즉 컨테이너는 스텐드 얼론으로 작동한다. 어디에서 동작한다는 점은 중요하지 않다. 도커는 그리고 이 컨테이너를 구성하기 위한 도구일 뿐이다.**

# 3. Contanier가 필요한 이유

우리는 왜 소프트웨어 개발에 독립적인 표준화된 어플리케이션 패키지를 원하는 것일까?

1. 어떤 환경에서든 정확히 같은 개발 환경을 구축하기를 원한다.
   - 내가 만든 Java Application이 11 버전 이상이 필요한데 새로 배포하려는 서버에 Java Version이 8이 설치되어있다고 생각해보라. 컨테이너를 사용하면 이런 문제를 신경쓰지 않아도 된다.
   - 이는 작업에 큰 도움이 된다.
2. 공통 개발 환경을 구축하기에 쉽다.
3. 쉬운 개발 환경 변경 : 개발 환경을 다시 구축할 필요가 없다.
   - 레거시 앱은 Node 14를 필요로 한다. 새로운 앱은 Node 16을 필요로 한다. 
   - 컨테이너를 교체하는 것 만으로도 이 문제는 해결된다.

# 4. Virtual Machines VS Docker Container

사실 가상머신을 사용하면 위 문제를 해결 할 수 있다.

- 구조

  1. 가상 머신
     - Host OS
       - 가상머신은 Host OS위에 실제 Virtual OS를 설치한다
       - Virtual OS
         - Linux Virtual OS 1
           - App 
           - Libraries , Dependencies, Tools
           - 여기에 설치된 가상 머신은 캡슐화 된다. 따라서 Docker와 동일한 결과를 가진다.
         - Linux Virtual OS 2
           - App 
           - Libraries , Dependencies, Tools
         - Linux Virtual OS 3
           - App 
           - Libraries , Dependencies, Tools

  2. Docker
     - HOST OS
       - OS Built-in / Emulated Container Support
         - Docker Engine
           - Container 1
             - App 
             - Libraries , Dependencies, Tools
           - Container 2
             - App 
             - Libraries , Dependencies, Tools

- 가상머신의 장단점
  - 장점
    - 분리된 환경
    - 환경별 구성 가능
    - 재생산, 공유를 안정적으로 가능
  - 단점
    - 여러 가상 머신에서 발생하는 오버헤드 : 즉 가상 머신 여러대는 하나의 이미지를 복제
      - 모든 가상 머신은 실제 HOST OS위에 설치되는 스텐드얼론 컴퓨터이다. 따라서 가상 머신은 컴퓨터의 메모리, CPU, 메모리를 낭비한다. 
    - 가상머신을 캡슐화하지만 가상 머신 자체도 캡슐화 : 모든 가상 머신을 별도로 관리해야한다.
    - 성능 저하
    - 즉 문제는 해결하지만 직접적인 해결책 X -> 그래서 Docker와 Container를 사용하고 그 개념을 정확히 이해해야 한다.
- Docker 의 장점
  - 운영체제와 시스템에 미치는 영향이 작다
  - 이미지와 구성파일로 공유, 재구축, 배포가 쉽다
  - 쓸데 없는 부가적인게 없다
- Docker는 가상머신을 설치하지 않기 때문에 Container 내부에 작은 OS Layer가 존재할 지 언정 가상 머신을 설치하는 것 보자 훨씬 작은 일부이다.

# 5. Docker SetUp

- 윈도우와 맥 모두 두 방법으로 사용 가능
  - Docker Desktop / Docker Toolbox

- 리눅스
  - Docker Engine을 설치

# 6. Docker Tools

- Docker Engines
- Docker Desktop / Toolbox
- Docker Hub
- Docker Compose
- Kubernetes

# 7. Docker Image Build Sample

DockerFile을 생성

```
// DOCKER HUB에서 NODE 14 버전을 설치
FROM node:14

// WORKDIR은 명령을 실행하기 위한 디렉토리를 지정, Container는 모두 내부에 자체 파일 시스템을 가지고 있다.
WORKDIR /app

// package.json을 COPY
COPY package.json .

// npm install
RUN npm install

COPY . .

// 3000 포트 설정
EXPOSE 3000

// 명령어 실행
CMD [ "node" , "app.mjs" ]

```

build 성공 시 Container ID 확인 가능 `Successfully built 244d6854508e`

docker run `docker run -p 3000:3000 244d6854508e `  

- `-p` localhost를 사용하여 컨테이너의 3000 포트로 연결하도록 설정

`docker ls` 명령어로 현제 실행중인 컨테이너를 조회할 수 있다. 자동으로 설정된 이름을 사용해서 stop하면 된다.

`docker stop <container name>`



