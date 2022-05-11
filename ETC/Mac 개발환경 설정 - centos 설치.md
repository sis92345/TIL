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
docker run -d -it -v /Users/Apps --privileged --name centos centos /sbin/init
```

위 명령어는 centos 를 백그라운드에서 실행하며, 컨테이너의 shell에 입출력을 사용한다. centos 컨테이너를 종료하면 컨테이너의 데이터가 모두 사라지므로 -v 로 호스트 컴퓨터의 지정한 경로에 데이터를 사용한다는 의미이다.  또한 이 컨테이너는 centos라는 이름으로 접근이 가능하다. systemctl 명령어를 사용하기 위해서 /sbin/init를 사용한다

아래 명령어로 컨테이너 shell을 사용한다.

```shell
docker exec -it centos /bin/bash
```

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

## 4. centos 기초 설정

docker attach centos로 실행하면 아무것도 실행할 수 없다 /sbin/init 명령어 이기 때문이다. 따라서 shell을 이용하기 위해서 다음과 같이 명령어를 사용해서 컨테이너에 접근할 수 있다.

```shell
docker exec -it centos /bin/bash
```

centos를 접속하면 기초적인 설정을 하면된다.

제일 먼저 yum update를 한다. 만약 다음과 같은 에러가 발생한다면 `Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist` 다음 블로그를 참조한다.

https://chhanz.github.io/linux/2022/02/04/dnf-error-centos-8/

그 다음은 여러 필요한 것을 설치한다. 일단 sudo만 설치했다.

이제 redis를 설치한 후 이 centos를 commit해서 container를 생성할 수 있도록 하자

#### 4-1. container commit

현재 실행중인 container를 중지한다.

```shell
docker stop centos
```

지금까지 작업 한 centos를 commit한다. commit을 위해 container의 id를 알아야 한다. 중지된 컨테이너를 불러온다.

```shell
docker ps -a
```

```
CONTAINER ID   IMAGE          COMMAND           CREATED          STATUS                        PORTS                                       NAMES
c37583a3ac37   basic_centos   "/sbin/init"      21 minutes ago   Up 21 minutes                 0.0.0.0:6379->6379/tcp, :::6379->6379/tcp   centos_redis
cc9dbd7fab8b   centos         "/bin/bash"       32 minutes ago   Exited (0) 32 minutes ago                                                 loving_meninsky
c95ceff4b0b7   centos         "/sbin/init"      2 hours ago      Exited (137) 30 minutes ago                                               centos
```

아이디를 확인했다. container를 commin한다.

```
c95ceff4b0b7
```

```shell
docker commit c95ceff4b0b7 basic_centos
```

이미지 리스트를 확인해보자

```shell
docker image list
```

```shell

REPOSITORY                                      TAG            IMAGE ID       CREATED             SIZE
basic_centos                                    latest         e4da86fbe9eb   25 minutes ago      648MB
<none>                                          <none>         21d3bc505704   About an hour
```

이제 지금까지 작업한 centos로 다시 container를 생성할 수 있다. 이번엔 redis.conf에서 설정한 port로 접근할 수 있도록 p옵션을 사용한다.

```shell
docker run -d -it --name centos_redis --privileged -p 6379:6379 -v /Users/Apps  basic_centos /sbin/init
```

host에 redis-cli를 설치해서 host에서 접근이 가능한지 확인하자 mac에서 redis-cli는 brew를 사용해서 받을 수 있다.

redis가 설치된 container를 중지하면 오류가 발생하는 것을 확인할 수 있다.

<img width="1440" alt="스크린샷 2022-05-12 오전 1 49 49" src="https://user-images.githubusercontent.com/68282095/167904357-2eefb37e-1725-480b-a635-024bc9bd11ab.png">

##### 4-2. Redis 설치

redis를 설치한다.

```shell
yum install redis
```

아까 `privileged` 옵션과 `sbin/init` 를 사용해서 컨테이너를 생성했다면 `systemctl` 명령어를 사용할 수 있다. redis를 시작하자

```shell
systemctl start redis
systemctl enable redis
```

redis 세부 설정을 진행한다.

```shell
vi /etc/redis.conf
```

일단 구동이 목적이므로 핵심 설정만 변경하자

1. host
   - 외부 접속 허용
     - 기존 host 주석 처리 후 bind 0.0.0.0 추가 
2. port
   - default port는 6379
     - 그대로 두자
3. password
   - requirepass password1234

redis를 재시작 하자

```shell
systemctl restart redis
```

redis-cli 명령어로 구동 여부를 테스트 한다.

```
redis-cli
>ping
pong
```

