# Docker Container vs Virtual Operating System

# Docker vs 가상머신

두 시스템은 모두 환경의 분리라는 공통적인 관심사를 처리할 수 있다. 이번에는 두 솔루션의 차이를 알아보고 왜 가상머신이 아닌 Docker를 사용해야 하는지 알아보자

# 가상머신

가상 머신은 Host OS위에 가상머신을 설치한다. Docker Container와 마찬가지로 독립적인 가상머신 위에 Application과 종속성, 환경을 설치할 수 있으며 캡슐화된다. 공유가 가능하며 독립적이다.

하지만 가상머신은 다음과 같은 문제점을 지닌다.

## 가상머신은 오버헤드가 존재한다.

가상머신은 컴퓨터 내부에 컴퓨터로 Host의 메모리, CPU, HDD를 낭비한다. 뿐만 아니라 가상머신 OS 자체적인 오버헤드도 존재한다.

## 여전히 종속성, 도구, 라이브러리가 가상머신별로 독립적으로 계속 설치해야 한다.

독립적인 설정 파일이 없다. 

![Untitled](Docker%20Container%20vs%20Virtual%20Operating%20System%200890c8136bb240b09629775b5926c8cd/Untitled.png)

---

# Docker Container

컨테이너를 사용하면 HOST OS위에 가상머신을 설치하는 것이 아닌 , HOST OS의 컨테이너 에뮬레이트를 내장하는 컨테이너를 활용해서 그 위에 Docker Engine을 사용해서 Container를 처리한다.

![Untitled](Docker%20Container%20vs%20Virtual%20Operating%20System%200890c8136bb240b09629775b5926c8cd/Untitled%201.png)

## 즉 Docker에는 별도의 OS가 설치되어 있지 않아 가볍다.

HOST OS에 미치는 영향이 적다.

## 또한 하나의 구성 파일로 컨테이너를 구성할 수 있다. 따라서 컨테이너 이미지를 빌드해서 모든 Docker 환경에서 사용할 수 있다.

컨테이너의 이미지 구축으로 모든 Docker에서 공유해서 사용 가능

# Docker는 가상머신 다음과 같은 장점을 지닌다.

Docker는 가상머신 보다 가볍다. 또한 구성 파일을 가지므로 Docker Container를 이미지로 빌드해서 모든 Docker에서 공유해서 사용할 수 있다.

![Untitled](Docker%20Container%20vs%20Virtual%20Operating%20System%200890c8136bb240b09629775b5926c8cd/Untitled%202.png)