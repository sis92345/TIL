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

