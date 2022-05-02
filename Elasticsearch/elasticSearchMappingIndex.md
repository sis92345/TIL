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

Mapping이 필요한 이유는 2가지 입니다.

1. JSON Documents를 어떻게 저장할 것인가?
   - Data Type
   - Relations
   - Shards Number
   - Etc
2. 정의된 Process에서 어떻게 실제 결과를 가져올 것인가?

### 1-1. Daynamic / Explicit Mapping

mapping 설정은 [Dynamic mapping](https://www.elastic.co/guide/en/elasticsearch/reference/master/dynamic-field-mapping.html) 과 [Explicit mapping](https://www.elastic.co/guide/en/elasticsearch/reference/master/explicit-mapping.html)이 있습니다. 

- Daynamic Mapping
  - Elasticsearch가 문서에서 새 필드를 감지하면 기본적으로 유형 매핑에 *동적으로* 필드를 추가합니다. 즉 Elasticsearch가 Field와 DataType을 자동으로 정의해서 생성된  Mapping입니다.
- Explicit Mapping
  - Field와 DataType을 만들어서 Index에 직접적으로 정의하는 것입니다.

### 1-2. Mapping Explosion

Index에 많은 Field를 정의하면  `Mapping Explosion`이 발생할 수 있습니다. Mapping Explosion이 발생하면 메모리가 부족하거나 복구가 어려워질 수 있습니다. Dynamic Mapping에서 이 문제가 발생할 수 있습니다. document가 insert될 때 새로운 Field를  Mapping하기 때문입니다. 

Mapping Explosion을 방지하는 방법은 Mapping Limit 설정을 하는 방법이 있습니다. 또한 Flattern Data Type을 사용하면 Inner Object의 Field를 Mapping하지 않으므로 Mapping Explsion을 방지할 수 있습니다( 단 이 경우 Partial Search를 할 수 없음 )

## 2. INSERT

- curl

  ```shell
  curl -XPUT 127:0.0.1:9200/movies/_doc/109487 -d '{ "genre" : ["IMAX" , "Sci-Fi"], "title" : "Interstellar" , "year" : "2014" }'
  
  curl -H "Content-type: application/x-ndjson"  -XPUT 127.0.0.1:9200/movies/_doc/1094890 -d '{ "genre" : ["IMAX" , "Hero" , "Marble" ], "title" : "Spider-Man: Far From Home " , "year" : "2021" }'
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


## 6. Concurrency Issue

여러 클라이언트가 하나의 doucment를 동시에 접근해서 동시에 Update해서 사용할 경우 하나의 document를 접근해서 사용하므로 Concurrency 문제가 발생할 수 있습니다. 예를 들어 index에서 pageView를 조회한 후 pageView를 두 클라이언트가 동시에 업데이트 한다고 한다면 Race Condition이 발생할 수 있습니다.

Elasticsearch는 이 문제를 Optimistic Concurrency Control을 이용한 해결책을 제시합니다. 문서의 이전 버전이 새 버전을 덮어쓰지 않도록 하기 위해 문서에 수행된 모든 작업에는 해당 변경 사항을 조정하는 Primary shard에 의해 시퀀스 번호가 할당됩니다. 시퀀스 번호는 각 작업과 함께 증가하므로 새로운 작업은 이전 작업보다 높은 시퀀스 번호를 갖도록 보장됩니다. 그런 다음 Elasticsearch는 작업의 시퀀스 번호를 사용하여 더 작은 시퀀스 번호가 할당된 변경 사항에 의해 최신 문서 버전이 무시되지 않도록 할 수 있습니다.

예제로 확인해 봅시다.

```json
curl -H "Content-type: application/json" 127.0.0.1:9200/movies/_doc/109487\?pretty
{
  "_index" : "movies",
  "_type" : "_doc",
  "_id" : "109487",
  "_version" : 1,
  "_seq_no" : 0,					// seq_no 
  "_primary_term" : 1,		// primary term
  "found" : true,
  "_source" : {
    "genre" : [
      "IMAX",
      "Sci-Fi"
    ],
    "title" : "Interstellar",
    "year" : 2014
  }
}
```



Interstella의 _seq_no는 0 , _primary_term은 1입니다. 위 정보로 업데이트를 진행합니다.

```json
curl -H "Content-type:application/json" -XPUT "127.0.0.1:9200/movies/_doc/109487?if_seq_no=0&if_primary_term=1" -d '
{
    "genres" : [ "IMAX" , "Sci-Fi" ],
    "title" : "Interstellar 2",
    "year" : 2014
}'
{"_index":"movies","_type":"_doc","_id":"109487","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":10,"_primary_term":6}%
```

위 요청을 수정 없이 다시 보내면 오류가 발생합니다.

- [109487]: version conflict, required seqNo [0], primary term [1]. current document has seqNo [10] and primary term [6]

- 위 업데이트에서 받은 새로운 revision인 `"_seq_no":10,"_primary_term":6`으로 요청을 보냈다면 오류없이 잘 업데이트 됩니다.

  ```shell
  curl -H "Content-type: application/json" "127.0.0.1:9200/movies/109487?pretty&if_seq_no=10&if_primary_term-6" -d "data"
  ```

```json
curl -H "Content-type:application/json" -XPUT "127.0.0.1:9200/movies/_doc/109487?if_seq_no=0&if_primary_term=1&pretty" -d '
{
    "genres" : [ "IMAX" , "Sci-Fi" ],
    "title" : "Interstellar 2",
    "year" : 2014
}'
{
  "error" : {
    "root_cause" : [
      {
        "type" : "version_conflict_engine_exception",
        "reason" : "[109487]: version conflict, required seqNo [0], primary term [1]. current document has seqNo [10] and primary term [6]",
        "index_uuid" : "H83K-xRuT2SGhrqbApMqwQ",
        "shard" : "0",
        "index" : "movies"
      }
    ],
    "type" : "version_conflict_engine_exception",
    "reason" : "[109487]: version conflict, required seqNo [0], primary term [1]. current document has seqNo [10] and primary term [6]",
    "index_uuid" : "H83K-xRuT2SGhrqbApMqwQ",
    "shard" : "0",
    "index" : "movies"
  },
  "status" : 409
}
```

### 6-1. retry_on_confilct

위 예제는 Hard Coding으로 Coccurrency를 해결하는 방법입니다. 당연히 Elasticsearch는 Concurrency문제를 해결하기 위해서 파라메터 하나만 넘겨서 해결할 수 있도록 조치 했습니다.  

> **`retry_on_conflict`**
>
> (Optional, integer) Confilt가 발생했을 시 몇번 재시도할 지 결정합니다. Default: 0.
>
> _update API Query Parameter임을 명시

```json
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_doc/109487/_update?retry_on_conflict=5" -d '
{
  "doc" : {
"title" : "Interstellar 3"
}
}'
{"_index":"movies","_type":"_doc","_id":"109487","_version":3,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":11,"_primary_term":6}
```

## 7. Analyze And Tokenizer : Control Full-Text Search

Elasticsearch에서 검색시 검색어가 정확히 일치할 지( exact match ), 아니면 가장 관련도가 높은 결과를 매칭시킬지 결정할 수 있습니다( partical match ). 후자를 선택했다면 검색어의 대소문자 상관없이 매칭 시킬지 , 형태소 분석을 통해서 검색이 정확도를 높이거나 여러가지 분석 분석 방법을 선택할 수 있습니다. 이때 Analyzer는 field에서 어떤 방식으로 분석할건지 사용할 수 지정할 수 있습니다.

기본적으로 Elasticsearch는 Parical match로 검색을 합니다. 따라서 Start trek으로 검색한다면 자연스럽게 start wars와 star trek결과가 나옵니다. 우리가 입력한 title을 분석해서 결과를 보여주기 때문입니다. Star trek을 검색하면 anlayzer는 Star와 Trek으로 분리해서 Index의 inverted Index에서 검색 결과를 찾습니다. 따라서 Star Trek 검색시 Star Trek과 Star Wars결과가 동시에 나옵니다.

```json
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_search?pretty" -d '
{
 "query" : {
  "match" : {
   "title" : "Star trek"
  }
 }
}'
{
  "took" : 8,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 2.5194323,
    "hits" : [
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "135569",
        "_score" : 2.5194323, // 정확성
        "_source" : {
          "id" : "135569",
          "title" : "Star Trek Beyond",
          "year" : 2016,
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "122886",
        "_score" : 0.6699239, // 정확성
        "_source" : {
          "id" : "122886",
          "title" : "Star Wars: Episode VII - The Force Awakens",
          "year" : 2015,
          "genre" : [
            "Action",
            "Adventure",
            "Fantasy",
            "Sci-Fi",
            "IMAX"
          ]
        }
      }
    ]
  }
}
```

- Partical match의 경우 `_score` field를 통해 결과의 관련성을 숫자로 제공합니다. 검색 결과는 가장 높은 score를 가진 데이터가 먼저 정렬되서 나옵니다.

조금 더 정확한 검색을 하기 위해서 `match-phrase` 를 사용합니다. Star trek을 검색하므로 Star Wars 결과는 나오지 않습니다.

```json
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_search?pretty" -d '
{
 "query" : {
   "match_phrase" : {
quote> "title" : "Star Trek"
quote> }
quote> }
quote> }'
{
  "took" : 47,
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
    "max_score" : 2.519432,
    "hits" : [
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "135569",
        "_score" : 2.519432,
        "_source" : {
          "id" : "135569",
          "title" : "Star Trek Beyond",
          "year" : 2016,
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      }
    ]
  }
}
```



여기서 Analazer의 역할을 볼 수 있습니다. Elasticsearch에서 검색시 normailzed한 결과를 검색합니다. 따라서 이렇게 검색해도 동일하게 검색됩니다. 

```json
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_search?pretty" -d '
{
 "query" : {
   "match_phrase" : {
    "title" : "Star Trek"
    }
   }
 }'
