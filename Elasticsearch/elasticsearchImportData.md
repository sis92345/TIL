# Elasticsearch Import Data

Elasticsearch로 검색을 하기위해서는 Data를 입력해야 합니다. 기존 연습까지는 `_bulk` API를 이용해서 데이터를 가져와왔습니다.

```json
curl -H "Content-type: application/json(or x-ndjson)" -XPORT "127.0.0.1:9200/{index}/_bulk"
{ "index" : { "_index" : "worldcity" , "_id" : "1" }} 
{"id":1,"name":"Kabul","countryCode":"AFG","district":"Kabol","population":"1780000"}
{ "index" : { "_index" : "worldcity" , "_id" : "2" }}
{"id":2,"name":"Qandahar","countryCode":"AFG","district":"Qandahar","population":"237500"}
```

사실 Elasticsearch로 Data를 Import할 방법은 많습니다. 저 또한 예제는 curl로 import하는 방법을 적었지만 저는 Javascript로 data를 import하고 있었습니다.

```javascript
// Script로 데이터를 Insert하는 예
insertToElasticSearch(){
      let json = "";
			
  		// 1. Parent - Child 구조를 만들기 위해 데이터 가공
      this.worldList.forEach( item => {
        item.parentCountry = { name : "childCity" , parent : item.countryCode }
      } );
			
  		// 2. Create Json 생성
      this.worldList.forEach( item => {
        const a = '{ "index" : { "_index" : "country" , "_id" : "' + item.id + '" , "routing" : 1 }}\n' + JSON.stringify(item) + "\n";
        json += a;
      } );
			
  		// 3. Data Bulk Insert
      this.$axios.post( "/country/_bulk" , json   , { headers : { "Content-Type": "application/x-ndjson" } }).then( res  => {
        debugger;
      } )

    },
```

따라서 이번에 다룰 주제는 Elasticsearch에 Data를 Import하는 다양한 방법입니다. 저처럼 RESTApi를 이용해서 Javascript를 사용해서 Data를 Import할 수 도 있고 , `logstash`나 `beat`를 이용해서 DB나 log에서 data를 stream으로 뽑아올 수 있습니다. 또한  Kafka나 AWS에서는 자체적으로 Elasticsearch에 Data를  Insert할 수 있는 방법을 제공합니다. 

# 1. Logstash

Logstash는 형식이나 복잡성과 관계 없이 데이터를 동적으로 수집, 전환, 전송합니다. grok을 이용해 비구조적 데이터에서 구조를 도출하여 IP 주소에서 위치 정보 좌표를 해독하고, 민감한 필드를 익명화하거나 제외시키며, 전반적인 처리를 손쉽게 해줍니다. DB나 로컬 logFile이나 S3등 데이터가 존재하는 곳에서 데이터를 수집해서 Elasticsearch로 data를 쉽게 Insert할 수 있는 tool입니다.

기존에 JavaScript를 사용한다면 Data를 직접 구조에 맞게 전환시키는 수고가 들었지만 LogStash를 사용하면 Data를 parse하고 filter하여 쉽게 transfer할 수 있습니다. 또한 보안에 민감한 데이터를 익명화 시키거나 전체 데이터를 import할 수 있으며 최소 하나의 데이터가 전송됨을 보장합니다.

## 1-1. Logstash 실행 예제

0. LogStats Install In Mac

   ```shell
   brew install elastic/tap/logstash-full // elastic/tap가 설치되어 있다면 logstash-full 
   ```

   ```shell
   brew services start elastic/tap/logstash-full // service 등록
   ```

1. Logstash Conf 추가

   ```
     // /opt/homebrew/Cellar/logstash-full/7.16.2/libexec/config/myconf.conf
     input {
          file {
            path => '/Users/asdasd/Documents/00.repositoy/javaStudy/ logs/flatMap_Test/*.log'
          }
        }
   
        output {
          elasticsearch  { hosts => [ "localhost:9200"  ]  }
          stdout {
            codec => rubydebug
          }
        }
    
   ```

2. Logstash Start

   ```shell
   logstash -f myconf.conf	// 파일로 설정
   ```

3. result

   ```
   {
             "host" => "asdasd-ui-MacBookPro.local",
         "@version" => "1",
          "message" => "[ INFO ] [21:20:04.686] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T21:20:04.686] , TIME : 0 MILLISECONDS",
             "path" => "/Users/asdasd/Documents/00.repositoy/javaStudy/logs/flatMap_Test/log.log",
       "@timestamp" => 2021-12-26T10:22:11.251Z
   }
   ```

   ```json
   {
           "_index" : "logstash-2021.12.26-000001",
           "_type" : "_doc",
           "_id" : "JudD9n0Bo8_F02D1F2-e",
           "_score" : 1.0,
           "_source" : {
             "host" : "개인정보",
             "@version" : "1",
             "message" : "[ INFO ] [21:20:03.077] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T21:20:03.076] , TIME : 0 MILLISECONDS",
             "path" : "/개인정보/log.log",
             "@timestamp" : "2021-12-26T10:22:11.250Z"
           }
         },
   ```

   
