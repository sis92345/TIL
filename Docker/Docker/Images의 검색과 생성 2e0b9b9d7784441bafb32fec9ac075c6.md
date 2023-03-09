# Images의 검색과 생성

# Image를 사용하기 위해선…

## 이미 만들어진 이미지를 사용하거나

미리 구축된 공식 이미지나 팀원이 공유한 이미지, Docker hub에서 이런 이미 구축된 이미지를 사용한다

[Docker](https://hub.docker.com/search?q=)

`docker run node` 명령어를 입력하면 local에서 찾다가 없으니까 설치해서 run 하는 것을 확인 할 수 있다. 

```bash
docker run node

Unable to find image 'node:latest' locally
latest: Pulling from library/node
80dae1b9d879: Pull complete
13ae98695cf4: Pull complete
09a74e69230a: Pull complete
0e04cd4cd2ee: Pull complete
d9ce95a1e837: Extracting [=>                                                 ]  4.456MB/189.8MB
664da4339821: Download complete
bdbfad5b27e1: Downloading [============================================>      ]  41.55MB/46.24MB
eb8fa1c2ca62: Download complete
76d44c991c84: Download complete
```

`docker ps -a` 명령어로 모든 docker container를 조회하면 node container가 생성됬음을 알 수 있다.

```bash
docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS                          PORTS                                       NAMES
a59e84dbe576   node           "docker-entrypoint.s…"   About a minute ago   Exited (0) About a minute ago
```

run 명령어를 사용했지만 실제 node로 *interactive shell*이 바로 실행되지 않는다. Container는 격리되어 실행되기 때문에 자동으로 우리에게 노출되지 않기 때문이다.

이를 위해서 다시 `docker run node` 를 사용한다. 이번에는 -it 옵션으로 *interactive shell*에 직접 진입한다.

### 유의점 1 : host os에서 실행중인 node가 아님을 유의

중요한건 run 후 실행된 *interactive shell*은 host os의 shell이 아님을 유의해야 한다. 다른 terminal을 띄어서 node -v를 입력하면 다른 노드 버전이 띄어질 것이다.

```bash
docker run -it node
Welcome to Node.js v19.7.0.
Type ".help" for more information.
>
```

### 유의점 2: 하나의 image로 2개의 Container를 실행함을 유의

또한 하나의 node 이미지로 2개의 Container가 실행됬음을 유의하라

```bash
docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                        PORTS                                       NAMES
b4bcfd131fe5   node           "docker-entrypoint.s…"   4 minutes ago    Up 4 minutes                                                              great_sutherland
a59e84dbe576   node           "docker-entrypoint.s…"   10 minutes ago   Exited (0) 10 minutes ago                                                 nervous_yalow
```

![Untitled](Images%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%A5%E1%86%B7%E1%84%89%E1%85%A2%E1%86%A8%E1%84%80%E1%85%AA%20%E1%84%89%E1%85%A2%E1%86%BC%E1%84%89%E1%85%A5%E1%86%BC%202e0b9b9d7784441bafb32fec9ac075c6/Untitled.png)

![Untitled](Images%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%A5%E1%86%B7%E1%84%89%E1%85%A2%E1%86%A8%E1%84%80%E1%85%AA%20%E1%84%89%E1%85%A2%E1%86%BC%E1%84%89%E1%85%A5%E1%86%BC%202e0b9b9d7784441bafb32fec9ac075c6/Untitled%201.png)

## 직접 이미지를 만든다

사실 이미지를 받아서 위의 node 예처럼 그대로 실행하는 경우는 없다. **대부분의 경우는 이미 만들어진 이미지를 기반으로 자신의 이미지를 구성해서 사용한다.** 

이때 필요한 파일이 `Dockerfile`이다.

# Dockerfile을 사용한 자체 이미지 구축

App이 완성되었다면 이미지를 빌드해야 한다. 기본적으로 빌드 후 코드가 변경되면 다시 빌드해야 하지만 더 좋은 방법도 있다. 빌드 생성시 스냅샷이 생성됨을 알고만 있자

## Dockerfile 작성

[Dockerfile](Images%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%A5%E1%86%B7%E1%84%89%E1%85%A2%E1%86%A8%E1%84%80%E1%85%AA%20%E1%84%89%E1%85%A2%E1%86%BC%E1%84%89%E1%85%A5%E1%86%BC%202e0b9b9d7784441bafb32fec9ac075c6/Untitled.txt)

```docker
# 다른 이미지를 가져온다. 
## 여기서는 예제 구동에 필요한 node 14 이미지 사용
## 이미지는 docker hub나 local에 존재하는 모든 이미지 사용 가능
## 다운로드시 로컬에 캐시됨,
FROM node:14

# 컨테이너 내부의 작업 디렉토리 설정
## 앞으로의 모든 RUN은 /app에서 실행됨
WORKDIR /app

# 어떤 파일을 사용하는지 명령
## COPY [Host File System] [Image/Container FIle system]
## 첫번째 .은 Dockerfile을 제외한 모든 프로젝트의 폴더와 하위 폴더를 복사애햐 한다고 알린다.
## 두번째 .은 복사된 파일은 컨테이너 위에서 지정한 WORKDIR /app에서 실행되므로 /app을 의미
### 커스텀해서 사용하는 것이 좋다. 예제에서는 컨테이너 내부의 /app으로 지정한다.
COPY . /app

# 컨테이너. 이미지 내부에서 명령어를 사용한다.

RUN npm install

# 컨테이너 내부에서 외부와 네트워킹할 때 포트를 지정
## 예제에서는 80번 port로 사용하도록 지정되어 있음
## 문서화임, 실제로 작동하지 않음, 다만 추천하는 방법입니다.
## 실제로 80번 port사용하기 위해서 run 명령어 옵션 중 -p 옵션을 사용해야 함
EXPOSE 80

# 아래처럼 이미지 사용시 바로 server를 run할 수 있다.
## 하지만 images는 Container의 템플릿이다. 
### 이미지가 직접 Application을 실행하면 빌드시 App이 실행된다.
### 따라서 이미지가 직접 App을 사용하는 것은 지양하자
#RUN node server.js 

# CMD는 이미지를 실행하지 않고 컨테이너가 시작될 때 실행된다
## 따라서 아래 처럼 CMD를 사용해서 컨테이너가 시작될 때 App을 실행하도록 하는것이 옳다
## RUN과 달리 문자열 배열을 사용해서 명령어를 사용한다.
## CMD가 없으면 Base 이미지가 실행되고 베이스 이미지가 없으면 오류 발생
CMD [ "node" , "server.js" ]
```

## Dockerfile 이미지를 사용한 이미지 구축

```bash
# 현재 경로의 Dockerfile을 사용해서 도커 이미지를 구축하고 이름을 docker-example, tag를 2로 지정한다.
docker build -t docker-example:2 .
```

## 구축된 이미지로 컨테이너 생성

```bash
# image 조회
docker images

# 조회된 image id로 container 생성
## EXPOSE에서 노출시켰지만 실제로는 명령어로 처리해야 함
## -p [app에 접근하려는 local port]:[Docker 컨테이너 내부 노출 포트]
docker -p 80:80 4aec77705dff

# 아래 명령어는 로컬 포트 3000으로 접근할 경우 컨테이너 내부의 80번 포트로 연결한다.
docker -p 3000:80 4aec77705dff
```

![Untitled](Images%E1%84%8B%E1%85%B4%20%E1%84%80%E1%85%A5%E1%86%B7%E1%84%89%E1%85%A2%E1%86%A8%E1%84%80%E1%85%AA%20%E1%84%89%E1%85%A2%E1%86%BC%E1%84%89%E1%85%A5%E1%86%BC%202e0b9b9d7784441bafb32fec9ac075c6/Untitled%202.png)

---

# Dockerfile 최적화

## Image는 Layer 기반이다.

Docker는 Dockerfile 명령어를 기반으로 코드나 명령어가 변경되지 않았으면 이전에 캐시된 결과를 사용한다. 

쉽게 말해 다시 실행해야 하는 항목만 다시 실행하여 이미지 구축 속도를 높인다.

최종 명령 이전의 모든 명령어는 이미지의 일부이지만 별도의 레이어이다. 예를 들어 소스를 변경하면 COPY 명령어만 다시 실행한다. 그 이후 레이어는 캐시된 것을 사용할 수 없으므로 다시 실행한다.

## 예

- 예제 Dockerfile

```bash
FROM node:14

WORKDIR /app

COPY . /app

RUN npm install

EXPOSE 80

CMD [ "node" , "server.js" ]
```

### 1. 소스 코드 수정하지 않고 image build : 0.9초

**WORKDIR 하위 모든 명령어가 cache를 사용한다.**

```bash
docker build .

[+] Building 0.9s (9/9) FINISHED                                                                                                                                                                          
 => [internal] load build definition from Dockerfile                                                                                                                                                 0.0s
 => => transferring dockerfile: 129B                                                                                                                                                                 0.0s
 => [internal] load .dockerignore                                                                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/node:14                                                                                                                                           0.8s
 => [1/4] FROM docker.io/library/node:14@sha256:1b5300317e95ed8bb2a1c25003f57e52400ce7af1e2e1efd9f52407293f88317                                                                                     0.0s
 => [internal] load build context                                                                                                                                                                    0.0s
 => => transferring context: 682B                                                                                                                                                                    0.0s
 => **CACHED [2/4] WORKDIR /app**                                                                                                                                                                        0.0s
 => **CACHED [3/4] COPY . /app**                                                                                                                                                                         0.0s
 => **CACHED [4/4] RUN npm install**                                                                                                                                                                     0.0s
 => exporting to image                                                                                                                                                                               0.0s
 => => exporting layers                                                                                                                                                                              0.0s
 => => writing image sha256:4aec77705dff0d948570a50f5d5d12e546c96e8aab6eacec53da2230f5525095                                                                                                         0.0s

```

### 2. 소스를 수정하여 image build : 3초

소스가 수정되었으므로 COPY 명령어가 다시 실행되었다. 그 하위 install 명령어는 소스 코드 변경에 따른 cache 여부를 알 수 없으므로 다시 실행된다.

```bash
docker build .
[+] Building 3.0s (9/9) FINISHED                                                                                                                                                                          
 => [internal] load build definition from Dockerfile                                                                                                                                                 0.0s
 => => transferring dockerfile: 129B                                                                                                                                                                 0.0s
 => [internal] load .dockerignore                                                                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/node:14                                                                                                                                           0.8s
 => [internal] load build context                                                                                                                                                                    0.0s
 => => transferring context: 1.63kB                                                                                                                                                                  0.0s
 => [1/4] FROM docker.io/library/node:14@sha256:1b5300317e95ed8bb2a1c25003f57e52400ce7af1e2e1efd9f52407293f88317                                                                                     0.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                                                                        0.0s
 => [3/4] COPY . /app                                                                                                                                                                                0.0s
 => [4/4] RUN npm install                                                                                                                                                                            2.0s
 => exporting to image                                                                                                                                                                               0.1s
 => => exporting layers                                                                                                                                                                              0.1s
 => => writing image sha256:602d2896be7b602190a509688edbeb01a48ea87e02034fcaf4a453410449e47f                                                                                                         0.0s
```

우리는 package.json을 수정하지 않았으므로 npm install을 다시 할 필요가 없다. npm install을 하지 않으려면 package.json을 먼저 복사해서 npm install이 필요 없음을 알려야 한다.

```docker
FROM node:14

WORKDIR /app

# npm install cache 안되는거 방지용
COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 80

CMD [ "node" , "server.js" ]
```

### 3. Dockerfile 최적화를 통한 이미지 빌드 최적화 0.9

소스를 변경했음에도 0.9초 밖에 걸리지 않음을 알 수 있다. npm install을 cache 처리 하도록 변경되었기 때문이다. 실제로 코드를 보면 COPY만 다시 실행되고 나머지는 cache 처리 되었음을 유의하라

```bash
docker build -f ./DockerfilesOpt .
[+] Building 0.9s (10/10) FINISHED                                                                                                                                                                        
 => [internal] load build definition from DockerfilesOpt                                                                                                                                             0.0s
 => => transferring dockerfile: 41B                                                                                                                                                                  0.0s
 => [internal] load .dockerignore                                                                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/node:14                                                                                                                                           0.8s
 => [1/5] FROM docker.io/library/node:14@sha256:1b5300317e95ed8bb2a1c25003f57e52400ce7af1e2e1efd9f52407293f88317                                                                                     0.0s
 => [internal] load build context                                                                                                                                                                    0.0s
 => => transferring context: 1.67kB                                                                                                                                                                  0.0s
 => CACHED [2/5] WORKDIR /app                                                                                                                                                                        0.0s
 => CACHED [3/5] COPY package.json /app                                                                                                                                                              0.0s
 => CACHED [4/5] RUN npm install                                                                                                                                                                     0.0s
 => [5/5] COPY . /app                                                                                                                                                                                0.0s
 => exporting to image                                                                                                                                                                               0.0s
 => => exporting layers                                                                                                                                                                              0.0s
 => => writing image sha256:d8bce1b036e0396bb41e5da6e2739beaafee5f8184ea57125677c364ffcfe4dc
```