```

이제 movies index를 삭제하고 새로 만들어 봅시다.

```json
curl -XDELETE "127.0.0.1:9200/movies" // index 삭제
curl -H "Content-type: application/json" -XPUT "127.0.0.1:9200/movies" -d '
{
 "mappings" : {
  "properties" : {
    "id" : { "type" : "integer" },
    "year" : { "type" : "date" },
    "genre" : { "type" : "keyword" },
    "title" : { "type" : "text" , "analyzer" : "english" }
   }}}
}'
curl -XPUT "127.0.0.1:9200/movies/_bulk?pretty" --data-binary @myMovies.json // data bulk insert

```

- 몇가지 추가된 mapping 정보를 볼 수 있습니다.
  - keyword : analyze하지 않습니다. 즉 정확히 검색하도록 합니다.
  - text : analyze 합니다. Partial search가 가능합니다.

`genre`의 type이 `keyword`이므로 match로 검색해도 정확히 검색하지 않으면 결과가 나오지 않습니다.

```json
// 결과 안나옴
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_search?pretty" -d'
{
 "query" : {
  "match" : {
   "genre" : "sci"
  }
 }
}'

// 결과 나옴
curl -H "Content-type: application/json" "127.0.0.1:9200/movies/_search?pretty" -d'
{
 "query" : {
  "match" : {
   "genre" : "Sci-Fi"
  }
 }
}'
```

## 8. Data Modeling : Relations

Elasticsearch에서 Relation 관계를 설계하기 위해서 다음과 같음 방법이 사용됩니다.

1. Inner Object : 단순히 Parent Object에 Child Object를 넣는 것입니다. 제일 단순하며 특별한 쿼리가 필요 없지만 1 : 1관계일 경우에만 적용이 가능하다는 단점이 존재합니다.

   ```json
   {
     "name" : "Korea" , 
     "continent" : "Asia" , 
     "KoreaCultureInfo" : { // child Object
       "id" : "3",
       "cultural sphere" : "East Asian Cultural Sphere"
     }
   }
   ```

2. Nested :[Nested Type](https://www.elastic.co/guide/en/elasticsearch/reference/current/nested.html) 으로 Mapping level에서 선언해서 사용할 수 있습니다. inner object를 다른 document로 분리하지 않는 Inner Object와 다르게 독립적인 document입니다. 따라서 중첩된 데이터에 쿼리를 잘 사용할 수 있습니다. 다만 Nested Document는 [Nested Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html) 만을 사용해서 접근할 수 있습니다. 또한 nested document간 상호 참조가 불가능 합니다. 따라서 다른 document의 다른 nested document를 참조할 수 없습니다.

   ```json
   {
     "name" : "ted"
     ,"car" : [
       {
         "maker" : "Hyundai"
         ,"name" : "Genesis"
       },
       {
         "maker" : "KIA"
         ,"name" : "K9"
       },
     ]
   }
   ```

3. Parent/child : Mapping Level에서 join 타입을 선언해서 사용할 수 있습니다. [Parent/child](https://www.elastic.co/guide/en/elasticsearch/reference/7.16/parent-join.html) 는 Nested 방식이 Storage를 많이 차지한다든 단점에서 벗어났습니다. Parent/Child로 선언할 시 Parent와 Child는 두 문서를 분리하고 느슨하게 결합하기 때문입니다. 따라서 이 방식은 자주 업데이트가 되는 Index에 유용한 방식입니다. 다만 Nested보다 떨어지는 성능을 단점으로 가지고 있습니다. 또한 Sort나 집계 부분을 Parent/Child에서 사용하기가 어렵습니다.

4. Denormalization

5. Log stash를 이용

### 8-1. Parent / Child

Mapping Level에서 join data field type을 선언할 시 Parent / Child 관계를 사용할 수 있습니다.

Parent / Child는 같은 인덱스에 인덱싱 되어야 합니다. 따라서 Parent / Child 관계를 다룰 때에는 router 파라메터는 필수 입니다. `PUT my-index-000001/_doc/3?routing=1&refresh` , `{ "index" : { "_index" : "country" , "_id" : "ABW" , "routing" : 1 }}` 

조인 필드는 관계 데이터베이스의 조인처럼 사용하면 안 됩니다. Elasticsearch에서 좋은 성능의 핵심은 데이터를 문서로 비정규화하는 것입니다. 각 조인 필드 `has_child`또는 `has_parent`쿼리는 쿼리 성능에 상당한 비용을 추가합니다. 또한 [전역 서수가](https://www.elastic.co/guide/en/elasticsearch/reference/7.16/eager-global-ordinals.html) 구축되도록 트리거할 수 있습니다 .

<u>조인 필드가 의미가 있는 유일한 경우는 데이터에 한 엔터티가 다른 엔터티보다 훨씬 많은 일대다 관계가 포함된 경우입니다</u>. 이러한 사례의 예로는 이러한 제품에 대한 제품 및 제안의 사용 사례가 있습니다. 오퍼가 제품 수보다 훨씬 더 많은 경우 제품을 상위 문서로 모델링하고 오퍼를 하위 문서로 모델링하는 것이 합리적입니다.

Join Type은 아래와 같이 선언할 수 있습니다.

```
{
 "mappings" : {
  "properties" : {
   // Parent / Child relation 선언 
   "parentCountry" : { // field의 이름
    "type" : "join", // field type을 join으로 선언
    
    // relations : { "Parent" : "child" }
    "relations" : { "parentCountry" : "childCity" }
   }
  }
}}'
```

아래는 실제 Mapping 쿼리입니다.

```json
curl -H "Content-type: application/json" -XPUT "127.0.0.1:9200/country" -d '
{
 "mappings" : {
  "properties" : {
   "countryCode" : { "type" : "keyword" },
   "population"  : { "type" : "integer" },
   "gnp"         : { "type" : "integer" },
   // Parent / Child relation 선언 
   "parentCountry" : {
    "type" : "join",
    "relations" : { "parentCountry" : "childCity" } // 부모 : parentCountry , 자식 : childCity 
   }
  }
}}'
```

데이터를 Insert할 시 Parent와 Child로 선택해서 Insert 합니다. 첫번째는 Parent Insert, 두 번째는 Child Insert입니다. Parent와 Child 데이터는 같은 shard에 있어야 하므로 routing은 필수 옵션입니다.

```json
{ "index" : { "_index" : "country" , "_id" : "ABW" , "routing" : 1 }} // 부모
{ "index" : { "_index" : "worldcity" , "_id" : "1" , "routing" : 1 }} // 자식
```



```json
{ "index" : { "_index" : "country" , "_id" : "ABW" , "routing" : 1 }}
{"code":"ABW","name":"Aruba","continent":"North America","region":"Caribbean","surfaceArea":null,"indepYear":0,"population":103000,"lifeExpectancy":78.4,"gnp":828,"gnpOld":793,"localName":"Aruba","governmentForm":"Nonmetropolitan Territory of The Netherlands","headOfState":"Beatrix","code2":"AW","capital":"129","parentCountry":{"name":"parentCountry"}} // parentCountry가 parent이므로 부모
{ "index" : { "_index" : "country" , "_id" : "AFG" , "routing" : 1 }}
{"code":"AFG","name":"Afghanistan","continent":"Asia","region":"Southern and Central Asia","surfaceArea":null,"indepYear":1919,"population":22720000,"lifeExpectancy":45.9,"gnp":5976,"gnpOld":null,"localName":"Afganistan/Afqanestan","governmentForm":"Islamic Emirate","headOfState":"Mohammad Omar","code2":"AF","capital":"1","parentCountry":{"name":"parentCountry"}}

