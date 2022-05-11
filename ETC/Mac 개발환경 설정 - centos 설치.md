# Mac - Docker를 이용한 centos 설치

## 1. docker에서 centos 이미지 검색

Docker Repository에 존재하는 이미지를 검색한다.

```shell
docker search centos 
```

- 결과 

  <img width="1242" alt="스크린샷 2022-05-11 오후 10 58 22" src="https://user-images.githubusercontent.com/68282095/167867871-b1330908-74bd-4011-be6b-a456e51c1660.png">

## 2. Docker image Repository to local

검색한 이미지를 pull 받는다.

```shell
docker pull centos
```

다음 명령어로 pull 받은 이미지 리스트를 조회할 수 있다.

```shell
docker image list
```

## 3. centos 설치

run 명령어를 이용해서 centos 컨테이너를 실행한다. run 명령어의 형식은 다음과 같다.

```
docker run (<옵션>) <이미지 식별자> (<명령어>) (<인자>)
```

run 명령어에서 자주 사용하는 옵션은 다음과 같다.

| Options | 설명                                                         |
| ------- | ------------------------------------------------------------ |
| -d      | 컨테이너를 백그라운드에서 실행                               |
| -it     | 두 옵션은 컨테이너를 종료하지 않은체로, 터미널의 입력을 계속해서 컨테이너로 전달, 즉 컨테이너의 cli 나 shell로 명령어를 사용할 때 사용 |
| --name  | 컨테이너에 식별자 이름을 지정한다.                           |
| -e      | 환경변수를 설정                                              |
| -p      | 컨테이너 간의 포트(port) 배포(publish)/바인드(bind)를 위해서 사용 |
| -v      | 호스트(host) 컴퓨터의 파일 시스템의 특정 경로를 컨테이너의 파일 시스템의 특정 경로로 마운트(mount), 이 옵션으로 호스트의 폴더를 사용 가능 |
|         |                                                              |

실제 run 명령어는 아래와 같이 사용할 수 있다.

```shell
docker run -d -it -v /Users/Apps --name centos centos
```

위 명령어는 centos 를 백그라운드에서 실행하며, 컨테이너의 shell에 입출력을 사용한다. centos 컨테이너를 종료하면 컨테이너의 데이터가 모두 사라지므로 -v 로 호스트 컴퓨터의 지정한 경로에 데이터를 사용한다는 의미이다.  또한 이 컨테이너는 centos라는 이름으로 접근이 가능하다.

이제 docker에 실행중인 컨테이너를 확인해보자

```shell
docker ps
```

```
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
bf0471e02e71   centos    "/bin/bash"   5 minutes ago   Up 5 minutes             centos
```

 해당 컨테이너에 연결하기 위해서 attach 명령어를 사용할 수 있다.

```
docker attach {containerID}
```

```shell
docker attach centos
```

컨테이너 내부에서는 exit 명령어나 ctrl + c로 종료할 수 있고, 백그라운드에서 실행한 체로 빠져 나오고 싶으면 ctrl + q를 누르면 된다.

<img width="1440" alt="스크린샷 2022-05-11 오후 11 20 31" src="https://user-images.githubusercontent.com/68282095/167872430-ff54e178-c7a4-4f09-901b-864e88bffceb.png">