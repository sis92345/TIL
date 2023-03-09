# docker build

<aside>
🪣 docker build는 Container를 build할 때 사용한다

</aside>

# 사용

> `docker build [OPTIONS] PATH | URL | -`
> 

# Dockerfile 이름을 변경하거나 다른 Path를 사용하고 싶을 경우

`-f` 옵션으로 이미지 설정 파일 로드 후 이미지 대상 폴더를 지정

```bash
docker build -f ./DockerfilesOpt .
```

# 이미지에 태그 지정

이미지에 이름을 부여하는 것을 태그라 한다.

> `name : tag`
name은 일반적인 이미지 그룹 이름을 말한다.
tag는 옵션으로 이미지의 특정 버전을 지정한다.
예를 들어 `node:14` 에서 node는 이름이고 14는 태그다.
컨테이너를 생성할 때 이 태그를 사용해서 컨테이너를 생성할 수 있다.
> 

---

# 옵션

--add-host list           Add a custom host-to-IP mapping (host:ip)
--build-arg list          Set build-time variables
--cache-from strings      Images to consider as cache sources
--disable-content-trust   Skip image verification (default true)
**-f, --file string             도커 파일 이름(Deafuit is'  PH/HDockerfile')**
--iidfile string          Write the image ID to the file
--isolation string        Container isolation technology
--label list              Set metadata for an image
--network string          Set the networking mode for the RUN instructions during build (default "default")
--no-cache                Do not use cache when building the image
-o, --output stringArray      Output destination (format: type=local,dest=path)
--platform string         Set platform if server is multi-platform capable
--progress string         Set type of progress output (auto, plain, tty). Use plain to show container output (default "auto")
--pull                    Always attempt to pull a newer version of the image
-q, --quiet                   Suppress the build output and print image ID on success
--secret stringArray      Secret file to expose to the build (only if BuildKit enabled): id=mysecret,src=/local/secret
--ssh stringArray         SSH agent socket or keys to expose to the build (only if BuildKit enabled) (format: default|<id>[=<socket>|<key>[,<key>]])
**-t, --tag list                Name and optionally a tag in the 'name:tag' format**
--target string           Set the target build stage to build.

# 발생 이슈

## 1. 도커 파일 이름의 기본은 `Dockerfile`이다.

`DockerFIle`, `dockerfile`, `dockerFile` 모두 `-f` 옵션 없이 build하면 `Dockerfile`을 못찾아서 오류를 발생시킨다.

`-f` 옵션을 사용하면 별도의 이름으로 사용할 수 있다.