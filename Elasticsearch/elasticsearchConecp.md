# Elasticsearch : Concept

## 1. Document와 Indices

Elasticsearch에는 2가지 중요한 개념이 있습니다. `document`와 `index` 입니다.

- Document : 우리가 검색할 대상입니다 JSON 구조로 이루어져 있으며 모든 document는 ID와 Type을 가지고 있습니다.
- Index : Type들의 집합에서 모든 document의 검색 기능을 제공합니다. 검색할 대상을 한번에 할 수 있는 역 인덱스(Inverted Indices)와 data의 스키마를 정의하는 Mapping을 포함합니다.

Index를 RDBMS의 Table이라고 한다면 Document는 Table의 Row라고 할 수 있습니다. DB는 Cluster에 비유할 수 있습니다. 즉 하나의 Document는 Type을 가지며 Index는 Type들의 집합에서 Document 검색을 시행합니다. Index에는 Inverted Indices와 Mapping같은 스키마를 포함하고 있습니다. 

## 2. Inverted Index

 `Inverted Index`는 모든 검색엔진의 핵심 개념입니다. 당연히 검색엔진 오픈소스인 Elasticsearch에 Inverted Index의 개념이 들어가 있습니다.

일반적으로 검색속도를 향상 시키기 위해 Index를 만듭니다. 특정 데이터의 위치를 키와 값으로 저장한다면 빠르게 검색할 수 있습니다. 이는 책에서 목차가 하는 역할과 비슷합니다. 우리가 ElasticSearch 강의 책에서 Query 관련 부분을 보기 위해서 전체 책을 스캔하는 것이 아니라 목차에서 바로 Query 부분 위치를 확인한 후 빠르게 찾을 수 있는것처럼요. 다만 이 방식은 빠른 검색이 필요한 검색 엔진에서 적합한 방법은 아닙니다. 우리가 ElasticSearch라는 책에서 ElasticSearch라는 단어를 특별히 찾고 싶어서 목차를 통해 검색하는 방법은 검색해야할 대상이 늘어나기 때문입니다. 아마 책 전체를 뒤져야 할 것입니다.

```
Elastic Search
// 내가 원하는 정보를 목차에서 쉽게 찾을 수 있습니다...
// 그런데 이 목차에서 ElasticSearch 라는 키워드를 찾고 싶다면 어떡해야 할까요?
1. Elastic Search p.1~100 : what is Elasticsearch , ElasticSearch Stack ElasticSearch Conecpt	// 여기에도 ElasticSearch라는 단어가 많습니다.
2. Query	p.100 ~ 200 	: json , REST API , Data Set , Query	// 여기는 어떨까요?
3. Kibana p.300 ~ 400		: with ElasticSearch, what is kibana	// 여기에는 조금 많습니다.
4. logStash p.400 ~ 500		// 여기에는 없을 것 같지만 RDBMS는 무조건 여기도 검색할 겁니다.
5. 부록 - 찾아보기
```

인덱스는 특정 문서에서 특정 searchTerm을 검색하는 경우 훌륭하게 작동합니다. 예를 들어 Query 목차에서 json이라는 단어를 검색할 때 Index는 가장 좋은 검색 방법이 될 수 있습니다. 그런데 문제는 우리가 문서가 아닌 특정 단어를 검색할 때 문제가 발생합니다. 만약 위에서 Elasticsearch라는 단어를 찾으려면 500 페이지까지 모든 검색을 수행할 것 입니다. 이때는 Invert Index가 훌륭한 검색 방법이 될 수 있습니다.

이제 저 위 책의 맨 끝을 살펴봅시다 부록으로 들어있는, 책 맨 끝에 있는 찾아보기가 바로 Inverted Index의 예 입니다. 찾아보기는 해당 단어가 어떤 페이지에서 나와 있는지 적혀 있습니다. 즉 SearchTerm을 입력하면 기존의 Index가 책의 끝까지 SearchTerm을 반복적으로 장마다 검색했다면 , Inverted Index는 SearchTerm을 찾은 뒤 해당 SearchTerm에 적혀있는 페이지 번호만 찾아가면 됩니다. 당연히 검색 엔진에는 이 방식이 더 검색에 유리합니다.

```
ElasticSearch : p1 , p35 , p55 , p325 , p500
Match : p 101 , p140
kibana : p 32, p 355 , p 343 
```



###  3. TF-IDF

- Term Frequency * Inverted Document Frequency
  - Term Frequency : 단어가 문서에서 자주 나타나는 빈도
  - Document Frequency : 단어가 나타난 문서의 수
  - 즉 High Term Frequency 하고 High Document Frequency하다는 것은 모든 문서에서 매우 자주 나타난다는 의미입니다. 한국에서 High Term Frequency 하고 High Document Frequency한 Term는 아마도 "입니다" 일거이고 , 영어에서는 "The"일 겁니다.
  - 반면 High Term Frequency 하고 Low Document Frequency하면 한 문서에서 자주 나오지만 전체 문서에서는 자주 언급되지 않는 것을 말합니다. 즉 TF-IDE를 말합니다.
- TF-IDE는 검색의 정확도(relevancy)와 큰 관련이 있습니다.

### 4. Elasticsearch에서 Index를 이용하는 방법

1. RESTful API

   - Elasticsearch는 HTTP 요청과 JSON data를 통해서 동작합니다. 어떤 언어와 도구로 ElasticSearch를 사용할 수 있습니다.

     - 리눅스 shellscript로

       ```shell
       curl -H "Content-type: application/json" -XGET '127.0.0.1:9200/shakespeare/_search?pretty' -d'
       {
       "query" : {
       "match_phrase" : { "text_entry" : "thy name is woman"
       }
       }
       }'
       ```

     - JavaScript로

       ```javascript
       searchDistrict(){
       
             this.$axios.get( "/worldcity/_search?pretty=true&q=*:*&size=50" , { params : { source :  JSON.stringify( this.search_ex2 ) , source_content_type: 'application/json' } } ).then( res  => {
               debugger;
             } );
           }
       // data
       search_ex2 : {
               query : {
                 bool : {
                   should : [
                     { "match" : { "countryCode" : "KOR" } },
                     { "match" : { "countryCode" : "JPN" } },
                   ]
                 }
               }
             },
       ```

   2. Client APIs : 대부분의 언어가 Elasticsearch를 쉽게 사용할 수 있음
   3. Analytic Tools
      - 웹 기반인 Kibana를 통해서 Index를 쉽게 분석할 수 있음 

