# Elasticsearch : Search Data

- [Data Set](https://grouplens.org/datasets/movielens/)



## 1. Intro

## 2. Query Lite

## 3. JSON Search In-Depth

## 4. Pagination

## 5. **Sorting**

Sort는 Index 조회 결과를 정렬하기 위해서 사용됩니다. **검색 시 `sort` field가 없을 경우 `_score`  DESC로 조회됩니다.**

- Sort 사용 방법

  - Query String : `http://localhost:9200/{index}/_search?sort={sort할 field}:{order, 기본값은 asc}`
    - e.g. : http://localhost:9200/worldcity2/_search?pretty&size=2&from=2&sort=population:asc

  - Json

    ```json
    curl -H "Content-type: application/json" -XGET "127.0.0.1:9200/worldcity2/_search?pretty" -d '
    {
      // populaion을 desc로 정렬
     "sort" : [ { "population" : { "order" : "desc" } } ] 
    }'
    ```

    

- 주의점

  - 전문 검색을 위해 text로 설정된 String은 sort할 수 없습니다. 이 경우 전체 String이 저장되어 있지 않기 때문입니다(Inverted Index로 저장되어 있음)

  - 이때  Mapping에 다중 필드를 설정해서 이 문제를 해결할 수 있습니다.

    - e.g. 

      - 검색 : http://localhost:9200/worldcity2/_search?pretty&size=2&from=2&sort=name

      - 결과

        ```json
        {
          "error" : {
            "root_cause" : [
              {
                "type" : "illegal_argument_exception",
                "reason" : "Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [name] in order to load field data by uninverting the inverted index. Note that this can use significant memory."
              }
            ],
            "type" : "search_phase_execution_exception",
            "reason" : "all shards failed",
            "phase" : "query",
            "grouped" : true,
            "failed_shards" : [
              {
                "shard" : 0,
                "index" : "worldcity2",
                "node" : "Z7YTRGxSQWei4DOu10ilog",
                "reason" : {
                  "type" : "illegal_argument_exception",
                  "reason" : "Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [name] in order to load field data by uninverting the inverted index. Note that this can use significant memory."
                }
              }
            ],
            "caused_by" : {
              "type" : "illegal_argument_exception",
              "reason" : "Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [name] in order to load field data by uninverting the inverted index. Note that this can use significant memory.",
              "caused_by" : {
                "type" : "illegal_argument_exception",
                "reason" : "Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [name] in order to load field data by uninverting the inverted index. Note that this can use significant memory."
              }
            }
          },
          "status" : 400
        }
        ```

새롭게 매핑처리 하기 위해 Index를 새로 만들었다. 기존 Index의 Mapping을 바꾸는 방법은 아래를 참조하라

```json
curl -H "Content-type: application/json" -XPUT "127.0.0.1:9200/worldcity2" -d'
{
 "mappings" : {
  "properties" : {
   "countryCode" : { "type" : "keyword" },
   "name" : {
    "type" : "text",
    "fields" : {	// multi-field 설정 : 다른 목적으로 사용하기 위해 정의 , 이 경우에는 sort를 위해..
     "raw" : { "type" : "keyword" }
    }
   },
   "population" : { "type" : "integer" }
   }
  }
 }'
```

- 이제 `name.raw`가 `keyword` 이므로 name field를 sort할 수 있다.

  ```json
  http://localhost:9200/worldcity2/_search?pretty&sort=name.raw
  ```

- bool 쿼리와 조합한 예

  ```json
  curl -H "Content-type: application/json" -XGET "127.0.0.1:9200/worldcity2/_search?pretty" -d '
  {
   "sort" : [ { "population" : { "order" : "desc" } } ],
   "query" : {
    "bool" : {
     "must" : { "match" : { "countryCode" : "KOR" }},
     "must_not" : { "match" : { "district" : "Kyonggi" }},
     "filter" : { "range" : { "population" : { "gte" : 300000 , "lte" : 5000000 } } }
    }
   }
  }'
  ```

  

## 3. Match And Match_phrase

## 7. Fuzzy Query

검색한 단어와 가장 유사한 term을 가진 document를 반환합니다.

실제 검색한 검색어를 다르게 적었을 경우 가장 검색어와 유사한 document를 반환합니다.

- 단어를 잘못 적었을 경우 (**b**ox → **f**ox)
- 문자를 하나 빼먹었을 경우 (**b**lack → lack)
- 실수로 문자를 하나 더 입력했을 경우 (sic → sic**k**)
- 단어를 바꿔 적었을 경우 (**ac**t → **ca**t)

Fuzzy Query는 아래와 같이 사용합니다.

```json
curl -H "Content-type: application/json" -XGET "127.0.0.1:9200/worldcity2/_search?pretty" -d '
{
 "query" : {
  "fuzzy" : {
	 // Kyongi를 검색 시 Kyonggi가 포함된 document를 반환
   // 
   "district" : { "value" : "Kyongi" , "fuzziness" : 2 }
  }
 } 
}'
```

Funniness

> **`fuzziness`**
>
> (Optional, string) Maximum edit distance allowed for matching. See [Fuzziness](https://www.elastic.co/guide/en/elasticsearch/reference/current/common-options.html#fuzziness) for valid values and more information.
>
> 0 , 1 , 2 , AUTO로 사용 가능

단 `Fuzziness` 범위를 벗어난 검색어는 반환하지 않습니다 : *Kyonggi검색어를 Kyongggi로 검색시 Kyonggi가 나오지만 Kyongggggi로 검색시 검색 결과는 나오지 않는다.*



## 8. Match

가장 기본적인 search로 text, number, date, boolean을 사용할 수 있다. text는 검색하기전 analyze됩니다. 따라서 Partial Match를 할 수 있습니다.

- Normalize
  - dash 제거
  - 소문자화 등

fuzzy matching을 지원합니다.(정확하게 일치하지않더라도 연관성이 있다고 판단하면 리턴).

```
{
  "query" : {
    "match" : { 
      "district" : "sci"	// scifi , SCI-FI , Sci-Fi 등 의 검색어가 가능
		}
	}
}'
```



## 9. Match_phrase

Match_phrase는  검색어를 analyzes해서 결과를 가져옵니다. 단 Match와 다륵데 검색어의 term이 모두 존재하고 순서가맞는 결과만 조회할 수 있습니다.

 match prase

- Match는 검색시 검색 토큰을 분석해서 해당 검색어가 포함된 단어를 모두 가져옵니다.

  ```
  query : {
            match : {
              "name" : "san de"	// name에 san과 de가 들어간 도시를 찾는다.
            }
          }
  ```

  ```
  // 결과
  San Miguel de Tucumán ARG Tucumán 470809
  San Salvador de Jujuy ARG Jujuy 178748
  San Pedro de la Paz CHL Bíobío 91684
  San Felipe de Puerto Plata DOM Puerto Plata 89423
  [San Cristóbal de] la Laguna ESP Canary Islands 127945
  San Nicolás de los Garza MEX Nuevo León 495540
  San Cristóbal de las Casas MEX Chiapas 132317
  // ... 생략 ...
  Fernando de la Mora PRY Central 95287
  Santa Ana de Coro VEN Falcón 185766
  Valle de la Pascua VEN Guárico 95927
  Santa Cruz de la Sierra BOL Santa Cruz 935361
  Santo Domingo de los Colorados ECU Pichincha 202111
  Las Palmas de Gran Canaria ESP Canary Islands 354757
  Castellón de la Plana [Castell ESP Valencia 139712
  ```
  
  - Match_phrase를 이용하면 조금 더 정확한 쿼리를 진행할 수 있습니다. : match_phrase는 토큰으로 분석하기는 하지만 해당 토큰이 모두 존재하고 순서가 맞는 document만 반환합니다.
  
    ```
    query : {
              match_phrase : {
                name : { query : "san de" }
              }
    }
    ```
  
    - 이 세상에 san de로 시작하는 도시는 없으므로 결과는 없습니다.
  
  - Match_phrase는 slop으로 토큰 사이에 포함될 수 있는 단어의 수를 지정할 수 있습니다. 
  
    ```
    query : {
              match_phrase : {
                name : { query : "san de" , slop : 1}
              }
            }
    ```
  
    ```
    San Miguel de Tucumán ARG Tucumán 470809
    San Salvador de Jujuy ARG Jujuy 178748
    San Pedro de Macorís DOM San Pedro de Macorís 124735
    San Francisco de Macorís DOM Duarte 108485
    San Fernando de Apure VEN Apure 93809
    San Nicolás de los Arroyos ARG Buenos Aires 119302
    San Pedro de la Paz CHL Bíobío 91684
    San Felipe de Puerto Plata DOM Puerto Plata 89423
    [San Cristóbal de] la Laguna ESP Canary Islands 127945
    San Nicolás de los Garza MEX Nuevo León 495540
    San Cristóbal de las Casas MEX Chiapas 132317
    San Luis de la Paz MEX Guanajuato 96763
    ```
  
    
  
    - 예를 들어 slop 1이라고 한다면
      - San Miguel de Tucumán : san de 사이에 Miguel이라는 단어가 하나 있으므로 검색을 허용합니다.

### 4. Bool

bool 쿼리 : 여러 쿼리를 조합하기 위해서 사용합니다. bool 쿼리에서 사용할 수 있는 쿼리는 다음과 같습니다.

- must
- must_not
- Should
- Filter

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


3. 위 두 코드를 search lite를 이용해서 검색

   ```
   http://localhost:9200/worldcity2/_search?pretty&size=100&q=countryCode:KOR
   http://localhost:9200/worldcity2/_search?pretty&size=100&q=countryCode:KOR+countryCode:JPN
   ```

4. 한국에서 인구수 9000000 이상인 도시를 반환합니다.

   ```
   query : {
             bool : {
               must : [ { "match" : { "countryCode" : "KOR" } } ],
               filter : { range : { population : { "gte" : 9000000 } } }
             },
           }
   ```

## 99. Reeference

- [SORT](https://www.elastic.co/guide/en/elasticsearch/reference/current/sort-search-results.html)

- [Fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)
- [Fuzzy Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html#query-dsl-fuzzy-query)
- [Full Text Search Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/full-text-queries.html)