// 부모에서 
"parentCountry":{"name":"parentCountry"}} // 이 document는 parentCountry 조인에 속함
```

```json
{ "index" : { "_index" : "worldcity" , "_id" : "1" , "routing" : 1 }}
{"id":1,"name":"Kabul","countryCode":"AFG","district":"Kabol","population":"1780000","parentCountry":{"name":"childCity","parent":"AFG"}} // parentCountry가 child이므로 자식
{ "index" : { "_index" : "worldcity" , "_id" : "2" , "routing" : 1 }}
{"id":2,"name":"Qandahar","countryCode":"AFG","district":"Qandahar","population":"237500","parentCountry":{"name":"childCity","parent":"AFG"}}

// 자식에서 ... parent property에서 상위 부모 ID를 지정한다. Mapping에서 childCity로 자식으로 선언했으므로 childCity로 name을 선언한다.
"parentCountry":{"name":"childCity","parent":"AFG"} // 이 document는 childCity 조인에 속함 parent는 부모의 ID를 가르킴
```

다음은 Parent / Child에서 날린 `parent_id`쿼리 입니다.

```json
 curl -H "Content-type: application/json" -XGET "127.0.0.1:9200/country/_search?pretty" -d '
{
 "query" : {
  "parent_id" : {
   "type" : "childCity",	// join field에 mapping된 child relation
   "id" : "KOR" // parent document id 
   }
  }
}'

