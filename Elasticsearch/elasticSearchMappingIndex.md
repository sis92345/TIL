# Elasticsearch : Mapping and Index

- [Data Set](https://grouplens.org/datasets/movielens/)

## 1. Mapping

`Mapping` 은 schema를 정의할 수 있습니다. Mapping을 통해서 데이터에 무엇을 정의하고 어떻게 인덱스 하는지 정의할 수 있습니다.

```shell
// PUT : index에 데이터를 추가
// /movie : index의 이름
curl -XPUT 127.0.0.1:9200/movies -d '
{
	"mappings" : {
		"properties" : {
			"year" : { "type" : "date" }
		}
	}
}
'
```

- Url : `${elastic_search_host_port}/${indexname}` --> 인덱스 최초 생성

  - mapping 정보 불러오기 : `${elastic_search_host_port}/${indexname}/_mapping`

- Mapping의 예

  - Field types

    - String , byte , short , integer , long, float , double , boolean , date

  - Field index : full-text-search를 원하지 않는 경우 not_analyzed로 사용 가능

    ```
    "properties" : {
    	"genre" : { "index" : "not_analyzed" }
    }
    ```

  - Field Analyzer : tokenizer와 token filter를 정의

    ```
    "properties" : {
    	"description" : { "analyzer" : "english" }
    }
    ```

    - Character Filter : HTML 인코딩을제거하거나 Convert
    - Tokenizer : String의 공백을 제거하거나 split 시킴 단어를 토큰화 하는 역할
    - Token Filter : Lowercaster , stopwords stemming , synonyms
    - standard : 범위 안에서 단어를 분리 , split 제거 , lowercase 
    - simple : lowercase , 단어가 아닌 것들을 분리
    - whitespace : 공백을 기준으로 분리
    - Language : 특정 단어를 stopword로 추가하거나 stemming 

## 2. INSERT

- curl

  ```shell
  curl -XPUT 127:0.0.1:9200/movies/_doc/109487 -d '{ "genre" : ["IMAX" , "Sci-Fi"], "title" : "Interstellar" , "year" : "2014" }'
  
  curl -H "Content-type: application/json"  -XPUT 127.0.0.1:9200/movies/_doc/1094890 -d '{ "genre" : ["IMAX" , "Hero" , "Marble" ], "title" : "Spider-Man: Far From Home " , "year" : "2021" }'
  ```
  
  - 위 데이터를 가져와보자
  
    ```url
    http://localhost:9200/movies/_search?pretty&q=title:spider
    
    // 결과
    {
      "took" : 16,
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
        "max_score" : 1.3975171,
        "hits" : [
          {
            "_index" : "movies",
            "_type" : "_doc",
            "_id" : "1094890",
            "_score" : 1.3975171,
            "_source" : {
              "genre" : [
                "IMAX",
                "Hero",
                "Marble"
              ],
              "title" : "Spider-Man: Far From Home ",
              "year" : "2021"
            }
          }
        ]
      }
    }
    ```
  
    

## 3. INSERT_BULK

- Elasticsearch에서 데이터를 대량으로 Insert하는 방법이다.

- url : `${elastic_search_host_port}/${indexname}/_bulk`

  ```shell
  curl -XPUT 127.0.0.1/_bulk
  ```

- **주의점**

  - **`_bulk`를 사용할 때  Javascript에서 Content-type은 `application/x-ndjson`이어야 한다**. 만약 그냥  `application/json`으로 요청 시 다음과 같은 오류를 볼 수 있다.

    ```
    The bulk request must be terminated by a newline [\n]
    ```

  - data의 끝에는 반드시 `\n`이 와야한다. elasticsearch는 bulk insert시 Coordinate Node에서 데이터를 chunks로 줄 기준( === `\n` )으로 분리하고 각 Node에 해당 chunks를 보낸다. 따라서 반드시 New line을 기준으로 format을 잡는 `application/x-ndjson`를 사용해야 한다.

- data set

  ```json
  { "index" : { "_index" : "worldcity" , "_id" : "1" }} // create : _index에서는 데이터를 넣은 index의 이름을 지정한다. _id에는 document의 아이디를 지정한다.
  {"id":1,"name":"Kabul","countryCode":"AFG","district":"Kabol","population":"1780000"} //실제 데이터
  { "index" : { "_index" : "worldcity" , "_id" : "2" }}
  {"id":2,"name":"Qandahar","countryCode":"AFG","district":"Qandahar","population":"237500"}
  ```

## 4. Update

사실 Elasticsearch에서는 document는 immutable하기 때문에 update가 불가능하다. 따라서 Elasticsearch에서는  실제 Update가 아니라 _version을 업데이트 해서 새로운 document를 생성하는 방식이다. 옛 document는 삭제하기 위해 표시된다( 나중에 삭제됨 ) _version은 data를  insert할 때 자동으로 생성된다. id와 마찬가지로 version도 unique하기 때문에  Elasticsearch는 자동으로 최신 _version을 사용한다.

- Url : `${elastic_search_host_port}/${indexname}/${documentType}/${documentId}/_update`

- Format : Curl

  ```json
  curl -XPOST 127.0.0.1:9200/movies/_doc/109487/_update/ -d '
  {
    "doc" : {
      "title" : "Interstellar" // movies index의 doc type의 109587 title을 변경 
    }
  }
  '
  ```

  - Example : Seoul 인구수를 변경

    - 데이터

      ```json
      // http://localhost:9200/worldcity2/_search?pretty&q=name:seoul
      {
              "_index" : "worldcity2",
              "_type" : "_doc", // type
              "_id" : "2331",
              "_score" : 8.657387,
              "_source" : {
                "id" : 2331,
                "name" : "Seoul",
                "countryCode" : "KOR",
                "district" : "Seoul",
                "population" : "9981619"
              }
            }
      ```

    - update 요청

      ```json
      // http://localhost:3000/worldcity/_doc/2331/_update
      update_qeury : {
              "doc" : {
                "population" : 9520880 //인구를 변경
              }
      },
      ```

      

    - 결과

      ```json
      // update 반환 데이터
      {
          "_index": "worldcity",
          "_type": "_doc",
          "_id": "2331",
          "_version": 8,
          "result": "updated",
          "_shards": {
              "total": 2,
              "successful": 1,
              "failed": 0
          },
          "_seq_no": 20535,
          "_primary_term": 7
      }
      
      // 재 조회 데이터
      {
        "_index" : "worldcity",
        "_type" : "_doc",
        "_id" : "2331",
        "_version" : 8,
        "_seq_no" : 20535,
        "_primary_term" : 7,
        "found" : true,
        "_source" : {
          "id" : 2331,
          "name" : "Seoul",
          "countryCode" : "KOR",
          "district" : "Seoul",
          "population" : 9520880
        }
      }
      ```

      

## 5. DELETE

DELETE는 RESTAPI로 쉽게 처리할 수 있다.

- Url : `curl -XDELETE ${elastic_search_host_port}/${indexname}/${documentType}/${documentId}`

- example

  ```shell
  curl -XDELETE 127.0.0.1:9200/movies/_doc/1094890
  ```

  
