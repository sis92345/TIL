# Mac에서 ElasticSearch 설치 하기

## 1. Homebrew를 이용한 설치

ElasticeSearch는 Apache Lucene open source library를 기반으로 검색 엔진입니다. ElasticSearch는 검색엔진에서 조회한 결과를 시각화하는 도구인 kibana와 함께 사용됩니다. 또한 데이터를 실시간으로 얻어야할 필요가 있으므로 logstash와 함께 사용됩니다. 그래서 이 3개를 ElasticSearch stack이라고 합니다.

- ElasticSearch Stack
  1. Elasticsearch
  2. kibana
  3. Logstash

Mac에서 elasticsearch를 사용하기 위해서 homebrew를 사용하였다. install로 다운로드할 경우 오류를 뱉으면서 다운이 불가능하므로 `tab` 명령어로 설치한다. tab은 Homebrew 내의 기본 저장소인 Formulae이 외의 서드 파티 저장소라고 할 수 있다.

```
brew tap elastic/tap	//elastic homebrew repository 설치
brew install elastic/tap/elasticsearch-full // elastic/tap에서 elasticsearch를 모두 설치
```

## 2. Elasticsearch 폴더 구조 by installed Homebrrew

| Type    | 설명                                                         | 기본 위치                                                    |      |
| ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| home    | ElasticSearch 홈 디렉토리 또는 $ES_HOME                      | /opt/homebrew/var/homebrew/linked/elasticsearch-full         |      |
| bin     | elasticsearch를 시작하기 위한 기본 노드 와 elasticsearch-plugubBinary scripts | /opt/homebrew/var/elasticsearch                              |      |
| conf    | `Elasticsearch.yml`을 포함하는 설정 파일                     | /opt/homebrew/var/homebrew/linked/elasticsearch-full/libexec/config |      |
| Logs    | 로그 파일 위치                                               | /opt/homebrew/var/log/elasticsearch                          |      |
| plugins | 플러그인 디렉토리                                            |                                                              |      |

간단하게 Elasticsearch를 시작해보자 다음 명령어를 terminal에 입력한다.

```shell
elasticsearch
```

ElasticSearch의 기본 포트는 9200이다. localhost:9200으로 접속 시 다음 JSON이 출력된다면 성공이다. 

```
{
  "name" : "anbyeonghyeon-ui-MacBookPro.local",
  "cluster_name" : "elasticsearch_anbyeonghyeon",
  "cluster_uuid" : "I8KiWYxkSgKz-xQnNcJzKA",
  "version" : {
    "number" : "7.16.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "5b38441b16b1ebb16a27c107a4c3865776e20c53",
    "build_date" : "2021-12-11T00:29:38.865893768Z",
    "build_snapshot" : false,
    "lucene_version" : "8.10.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

아래와 같은 오류가 뜰 경우 다음 명령어를 `elasticsearch.yml`에 추가한다.

```java
This could be due to running on an unsupported OS or distribution, missing OS libraries, or a problem with the temp directory. To bypass this problem by running Elasticsearch without machine learning functionality set
```

```
xpack.ml.enabled: false
```

ElasticSearch는 추후 Java11을 필요할 예정이다. 따라서 Java 8로 실행시 아래와 같은 경고 문구를 볼 수 있다.

```shell
warning: usage of JAVA_HOME is deprecated, use ES_JAVA_HOME
Future versions of Elasticsearch will require Java 11; your Java version from [내자바경로/Contents/Home/jre] does not meet this requirement. Consider switching to a distribution of Elasticsearch with a bundled JDK. If you are already using a distribution with a bundled JDK, ensure the JAVA_HOME environment variable is not set.
warning: usage of JAVA_HOME is deprecated, use ES_JAVA_HOME
Future versions of Elasticsearch will require Java 11; your Java version from [/내자바경로/Contents/Home/jre] does not meet this requirement. Consider switching to a distribution of Elasticsearch with a bundled JDK. If you are already using a distribution with a bundled JDK, ensure the JAVA_HOME environment variable is not set.
```

Java 11을 설치해서 ES_JAVA_HOME으로 환경변수를 잡아주자 JAVA 11은 개인적으로 사용하고 있는 `julu-jdk`를 설치했다.

-  설치 : [zulu jdk 11](https://www.azul.com/downloads/?package=jdk)

-  zshrc 설정 추가

  ```shell
  vim ~/.zshrc
  
  // 다음을 추가
   export ES_JAVA_HOME=/내자바경로!!!/zulu11.52.13-ca-jdk11.0.13-macosx_x64
   export PATH=${PATH}:$JAVA_HOME/bin:$ES_JAVA_HOME/bin
   
  // reload
  source ~/.zshrc
  
  // check
  echo $ES_JAVA_HOME
  ```

Java 11을 설치하고 ES_JAVA_HOME 환경변수를 잡았다면 위 메시지는 안 뜨는 것을 확인 할 수 있다.

```shell
OpenJDK 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
```



## 3. Elasticsearch 설정하기

ElasticSearch는 설정을 위해 3가지 파일이 필요하다.

- elasticsearch.yml : ElasticSearch 설정 파일
- `jvm.option` : JVM 설정 
- `log4j2.properties` : ElasticSearch 로깅 처리

개인적으로 사용한 설정은 아래와 같다.

```shell
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: elasticsearch
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: node-1
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /opt/homebrew/var/lib/elasticsearch/
#
# Path to log files:
#
path.logs: /opt/homebrew/var/log/elasticsearch/
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# By default Elasticsearch is only accessible on localhost. Set a different
# address here to expose this node on the network:
#
network.host: 0.0.0.0
#
# By default Elasticsearch listens for HTTP traffic on the first free port it
# finds starting at 9200. Set a specific HTTP port here:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.seed_hosts: ["127.0.0.1"]
#
# Bootstrap the cluster using an initial set of master-eligible nodes:
#
#cluster.initial_master_nodes: ["node-1", "node-2"]
#
# For more information, consult the discovery and cluster formation module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
#
# ---------------------------------- Security ----------------------------------
#
#                                 *** WARNING ***
#
# Elasticsearch security features are not enabled by default.
# These features are free, but require configuration changes to enable them.
# This means that users don’t have to provide credentials and can get full access
# to the cluster. Network connections are also not encrypted.
#
# To protect your data, we strongly encourage you to enable the Elasticsearch security features. 
# Refer to the following documentation for instructions.
#
# https://www.elastic.co/guide/en/elasticsearch/reference/7.16/configuring-stack-security.html

