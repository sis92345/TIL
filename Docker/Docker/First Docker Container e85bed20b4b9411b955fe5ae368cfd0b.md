# First Docker Container

# 목표

1. 아래 예제 코드를 Container로 생성하기

# 예제 코드 : App

```jsx
import express from 'express';

import connectToDatabase from './helpers.mjs'

const app = express();

app.get('/', (req, res) => {
  res.send('<h2>Hi there!</h2>');
});

await connectToDatabase();

app.listen(3000);
```

# Dockerfile 생성

> 도커 컨테이너 생성 명령 파일은 `Dockerfile`이다. `DockerFile`같은 이름으로 지정햇을 경우 build시 `-f` 옵션으로 도커 파일을 지정해야 한다.
[docker build](docker%20build%20de1c4149c52e4d7ea166dcca2f68a2c0.md)
> 

확장자 없이 생성, Docker에게 컨테이너를 설정하는 방법을 설명

```jsx
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "node" , "app.mjs" ]
```

# Docker Build

Docker의 Build 명령어를 사용해서 Container를 빌드한다.

```bash
# docker build [Dockerfile path]
docker build .

# docker build [-t name] [-f Dockerfile Path]
docker build -t docker:first -f ./MyDockerFile
```

# Docker images

생성된 Docker의 이미지를 조회한다. 방금 생성한 docker:first의 image id인 `b69a69ca7117` 를 확인한다.

[docker images](docker%20images%209b37c8f6525b453fb586abba7d60458d.md) 

```bash
docker images

REPOSITORY                                      TAG            IMAGE ID       CREATED         SIZE
**docker                                          first          b69a69ca7117   7 minutes ago   863MB**
node                                            14             8924de3b4855   9 months ago    892MB
basic_centos                                    latest         e4da86fbe9eb   9 months ago    648MB
ubuntu                                          latest         a457a74c9aaa   12 months ago   65.6MB
centos                                          latest         e6a0117ec169   17 months ago   272MB
alpine/git                                      latest         cfd9fa28a348   21 months ago   25.2MB
docker.elastic.co/elasticsearch/elasticsearch   7.10.2-arm64   76bf9f270031   2 years ago     855MB
jaspeen/oracle-11g                              latest         0c8711fe4f0f   7 years ago     281MB
```

# Docker Run

방금 조회한 image id로 image를 run한다. port는 3000을 사용한다.

```bash
docker run -p 3000:3000 b69a69ca711
```

![Untitled](First%20Docker%20Container%20e85bed20b4b9411b955fe5ae368cfd0b/Untitled.png)

# Docker ps

방금 올린 컨테이너를 중지하기 위해서 현재 돌아가는 Docker를 조회한다.  

```bash
docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
b7ab06d70c08   b69a69ca711   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   keen_banzai
```

# Docker stop

컨테이너를 중지한다.

```bash
docker stop b7ab06d70c08
```