# What is Data Volumn

# 왜 Container에 Data를 저장하면 안되는가?

컨테이너에서 실행되는 Application은 단순히 코드만 필요한게 아니다. Application이 돌아가기 위한 환경 변수, Application이 임시로 선언한 데이터, 영속성 데이터가 필요하다.

1. **Application** : Code + Environment
2. **Temporary App Data** : Application이 생성한 임시 데이터, 컨테이너에 저장된다.
3. **Permanent App Data** : DB 데이터 같은 임시 데이터, 컨테이너와 볼륨에 저장되어야 한다. **이 데이터는 컨테이너의 종료와 생성과 상관없는 영구적인 데이터여야 한다.**

![Untitled](What%20is%20Data%20Volumn%2069a116cda4164775b2a4b54ec184e633/Untitled.png)

여기서 Permanent Data를 저장할 때 사용하는 것이 Docker의 핵심 개념인 Volumn이다.

Container는 자체 파일 시스템을 기반으로 하기 때문에 로컬 시스템과 Container 내부의 파일 시스템은 연결 고리가 없다. **즉 Container의 파일 시스템은 처음에 말한대로 격리되어 있다. 따라서 Container가 제거되면 당연히 Container의 내부 파일은 모두 삭제된다. Container 내부에서 저장한 데이터, 파일은 모두 Container의 read-write layer에 저장되므로 Container 삭제 시 파일이 모두 삭제된다.**

따라서 우리는 Permanent Data를 Container에 저장하면 안된다. 이때 Docker에서 사용하는 것이 Docker의 핵심 개념인 Volumn이다.

# Docker Volumn

<aside>
📢 **Volumn은 Container에 Mounted된 host machine의 폴더이다.** 
Docker의 내장 기능으로 데이터를 유지하도록 돕는다.

</aside>

![Untitled](What%20is%20Data%20Volumn%2069a116cda4164775b2a4b54ec184e633/Untitled%201.png)

Volumn은 Container에 Mounted된 host machine의 폴더이다. Container 내부의 폴더를 host machine의 외부 폴더와 연결시킬 수 있다. 

Docker에서 영속성 데이터를 저장하고 사용하기 위해서 Volumn이 필요하다. 컨테이너에서 Volumn으로 영속성 데이터를 읽고 저장할 것이며 Volumn의 데이터는 Container와 무관하게 저장된다

# Docker Volumns의 종류

Volumns은 모두 로컬호스트의 폴더를 컨테이너에 마운트한다. 

### Anonymous Volumes

<aside>
📢 Docker가 관리하는 **컨테이너가 존재하는 동안에만 실존**하는 Volumes 
호스트 머신의 폴더와 연결되지만 Docker가 관리하는 임의의 경로와 연결된다.

</aside>

따라서 익명 볼륨은 하나의 컨테이너와 밀접하게 관련이 있다.

### Names Volumes

<aside>
📢 컨테이너가 종료된 후에도 유지되는 Volumn
마찬가지로 Docker가 관리한다.

</aside>

# Bind Mounts

<aside>
📢 호스트 머신의 파일 시스템 경로를 컨테이너 내부의 경로와 연결할 수 있는 저장소이다.

</aside>

Docker에서 사용하는 두 외부 저장소 중 하나인 Bind Mounts는 Volumn을 대신해서 사용할 수 있는 외부 저장소이다. **바인드 마운트는 호스트 머신의 폴더나 path를 직접 설정**하기 때문에 볼륨과 다르게 바인드 마운트의 소스 코드 수정 변경을 반영할 수 있다.

Docker Image는 폴더의 스냅샷이기 때문에 지금까지의 방식으로는 코드의 수정을 바로 반영할 수 없다. 따라서 우리는 소스 코드의 변경을 위해 이미지를 다시 빌드해야 한다.

따라서 Bind Mounts는 영구적이고 편집 가능한 데이터를 보관하는데 적합하다( Source Code )

## Bind Mount의 사용

<aside>
📢 -v “${hostMachineFolder/Path}:${Container Targer Folder/volume}”
-v "/Users/anbyeonghyeon/bindmountFolder:/app/feedback”

</aside>

실제 로딩 후 화면

![Untitled](What%20is%20Data%20Volumn%2069a116cda4164775b2a4b54ec184e633/Untitled%202.png)