```

Parent / Child relation에서 제한 사항이 있습니다.

1. 인덱스 당 하나의 `join` field Mapping이 허용됩니다.
2. Parent Document와 Child Document는 같은 Index에서 인덱싱되어야 합니다. 따라서 `routing` 값을 필수로 지정해야 getting , deleting , updating이 가능합니다.
3. 자식은 여러개가 가능하지만 부모는 오직 하나로 제한됩니다. 

Parent / Child를 사용하기 위해 선언했던 Join Field는 이름을 가집니다 : `{Join Field Name}#{부모이름}`

## 9. Flattened Field DataType

Elasticsearch에서 `Mapping`을 통해서 document가 어떻게 정의되고 document 내부에서 사용되는 field 정보를 저장하며 어떻게 저장되는지 , index 되는지 정의할 수 있습니다. 각 Document는 field의 모음이며 field는 data type을 가질 수 있습니다.  mapping 설정은 [Dynamic mapping](https://www.elastic.co/guide/en/elasticsearch/reference/master/dynamic-field-mapping.html) 과 [Explicit mapping](https://www.elastic.co/guide/en/elasticsearch/reference/master/explicit-mapping.html)이 있습니다.

**Dynamic Mapping으로 매핑된 Inner Object의 field는 별도로 Mapping되고 Index됩니다.**

```json
// 아래 데이터를 index 생성과 동시에 insert 한다면...
curl -H "Content-type: application/json" -XPUT "127.0.0.1:9200/demo-flattened/_doc/1" -d '
{
 "message" : "[5592:1:0309/123054.737712:ERROR:child_process_sandbox_support_impl_linux.cc(79)] FontService unique font name matching requset did not receive a response",
 "fileset" : {
  "name" : "syslog"
 },
 "process" : {
  "name" : "org.gnome.Shell.desktop",
  "pid"  : 3383
 },
 "@timestamp" : "2020-03-09T18:00:54.000_05:30",
 "host" : {
  "hostname" : "bionic",
  "name"  : "bionic"
 }
}'
```

```json
// host와 같은 Inner Object는 별도로 Mapping & Index 됩니다.
{
  "demo-default" : {
    "mappings" : {
      "properties" : {    
        "host" : { // Inner Object인 Host의 하위 field는 별도로 Mapping
          "properties" : {
            "hostname" : {
              "type" : "text",
              "fields" : {
                "keyword" : {
                  "type" : "keyword",
                  "ignore_above" : 256
                }
              }
            },
            "name" : {
              "type" : "text",
              "fields" : {
                "keyword" : {
                  "type" : "keyword",
                  "ignore_above" : 256
                }
              }
            }
          }
        },
        "message" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
        /// ... 생략
      }
    }
  }
}
```

이때 `flattened` Data Type을 사용하면 Inner Field를 단일 Field로 Mapping할 수 있습니다. 객체가 주어지면 `flattened` 매핑은 leaf value 을 구문 분석하고 키워드로 하나의 필드에 인덱싱합니다. 그러면 간단한 쿼리와 집계를 통해 개체의 내용을 검색할 수 있습니다. 

Flattern의 경우 Mapping Explosion을 방지하기 위해 사용될 수 있습니다. Dynamic Mapping에 제한 설정을 하지 않을 경우 모든 Field에 Mapping이 성능 문제가 복구 문제가 발생할 수 있습니다.

```json
// Mapping 설정
curl -H "Content-type: application/json" -XPUT "127.0.0.1:9200/demo-flattened/_mapping" -d '
{
 "properties" : {
  "host" : { "type"
   : "flattened" }}}'
// Mapping 정보
{
  "demo-flattened" : {
    "mappings" : {
      "properties" : {
        "host" : {
          "type" : "flattened"
        },
        "message" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
    }
  }
}
```

다만 Flattern로 선언할 경우 Inner Object의 Field는 Mapping이 되지 않으므로 analzing되지 않습니다. 따라서 Exact Search만 할 수 있습니다.

```json
// Inner Object의 Field는 .으로 접근할 수 있음
// flattened된 경우 : 결과 X
curl -H "Content-type: application/json" -XGET "http://localhost:9200/demo-flattened/_search?pretty" -d '
{
 "query" : {
  "match" : {
   "host.osVersion" : "Beaver"
  }
 }
}'

// Inner Object의 Field는 .으로 접근할 수 있음
// flattened되고 정확한 검색을 할 경우 : 결과 O
curl -H "Content-type: application/json" -XGET "http://localhost:9200/demo-flattened/_search?pretty" -d '
{
 "query" : {
  "match" : {
   "host.osVersion" : "Bionic Beaver"
  }
 }
}'

// Dynamic Mapping으로 생성될 경우(=== 기본 생성) Partial Search가 가능하다 : 결과 O
curl -H "Content-type: application/json" -XGET "http://localhost:9200/demo-default/_search?pretty" -d '
{
 "query" : {
  "match" : {
   "host.osVersion" : "Beaver"
  }
 }
}'
```



## 99. 참고 자료

[Index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)

[Get API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)

[Update API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)

[Delete API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete-by-query.html)

[Analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/current/analyzer.html)

[Parent / Child](https://www.elastic.co/guide/en/elasticsearch/reference/7.16/parent-join.html)

[Parent ID Query](https://www.elastic.co/guide/en/elasticsearch/reference/7.16/query-dsl-parent-id-query.html)