# FOR ERROR : M1 Mac에서 에러나서 수
xpack.ml.enabled: false
```

## 4. 예제

- 다음 강의의 예제임 : [Elasticsearch](https://www.udemy.com/course/elasticsearch-7-and-elastic-stack/learn/lecture/14728692?start=227#overview)

  ```shell
  wget http://media.sundog-soft.com/es7/shakes-mapping.json
  curl -H "Content-Type: application/json"  -XPUT 127.0.0.1:9200/shakespeare --data-binary @shakes-mapping.json
  wget http://media.sundog-soft.com/es7/shakespeare_7.0.json
  curl -H "Content-type: application/json" -XPOST '127.0.0.1:9200/shakespeare/_bulk' --data-binary @shakespeare_7.0.json
  curl -H "Content-type: application/json" -XGET '127.0.0.1:9200/shakespeare/_search?pretty' -d'
  {
      "query" : {
      	"match_phrase" : { "text_entry" : "to be or not to be"
  			}
  		}
  }'
  ```

  ```shell
  curl -H "Content-type: application/json" -XGET '127.0.0.1:9200/shakespeare/_search?pretty' -d'
  {
  "query" : {
  "match_phrase" : { "text_entry" : "thy name is woman"
  }
  }
  }'
  {
    "took" : 56,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 14.889189,
      "hits" : [
        {
          "_index" : "shakespeare",
          "_type" : "_doc",
          "_id" : "32783",
          "_score" : 14.889189,
          "_source" : {
            "type" : "line",
            "line_id" : 32784,
            "play_name" : "Hamlet",
            "speech_number" : 20,
            "line_number" : "1.2.148",
            "speaker" : "HAMLET",
            "text_entry" : "Let me not think ont--Frailty, thy name is woman!--"
          }
        }
      ]
    }
  }
  ```

  

## 5. 간단히 날려본 쿼리들

처음 ElasticSearch에 입문하면서 처음으로 날려본 쿼리들입니다.

1. 기본 검색 , district가 kyonggi인 데이터를 반환합니다.

   ```
   {
     "query" : {
       "match_phrase" : { 
         "district" : "Kyonggi"
   		}
   	}
   }'
   ```

2. bool 쿼리 : 

   1. countryCode가 JPN이면서 district가 hirosima인 데이터를 반환합니다.

      ```
      {
      	"query" : {
        		"bool": {
            		"must": [
             				{ "match" : { "countryCode" : "JPN"  } },
             				{ "match" : { "district" : "Hiroshima" } }
         				 ]
        		 }
      	}
      }
      ```

   2. countryCode가 KOR이나 JPN인 데이터를 반환합니다.

      ```
      {
      "query" : {
              "bool": {
          "should": [
             { "match" : { "countryCode" : "JPN"  } },
             { "match" : { "countryCode" : "KOR" } }
          ]
        }
      }
      }
      ```




### 참고사항

1. https://www.elastic.co/guide/en/elasticsearch/reference/current/brew.html
1. https://esbook.kimjmin.net
1. https://www.elastic.co/guide/kr/elasticsearch/reference/current/getting-started.html