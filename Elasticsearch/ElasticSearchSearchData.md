# Elasticsearch : Search Data

- [Data Set](https://grouplens.org/datasets/movielens/)

## 3. Match And Match_phrase

1. 기본 검색 , district가 kyonggi인 데이터를 반환합니다.

   ```
   {
     "query" : {
       "match" : { 
         "district" : "sci"
   		}
   	}
   }'
   ```

2. Match , match prase

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
     San Luis ARG San Luis 110136
     San Rafael ARG Mendoza 94651
     San Bernardo CHL Santiago 241910
     San José CRI San José 339131
     San Salvador SLV San Salvador 415346
     San Miguel SLV San Miguel 127696
     San Pedro PHL Southern Tagalog 231403
     San Fernando PHL Central Luzon 221857
     San Pablo PHL Southern Tagalog 207927
     San Carlos PHL Ilocos 154264
     San Mateo PHL Southern Tagalog 135603
     San Miguel PHL Central Luzon 123824
     San Buenaventura USA California 100916
     San Mateo USA California 91799
     San Fernando del Valle de Cata ARG Catamarca 134935
     General San Martín ARG Buenos Aires 422542
     Nueva San Salvador SLV La Libertad 98400
     Ciego de Ávila CUB Ciego de Ávila 98505
     Fort-de-France MTQ Fort-de-France 94050
     Ciudad de México MEX Distrito Federal 8591309
     Valle de Santiago MEX Guanajuato 130557
     Lagos de Moreno MEX Jalisco 127949
     Tlajomulco de Zúñiga MEX Jalisco 123220
     Tulancingo de Bravo MEX Hidalgo 121946
     Tepatitlán de Morelos MEX Jalisco 118948
     Almoloya de Juárez MEX México 110550
     Huejutla de Reyes MEX Hidalgo 108017
     Comitán de Domínguez MEX Chiapas 104986
     Chilapa de Alvarez MEX Guerrero 102716
     Taxco de Alarcón MEX Guerrero 99907
     Ciudad de Panamá PAN Panamá 471373
     San José del Monte PHL Central Luzon 315807
     San Juan del Monte PHL National Capital Reg 117680
     San Juan del Río MEX Querétaro 179300
     San Felipe del Progreso MEX México 177330
     San Luis Río Colorado MEX Sonora 145276
     San Juan Bautista Tuxtepec MEX Oaxaca 133675
     San Pedro Garza García MEX Nuevo León 126147
     San Francisco del Rincón MEX Guanajuato 100149
     São João de Meriti BRA Rio de Janeiro 440052
     Cabo de Santo Agostinho BRA Pernambuco 149964
     Vitória de Santo Antão BRA Pernambuco 113595
     São José de Ribamar BRA Maranhão 98318
     Águas Lindas de Goiás BRA Goiás 89200
     Santo Domingo de Guzmán DOM Distrito Nacional 1609966
     Santiago de los Caballeros DOM Santiago 365463
     L´Hospitalet de Llobregat ESP Katalonia 247986
     Santa Cruz de Tenerife ESP Canary Islands 213050
     Jerez de la Frontera ESP Andalusia 182660
     Santa Coloma de Gramenet ESP Katalonia 120802
     Victoria de las Tunas CUB Las Tunas 132350
     Valle de Chalco Solidaridad MEX México 323113
     Chilpancingo de los Bravo MEX Guerrero 192509
     Soledad de Graciano Sánchez MEX San Luis Potosí 179956
     Poza Rica de Hidalgo MEX Veracruz 152678
     Iguala de la Independencia MEX Guerrero 123883
     Martínez de la Torre MEX Veracruz 118815
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