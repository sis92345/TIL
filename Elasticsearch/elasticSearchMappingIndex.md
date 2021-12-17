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
  
    

## 3. INSERT_BULKhttps://www.elastic.co/kr/blog/moving-from-types-to-typeless-apis-in-elasticsearch-7-0

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

- _bulk에 넣었던 data set의 일부

  ```json
  { "index" : { "_index" : "worldcity" , "_id" : "1" }}
  {"id":1,"name":"Kabul","countryCode":"AFG","district":"Kabol","population":"1780000"}
  { "index" : { "_index" : "worldcity" , "_id" : "2" }}
  {"id":2,"name":"Qandahar","countryCode":"AFG","district":"Qandahar","population":"237500"}
  { "index" : { "_index" : "worldcity" , "_id" : "3" }}
  {"id":3,"name":"Herat","countryCode":"AFG","district":"Herat","population":"186800"}
  { "index" : { "_index" : "worldcity" , "_id" : "4" }}
  {"id":4,"name":"Mazar-e-Sharif","countryCode":"AFG","district":"Balkh","population":"127800"}
  { "index" : { "_index" : "worldcity" , "_id" : "5" }}
  {"id":5,"name":"Amsterdam","countryCode":"NLD","district":"Noord-Holland","population":"731200"}
  { "index" : { "_index" : "worldcity" , "_id" : "6" }}
  {"id":6,"name":"Rotterdam","countryCode":"NLD","district":"Zuid-Holland","population":"593321"}
  { "index" : { "_index" : "worldcity" , "_id" : "7" }}
  {"id":7,"name":"Haag","countryCode":"NLD","district":"Zuid-Holland","population":"440900"}
  { "index" : { "_index" : "worldcity" , "_id" : "8" }}
  {"id":8,"name":"Utrecht","countryCode":"NLD","district":"Utrecht","population":"234323"}
  { "index" : { "_index" : "worldcity" , "_id" : "9" }}
  {"id":9,"name":"Eindhoven","countryCode":"NLD","district":"Noord-Brabant","population":"201843"}
  { "index" : { "_index" : "worldcity" , "_id" : "10" }}
  {"id":10,"name":"Tilburg","countryCode":"NLD","district":"Noord-Brabant","population":"193238"}
  { "index" : { "_index" : "worldcity" , "_id" : "11" }}
  {"id":11,"name":"Groningen","countryCode":"NLD","district":"Groningen","population":"172701"}
  { "index" : { "_index" : "worldcity" , "_id" : "12" }}
  {"id":12,"name":"Breda","countryCode":"NLD","district":"Noord-Brabant","population":"160398"}
  { "index" : { "_index" : "worldcity" , "_id" : "13" }}
  {"id":13,"name":"Apeldoorn","countryCode":"NLD","district":"Gelderland","population":"153491"}
  { "index" : { "_index" : "worldcity" , "_id" : "14" }}
  {"id":14,"name":"Nijmegen","countryCode":"NLD","district":"Gelderland","population":"152463"}
  { "index" : { "_index" : "worldcity" , "_id" : "15" }}
  {"id":15,"name":"Enschede","countryCode":"NLD","district":"Overijssel","population":"149544"}
  { "index" : { "_index" : "worldcity" , "_id" : "16" }}
  {"id":16,"name":"Haarlem","countryCode":"NLD","district":"Noord-Holland","population":"148772"}
  { "index" : { "_index" : "worldcity" , "_id" : "17" }}
  {"id":17,"name":"Almere","countryCode":"NLD","district":"Flevoland","population":"142465"}
  { "index" : { "_index" : "worldcity" , "_id" : "18" }}
  {"id":18,"name":"Arnhem","countryCode":"NLD","district":"Gelderland","population":"138020"}
  { "index" : { "_index" : "worldcity" , "_id" : "19" }}
  {"id":19,"name":"Zaanstad","countryCode":"NLD","district":"Noord-Holland","population":"135621"}
  { "index" : { "_index" : "worldcity" , "_id" : "20" }}
  {"id":20,"name":"´s-Hertogenbosch","countryCode":"NLD","district":"Noord-Brabant","population":"129170"}
  { "index" : { "_index" : "worldcity" , "_id" : "21" }}
  {"id":21,"name":"Amersfoort","countryCode":"NLD","district":"Utrecht","population":"126270"}
  { "index" : { "_index" : "worldcity" , "_id" : "22" }}
  {"id":22,"name":"Maastricht","countryCode":"NLD","district":"Limburg","population":"122087"}
  { "index" : { "_index" : "worldcity" , "_id" : "23" }}
  {"id":23,"name":"Dordrecht","countryCode":"NLD","district":"Zuid-Holland","population":"119811"}
  { "index" : { "_index" : "worldcity" , "_id" : "24" }}
  {"id":24,"name":"Leiden","countryCode":"NLD","district":"Zuid-Holland","population":"117196"}
  { "index" : { "_index" : "worldcity" , "_id" : "25" }}
  {"id":25,"name":"Haarlemmermeer","countryCode":"NLD","district":"Noord-Holland","population":"110722"}
  { "index" : { "_index" : "worldcity" , "_id" : "26" }}
  {"id":26,"name":"Zoetermeer","countryCode":"NLD","district":"Zuid-Holland","population":"110214"}
  { "index" : { "_index" : "worldcity" , "_id" : "27" }}
  {"id":27,"name":"Emmen","countryCode":"NLD","district":"Drenthe","population":"105853"}
  { "index" : { "_index" : "worldcity" , "_id" : "28" }}
  {"id":28,"name":"Zwolle","countryCode":"NLD","district":"Overijssel","population":"105819"}
  { "index" : { "_index" : "worldcity" , "_id" : "29" }}
  {"id":29,"name":"Ede","countryCode":"NLD","district":"Gelderland","population":"101574"}
  { "index" : { "_index" : "worldcity" , "_id" : "30" }}
  {"id":30,"name":"Delft","countryCode":"NLD","district":"Zuid-Holland","population":"95268"}
  { "index" : { "_index" : "worldcity" , "_id" : "31" }}
  {"id":31,"name":"Heerlen","countryCode":"NLD","district":"Limburg","population":"95052"}
  { "index" : { "_index" : "worldcity" , "_id" : "32" }}
  {"id":32,"name":"Alkmaar","countryCode":"NLD","district":"Noord-Holland","population":"92713"}
  { "index" : { "_index" : "worldcity" , "_id" : "33" }}
  {"id":33,"name":"Willemstad","countryCode":"ANT","district":"Curaçao","population":"2345"}
  { "index" : { "_index" : "worldcity" , "_id" : "34" }}
  {"id":34,"name":"Tirana","countryCode":"ALB","district":"Tirana","population":"270000"}
  { "index" : { "_index" : "worldcity" , "_id" : "35" }}
  {"id":35,"name":"Alger","countryCode":"DZA","district":"Alger","population":"2168000"}
  { "index" : { "_index" : "worldcity" , "_id" : "36" }}
  {"id":36,"name":"Oran","countryCode":"DZA","district":"Oran","population":"609823"}
  { "index" : { "_index" : "worldcity" , "_id" : "37" }}
  {"id":37,"name":"Constantine","countryCode":"DZA","district":"Constantine","population":"443727"}
  { "index" : { "_index" : "worldcity" , "_id" : "38" }}
  {"id":38,"name":"Annaba","countryCode":"DZA","district":"Annaba","population":"222518"}
  { "index" : { "_index" : "worldcity" , "_id" : "39" }}
  {"id":39,"name":"Batna","countryCode":"DZA","district":"Batna","population":"183377"}
  { "index" : { "_index" : "worldcity" , "_id" : "40" }}
  {"id":40,"name":"Sétif","countryCode":"DZA","district":"Sétif","population":"179055"}
  { "index" : { "_index" : "worldcity" , "_id" : "41" }}
  {"id":41,"name":"Sidi Bel Abbès","countryCode":"DZA","district":"Sidi Bel Abbès","population":"153106"}
  { "index" : { "_index" : "worldcity" , "_id" : "42" }}
  {"id":42,"name":"Skikda","countryCode":"DZA","district":"Skikda","population":"128747"}
  { "index" : { "_index" : "worldcity" , "_id" : "43" }}
  {"id":43,"name":"Biskra","countryCode":"DZA","district":"Biskra","population":"128281"}
  { "index" : { "_index" : "worldcity" , "_id" : "44" }}
  {"id":44,"name":"Blida (el-Boulaida)","countryCode":"DZA","district":"Blida","population":"127284"}
  { "index" : { "_index" : "worldcity" , "_id" : "45" }}
  {"id":45,"name":"Béjaïa","countryCode":"DZA","district":"Béjaïa","population":"117162"}
  { "index" : { "_index" : "worldcity" , "_id" : "46" }}
  {"id":46,"name":"Mostaganem","countryCode":"DZA","district":"Mostaganem","population":"115212"}
  { "index" : { "_index" : "worldcity" , "_id" : "47" }}
  {"id":47,"name":"Tébessa","countryCode":"DZA","district":"Tébessa","population":"112007"}
  { "index" : { "_index" : "worldcity" , "_id" : "48" }}
  {"id":48,"name":"Tlemcen (Tilimsen)","countryCode":"DZA","district":"Tlemcen","population":"110242"}
  { "index" : { "_index" : "worldcity" , "_id" : "49" }}
  {"id":49,"name":"Béchar","countryCode":"DZA","district":"Béchar","population":"107311"}
  { "index" : { "_index" : "worldcity" , "_id" : "50" }}
  {"id":50,"name":"Tiaret","countryCode":"DZA","district":"Tiaret","population":"100118"}
  { "index" : { "_index" : "worldcity" , "_id" : "51" }}
  {"id":51,"name":"Ech-Chleff (el-Asnam)","countryCode":"DZA","district":"Chlef","population":"96794"}
  { "index" : { "_index" : "worldcity" , "_id" : "52" }}
  {"id":52,"name":"Ghardaïa","countryCode":"DZA","district":"Ghardaïa","population":"89415"}
  { "index" : { "_index" : "worldcity" , "_id" : "53" }}
  {"id":53,"name":"Tafuna","countryCode":"ASM","district":"Tutuila","population":"5200"}
  { "index" : { "_index" : "worldcity" , "_id" : "54" }}
  {"id":54,"name":"Fagatogo","countryCode":"ASM","district":"Tutuila","population":"2323"}
  { "index" : { "_index" : "worldcity" , "_id" : "55" }}
  {"id":55,"name":"Andorra la Vella","countryCode":"AND","district":"Andorra la Vella","population":"21189"}
  { "index" : { "_index" : "worldcity" , "_id" : "56" }}
  {"id":56,"name":"Luanda","countryCode":"AGO","district":"Luanda","population":"2022000"}
  { "index" : { "_index" : "worldcity" , "_id" : "57" }}
  {"id":57,"name":"Huambo","countryCode":"AGO","district":"Huambo","population":"163100"}
  { "index" : { "_index" : "worldcity" , "_id" : "58" }}
  {"id":58,"name":"Lobito","countryCode":"AGO","district":"Benguela","population":"130000"}
  { "index" : { "_index" : "worldcity" , "_id" : "59" }}
  {"id":59,"name":"Benguela","countryCode":"AGO","district":"Benguela","population":"128300"}
  { "index" : { "_index" : "worldcity" , "_id" : "60" }}
  {"id":60,"name":"Namibe","countryCode":"AGO","district":"Namibe","population":"118200"}
  { "index" : { "_index" : "worldcity" , "_id" : "61" }}
  {"id":61,"name":"South Hill","countryCode":"AIA","district":"–","population":"961"}
  { "index" : { "_index" : "worldcity" , "_id" : "62" }}
  {"id":62,"name":"The Valley","countryCode":"AIA","district":"–","population":"595"}
  { "index" : { "_index" : "worldcity" , "_id" : "63" }}
  {"id":63,"name":"Saint John´s","countryCode":"ATG","district":"St John","population":"24000"}
  { "index" : { "_index" : "worldcity" , "_id" : "64" }}
  {"id":64,"name":"Dubai","countryCode":"ARE","district":"Dubai","population":"669181"}
  { "index" : { "_index" : "worldcity" , "_id" : "65" }}
  {"id":65,"name":"Abu Dhabi","countryCode":"ARE","district":"Abu Dhabi","population":"398695"}
  { "index" : { "_index" : "worldcity" , "_id" : "66" }}
  {"id":66,"name":"Sharja","countryCode":"ARE","district":"Sharja","population":"320095"}
  { "index" : { "_index" : "worldcity" , "_id" : "67" }}
  {"id":67,"name":"al-Ayn","countryCode":"ARE","district":"Abu Dhabi","population":"225970"}
  { "index" : { "_index" : "worldcity" , "_id" : "68" }}
  {"id":68,"name":"Ajman","countryCode":"ARE","district":"Ajman","population":"114395"}
  { "index" : { "_index" : "worldcity" , "_id" : "69" }}
  {"id":69,"name":"Buenos Aires","countryCode":"ARG","district":"Distrito Federal","population":"2982146"}
  { "index" : { "_index" : "worldcity" , "_id" : "70" }}
  {"id":70,"name":"La Matanza","countryCode":"ARG","district":"Buenos Aires","population":"1266461"}
  { "index" : { "_index" : "worldcity" , "_id" : "71" }}
  {"id":71,"name":"Córdoba","countryCode":"ARG","district":"Córdoba","population":"1157507"}
  { "index" : { "_index" : "worldcity" , "_id" : "72" }}
  {"id":72,"name":"Rosario","countryCode":"ARG","district":"Santa Fé","population":"907718"}
  { "index" : { "_index" : "worldcity" , "_id" : "73" }}
  {"id":73,"name":"Lomas de Zamora","countryCode":"ARG","district":"Buenos Aires","population":"622013"}
  { "index" : { "_index" : "worldcity" , "_id" : "74" }}
  {"id":74,"name":"Quilmes","countryCode":"ARG","district":"Buenos Aires","population":"559249"}
  { "index" : { "_index" : "worldcity" , "_id" : "75" }}
  {"id":75,"name":"Almirante Brown","countryCode":"ARG","district":"Buenos Aires","population":"538918"}
  { "index" : { "_index" : "worldcity" , "_id" : "76" }}
  {"id":76,"name":"La Plata","countryCode":"ARG","district":"Buenos Aires","population":"521936"}
  { "index" : { "_index" : "worldcity" , "_id" : "77" }}
  {"id":77,"name":"Mar del Plata","countryCode":"ARG","district":"Buenos Aires","population":"512880"}
  { "index" : { "_index" : "worldcity" , "_id" : "78" }}
  {"id":78,"name":"San Miguel de Tucumán","countryCode":"ARG","district":"Tucumán","population":"470809"}
  { "index" : { "_index" : "worldcity" , "_id" : "79" }}
  {"id":79,"name":"Lanús","countryCode":"ARG","district":"Buenos Aires","population":"469735"}
  { "index" : { "_index" : "worldcity" , "_id" : "80" }}
  {"id":80,"name":"Merlo","countryCode":"ARG","district":"Buenos Aires","population":"463846"}
  { "index" : { "_index" : "worldcity" , "_id" : "81" }}
  {"id":81,"name":"General San Martín","countryCode":"ARG","district":"Buenos Aires","population":"422542"}
  { "index" : { "_index" : "worldcity" , "_id" : "82" }}
  {"id":82,"name":"Salta","countryCode":"ARG","district":"Salta","population":"367550"}
  { "index" : { "_index" : "worldcity" , "_id" : "83" }}
  {"id":83,"name":"Moreno","countryCode":"ARG","district":"Buenos Aires","population":"356993"}
  { "index" : { "_index" : "worldcity" , "_id" : "84" }}
  {"id":84,"name":"Santa Fé","countryCode":"ARG","district":"Santa Fé","population":"353063"}
  { "index" : { "_index" : "worldcity" , "_id" : "85" }}
  {"id":85,"name":"Avellaneda","countryCode":"ARG","district":"Buenos Aires","population":"353046"}
  { "index" : { "_index" : "worldcity" , "_id" : "86" }}
  {"id":86,"name":"Tres de Febrero","countryCode":"ARG","district":"Buenos Aires","population":"352311"}
  { "index" : { "_index" : "worldcity" , "_id" : "87" }}
  {"id":87,"name":"Morón","countryCode":"ARG","district":"Buenos Aires","population":"349246"}
  { "index" : { "_index" : "worldcity" , "_id" : "88" }}
  {"id":88,"name":"Florencio Varela","countryCode":"ARG","district":"Buenos Aires","population":"315432"}
  { "index" : { "_index" : "worldcity" , "_id" : "89" }}
  {"id":89,"name":"San Isidro","countryCode":"ARG","district":"Buenos Aires","population":"306341"}
  { "index" : { "_index" : "worldcity" , "_id" : "90" }}
  {"id":90,"name":"Tigre","countryCode":"ARG","district":"Buenos Aires","population":"296226"}
  { "index" : { "_index" : "worldcity" , "_id" : "91" }}
  {"id":91,"name":"Malvinas Argentinas","countryCode":"ARG","district":"Buenos Aires","population":"290335"}
  { "index" : { "_index" : "worldcity" , "_id" : "92" }}
  {"id":92,"name":"Vicente López","countryCode":"ARG","district":"Buenos Aires","population":"288341"}
  { "index" : { "_index" : "worldcity" , "_id" : "93" }}
  {"id":93,"name":"Berazategui","countryCode":"ARG","district":"Buenos Aires","population":"276916"}
  { "index" : { "_index" : "worldcity" , "_id" : "94" }}
  {"id":94,"name":"Corrientes","countryCode":"ARG","district":"Corrientes","population":"258103"}
  { "index" : { "_index" : "worldcity" , "_id" : "95" }}
  {"id":95,"name":"San Miguel","countryCode":"ARG","district":"Buenos Aires","population":"248700"}
  { "index" : { "_index" : "worldcity" , "_id" : "96" }}
  {"id":96,"name":"Bahía Blanca","countryCode":"ARG","district":"Buenos Aires","population":"239810"}
  { "index" : { "_index" : "worldcity" , "_id" : "97" }}
  {"id":97,"name":"Esteban Echeverría","countryCode":"ARG","district":"Buenos Aires","population":"235760"}
  { "index" : { "_index" : "worldcity" , "_id" : "98" }}
  {"id":98,"name":"Resistencia","countryCode":"ARG","district":"Chaco","population":"229212"}
  { "index" : { "_index" : "worldcity" , "_id" : "99" }}
  {"id":99,"name":"José C. Paz","countryCode":"ARG","district":"Buenos Aires","population":"221754"}
  { "index" : { "_index" : "worldcity" , "_id" : "100" }}
  {"id":100,"name":"Paraná","countryCode":"ARG","district":"Entre Rios","population":"207041"}
  { "index" : { "_index" : "worldcity" , "_id" : "101" }}
  {"id":101,"name":"Godoy Cruz","countryCode":"ARG","district":"Mendoza","population":"206998"}
  { "index" : { "_index" : "worldcity" , "_id" : "102" }}
  {"id":102,"name":"Posadas","countryCode":"ARG","district":"Misiones","population":"201273"}
  { "index" : { "_index" : "worldcity" , "_id" : "103" }}
  {"id":103,"name":"Guaymallén","countryCode":"ARG","district":"Mendoza","population":"200595"}
  { "index" : { "_index" : "worldcity" , "_id" : "104" }}
  {"id":104,"name":"Santiago del Estero","countryCode":"ARG","district":"Santiago del Estero","population":"189947"}
  { "index" : { "_index" : "worldcity" , "_id" : "105" }}
  {"id":105,"name":"San Salvador de Jujuy","countryCode":"ARG","district":"Jujuy","population":"178748"}
  { "index" : { "_index" : "worldcity" , "_id" : "106" }}
  {"id":106,"name":"Hurlingham","countryCode":"ARG","district":"Buenos Aires","population":"170028"}
  { "index" : { "_index" : "worldcity" , "_id" : "107" }}
  {"id":107,"name":"Neuquén","countryCode":"ARG","district":"Neuquén","population":"167296"}
  { "index" : { "_index" : "worldcity" , "_id" : "108" }}
  {"id":108,"name":"Ituzaingó","countryCode":"ARG","district":"Buenos Aires","population":"158197"}
  { "index" : { "_index" : "worldcity" , "_id" : "109" }}
  {"id":109,"name":"San Fernando","countryCode":"ARG","district":"Buenos Aires","population":"153036"}
  { "index" : { "_index" : "worldcity" , "_id" : "110" }}
  {"id":110,"name":"Formosa","countryCode":"ARG","district":"Formosa","population":"147636"}
  { "index" : { "_index" : "worldcity" , "_id" : "111" }}
  {"id":111,"name":"Las Heras","countryCode":"ARG","district":"Mendoza","population":"145823"}
  { "index" : { "_index" : "worldcity" , "_id" : "112" }}
  {"id":112,"name":"La Rioja","countryCode":"ARG","district":"La Rioja","population":"138117"}
  { "index" : { "_index" : "worldcity" , "_id" : "113" }}
  {"id":113,"name":"San Fernando del Valle de Cata","countryCode":"ARG","district":"Catamarca","population":"134935"}
  { "index" : { "_index" : "worldcity" , "_id" : "114" }}
  {"id":114,"name":"Río Cuarto","countryCode":"ARG","district":"Córdoba","population":"134355"}
  { "index" : { "_index" : "worldcity" , "_id" : "115" }}
  {"id":115,"name":"Comodoro Rivadavia","countryCode":"ARG","district":"Chubut","population":"124104"}
  { "index" : { "_index" : "worldcity" , "_id" : "116" }}
  {"id":116,"name":"Mendoza","countryCode":"ARG","district":"Mendoza","population":"123027"}
  { "index" : { "_index" : "worldcity" , "_id" : "117" }}
  {"id":117,"name":"San Nicolás de los Arroyos","countryCode":"ARG","district":"Buenos Aires","population":"119302"}
  { "index" : { "_index" : "worldcity" , "_id" : "118" }}
  {"id":118,"name":"San Juan","countryCode":"ARG","district":"San Juan","population":"119152"}
  { "index" : { "_index" : "worldcity" , "_id" : "119" }}
  {"id":119,"name":"Escobar","countryCode":"ARG","district":"Buenos Aires","population":"116675"}
  { "index" : { "_index" : "worldcity" , "_id" : "120" }}
  {"id":120,"name":"Concordia","countryCode":"ARG","district":"Entre Rios","population":"116485"}
  { "index" : { "_index" : "worldcity" , "_id" : "121" }}
  {"id":121,"name":"Pilar","countryCode":"ARG","district":"Buenos Aires","population":"113428"}
  { "index" : { "_index" : "worldcity" , "_id" : "122" }}
  {"id":122,"name":"San Luis","countryCode":"ARG","district":"San Luis","population":"110136"}
  { "index" : { "_index" : "worldcity" , "_id" : "123" }}
  {"id":123,"name":"Ezeiza","countryCode":"ARG","district":"Buenos Aires","population":"99578"}
  { "index" : { "_index" : "worldcity" , "_id" : "124" }}
  {"id":124,"name":"San Rafael","countryCode":"ARG","district":"Mendoza","population":"94651"}
  { "index" : { "_index" : "worldcity" , "_id" : "125" }}
  {"id":125,"name":"Tandil","countryCode":"ARG","district":"Buenos Aires","population":"91101"}
  { "index" : { "_index" : "worldcity" , "_id" : "126" }}
  {"id":126,"name":"Yerevan","countryCode":"ARM","district":"Yerevan","population":"1248700"}
  { "index" : { "_index" : "worldcity" , "_id" : "127" }}
  {"id":127,"name":"Gjumri","countryCode":"ARM","district":"Širak","population":"211700"}
  { "index" : { "_index" : "worldcity" , "_id" : "128" }}
  {"id":128,"name":"Vanadzor","countryCode":"ARM","district":"Lori","population":"172700"}
  { "index" : { "_index" : "worldcity" , "_id" : "129" }}
  {"id":129,"name":"Oranjestad","countryCode":"ABW","district":"–","population":"29034"}
  { "index" : { "_index" : "worldcity" , "_id" : "130" }}
  {"id":130,"name":"Sydney","countryCode":"AUS","district":"New South Wales","population":"3276207"}
  { "index" : { "_index" : "worldcity" , "_id" : "131" }}
  {"id":131,"name":"Melbourne","countryCode":"AUS","district":"Victoria","population":"2865329"}
  { "index" : { "_index" : "worldcity" , "_id" : "132" }}
  {"id":132,"name":"Brisbane","countryCode":"AUS","district":"Queensland","population":"1291117"}
  { "index" : { "_index" : "worldcity" , "_id" : "133" }}
  {"id":133,"name":"Perth","countryCode":"AUS","district":"West Australia","population":"1096829"}
  { "index" : { "_index" : "worldcity" , "_id" : "134" }}
  {"id":134,"name":"Adelaide","countryCode":"AUS","district":"South Australia","population":"978100"}
  { "index" : { "_index" : "worldcity" , "_id" : "135" }}
  {"id":135,"name":"Canberra","countryCode":"AUS","district":"Capital Region","population":"322723"}
  { "index" : { "_index" : "worldcity" , "_id" : "136" }}
  {"id":136,"name":"Gold Coast","countryCode":"AUS","district":"Queensland","population":"311932"}
  { "index" : { "_index" : "worldcity" , "_id" : "137" }}
  {"id":137,"name":"Newcastle","countryCode":"AUS","district":"New South Wales","population":"270324"}
  { "index" : { "_index" : "worldcity" , "_id" : "138" }}
  {"id":138,"name":"Central Coast","countryCode":"AUS","district":"New South Wales","population":"227657"}
  { "index" : { "_index" : "worldcity" , "_id" : "139" }}
  {"id":139,"name":"Wollongong","countryCode":"AUS","district":"New South Wales","population":"219761"}
  { "index" : { "_index" : "worldcity" , "_id" : "140" }}
  {"id":140,"name":"Hobart","countryCode":"AUS","district":"Tasmania","population":"126118"}
  { "index" : { "_index" : "worldcity" , "_id" : "141" }}
  {"id":141,"name":"Geelong","countryCode":"AUS","district":"Victoria","population":"125382"}
  { "index" : { "_index" : "worldcity" , "_id" : "142" }}
  {"id":142,"name":"Townsville","countryCode":"AUS","district":"Queensland","population":"109914"}
  { "index" : { "_index" : "worldcity" , "_id" : "143" }}
  {"id":143,"name":"Cairns","countryCode":"AUS","district":"Queensland","population":"92273"}
  { "index" : { "_index" : "worldcity" , "_id" : "144" }}
  {"id":144,"name":"Baku","countryCode":"AZE","district":"Baki","population":"1787800"}
  { "index" : { "_index" : "worldcity" , "_id" : "145" }}
  {"id":145,"name":"Gäncä","countryCode":"AZE","district":"Gäncä","population":"299300"}
  { "index" : { "_index" : "worldcity" , "_id" : "146" }}
  {"id":146,"name":"Sumqayit","countryCode":"AZE","district":"Sumqayit","population":"283000"}
  { "index" : { "_index" : "worldcity" , "_id" : "147" }}
  {"id":147,"name":"Mingäçevir","countryCode":"AZE","district":"Mingäçevir","population":"93900"}
  { "index" : { "_index" : "worldcity" , "_id" : "148" }}
  {"id":148,"name":"Nassau","countryCode":"BHS","district":"New Providence","population":"172000"}
  { "index" : { "_index" : "worldcity" , "_id" : "149" }}
  {"id":149,"name":"al-Manama","countryCode":"BHR","district":"al-Manama","population":"148000"}
  { "index" : { "_index" : "worldcity" , "_id" : "150" }}
  {"id":150,"name":"Dhaka","countryCode":"BGD","district":"Dhaka","population":"3612850"}
  { "index" : { "_index" : "worldcity" , "_id" : "151" }}
  {"id":151,"name":"Chittagong","countryCode":"BGD","district":"Chittagong","population":"1392860"}
  { "index" : { "_index" : "worldcity" , "_id" : "152" }}
  {"id":152,"name":"Khulna","countryCode":"BGD","district":"Khulna","population":"663340"}
  { "index" : { "_index" : "worldcity" , "_id" : "153" }}
  {"id":153,"name":"Rajshahi","countryCode":"BGD","district":"Rajshahi","population":"294056"}
  { "index" : { "_index" : "worldcity" , "_id" : "154" }}
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

  
