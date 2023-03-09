# Why Containers?

# 왜 Conatiner가 필요한가

소프트웨어에서는 독립적인 Application Package가 필요하다. 

예를들어 Node 16이 필요한 Application을 생성하였다. 이제 이 Application을 개발, 운영 환경에서 돌리기 위하여 Node 16을 각 서버에 설치해야 한다. 만약 이전버전의 Node가 이미 설치되어있다면 복잡성이 올라갈 것 이다.

## Container는 Application의 똑같은 개발 환경을 보장한다

> 특정 환경을 Docker Container에 고정함으로써 개발환경, 의존성을 고정할 수 있다.
> 

## Container를 사용해서 공통적인 개발환경을 고정할 수 있다.

> Docker Conatiner를 공유함으로써 공통적인 개발 환경을 공유할 수 있다.
> 

## Container를 사용하면 Application간의 환경 충돌을 방지할 수 있다.

> Docker Conainter의 종속성은 호스트가 아닌 Conatiner에 있으므로 전체적인 환경 충돌을 방지할 수 있다.
>