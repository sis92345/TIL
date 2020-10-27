Servlet
==========

> Servlet
>
> Servlet의 기본 구조

> Tomcat에 Context 업로드
>
> 

### 1. Java Servlet

---------------

- **Java Servlet이란?**

  - 웹 기반 요청에 대한 동적인 처리가 가능한 하나의 클래스
  - Servlet은 Server side에서 돌아가는 Java Program으로 백엔드 개발자가 담당해야할 부분이다.
  
- Java Servlet 메커니즘이해

  - Servlet을 이해하기 위해서는 WAS를 통한 웹 서버의 구동에 대해서 이해해야한다.

    ![https://github.com/sis92345/TIL/blob/master/img/tomcat1.jpg]()

  - 클라이언트는 Web Container가 아닌 웹 서버에 요청한다. 세부적인 메커니즘은 다음과 같다.

    ```
    1. User는 www.example.com/Day61/servlets/servlet/Hello.nhn으로 요청한다.
    2. 유저의 요청을 Apache(웹서버)가 수신할 때, 확장자 또는 URL경로상에 미리 약속한 JkMount가 발견되면 본인이 처리하기 않고 AJP13에게 forward한다.
    3. AJP13은 자기가 연결된 Tomcat에게 요청한다.
    4. 요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조하여 D:/WebHome/Day61/WEB-INF/web.xml로 넘겨준다.
    5. 해당 web.xml은 user가 요청한 url(/servlets/servlet/Hello.nhn)을 보고 <servlet-mapping>밑의 <url-pattern>과 일치되는 servlet-name을 찾는다.
    6. 일치되는 servlet-name인 HelloWorld를 찾아서 <servlet>밑의 해당 이름과 같은 servlet-class를 찾는다.
    7. 그래서 일치되는 servlet-class를 찾으면 해당 클래스를 메모리에 로딩하고 실행하여 그 결과를 Apache(웹 서버)에게 출력한다.
    8. Tomcat으로 전달받은 출력 문자열을 그대로 유저에게 response한다.
    9. 유저의 브라우저는 웹서버로 부터 받은 문자열을 DOM(Tree 구조)로 parsing하고, 그다음 유저의 메모리에 로딩하고 웹페이제 rendering한다. 
    ```

  - Servlet과 Tomcat을 통해 웹을 구동하기 위해서는 다음과 같은 파일이 필요하다

    - 위치는 집 데스크톱 기준
    - `Context`: 톰캣의 server.xml에 등록하여 구동되는 하나의 웹 어플리케이션
      - Context는 다음과 같은 구조를 반드시 지녀야 한다.
        - **Context folder**
          - WEB-INF(필수, 대소문자 구분)
            - classes: Java 클래스 파일 
            - libs
            - **web.xml**
          - 그외 src같은 필요한 파일
        - **web.xml**: 클라이언트가 URL을 요청하였을때 어떤 Servlet 파일을 실행할 것인지 매핑해놓은 파일
    - Tomcat server.xml: Context등록에 필요
      - 등록된 Context는 localhost:8080/manager/html에서 Context별로 관리할 수 있다.
      - CATALINA_HOME의 webapps(루트폴더)에서 추가하는 방법이 있으나 이는 별도의 폴더로 뺄 수 없으므로 그냥 구글링 ㄱㄱ

  - 정리

    1. 유저는 www.example.com:8080나 www.example.com로 요청한다.

       - www.example.com:8080은 Tomcat으로 요청(Web Container)

       - www.example.com은 Apache로 요청(Web Server)

         - 유저는 일일히 8080을 입력하여 웹에 요청하지 않을 것이다.

         - 또한 보안을 위해서도 유저는 웹 서버를 통해서 요청을 해야한다. 

    2. 따라서 유저는  www.example.com/Day61/servlets/servlet/Hello.nhn을 통해서 접속한다.

       1. 하지만 이를 위해서는 Apache와 Tomcat을 연동해야한다: 이게 AJP13의 역할이며, 연동은 ETC의 `4.톰캣설치`를 참고

    3. Apache가 유저의 요청을 수락했을 때, 확장자 또는 URL경로상에 미리  약속한 JkMount가 발견되면 Apache가 처리하지 않고 Tomcat이 처리하도록 ajp13에 넘긴다. 이를 Forward라고 한다.

       1. JkMount 설정의 Apache_home의 conf/hffd.conf에서 설정한다

       2. 예

          ```
          LoadModule jk_module modules/mod_jk.so
          JkWorkersFile "C:/Program Files/Apache24/conf/workers.properties" //연동할 톰캣의 목록을 적은 workers.properties의 위치
          JkLogFile "C:/Program Files/Apache Software Foundation/Tomcat 9.0/logs/mod_jk.log"
          JkMount /*.jsp ajp13 # jsp로 끝나는 파일이 있다면 이를 ajp13으로 넘긴다.
          JkMount /*servlet/* ajp13 # 경로상에 servlet이라는 단어가 있다면 이를 ajp13으로 넘긴다.
          ```

          ```
          #workers.properties 
          worker.list=ajp13 #worker(톰캣)의 이름, 임의 지정, 여러개의 톰캣을 사용할 경우 여러개를 지정해야하며 이 경우 구글링 ㄱㄱ
          worker.ajp13.type=ajp13 # Apache Http 서버와 Tomcat 서버가 통신하는 protocol은 ajp 13
          worker.ajp13.host=localhost #host 속성은 Tomcat 작업자가 ajp13 요청을 수신하는 호스트를 설정
          worker.ajp13.port=8009 #tomcat으로 보내는 apache의 포트, 즉 Apache는 80번 포트로 유저의 요청을 받고 8009포트로 ajp13으로 tomcat과 연동
          ```

    4. 요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조

       1. 설정: CATAILNA_HOME의 conf/server.xml
          - server.xml의 host 태그 밑에 다음의 코드를 추가
          - `<Context path="/Day61" docBase="D:\git_env\Webhome\Day61" />`
            - path: Context의 Context path를 나타낸다. 각 요청 URL의 시작 부분이 Context path와 같을 때 해당 Context가 그 요청을 수락한다.
              - 위는 path="/Day61"이므로 www.example.com/Day61로 유저가 입력하면 해당 Context의 docBase를 참조한다.
            - docBase: Context에 대한 Document Base를 나타낸다.
            - 이는 더 찾아보기
       2. `localhost:8080/manager/html`에서 Context가 추가되었는지 확인
       3. 요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조하여 D:/WebHome/Day61/WEB-INF/web.xml로 넘겨준다.

    5. web.xml: 해당 web.xml은 user가 요청한 url(/servlets/servlet/Hello.nhn)을 보고 `<servlet-mapping>`밑의 `<url-pattern>`과 일치되는 servlet-name을 찾는다.

       1. 예: 유저가 URL에 http://www.example.com/Day61/servlets/servlet/Calculator라고 입력했다면..

    6. 일치되는 servlet-name인 HelloWorld를 찾아서 `<servlet>`밑의 해당 이름과 같은 servlet-class를 찾는다.

    7. 그래서 일치되는 servlet-class를 찾으면 해당 클래스를 메모리에 로딩하고 실행하여 그 결과를 Apache(웹 서버)에게 출력한다.

       - 예: 유저가 URL에 http://www.example.com/Day61/servlets/servlet/Calculator라고 입력했다면..

         ```
          <servlet>
           	<servlet-name>Calculator</servlet-name> //여기 있으니까 
           	<servlet-class>CalculatorServlet</servlet-class> //해당 클레스를 메모리에 로딩하고 그 결과를 APACHE로 출력
          </servlet>
           
         <servlet-mapping>
           	<servlet-name>Calculator</servlet-name>//Calculator와 일치하는 걸 찾는다.
           	<url-pattern>/servlets/servlet/Calculator</url-pattern> //이 URL이 유저가 입력한 URL과 일치하므로
         </servlet-mapping>
         ```

       - `<url-pattern>`은 실제 경로를 숨기는 역할도 한다.

       - 이를 HTML과 연동할 수 있다.

         - 유저가 http://www.example.com/Day61/index.html로 접속
         - HTML의 form 태그의 속성 중 action은 서버로 보낼 때 해당 데이터가 도착할 URL을 명시한다.
           - 예: `<form action="/Day61/servlets/servlet/Calculator" method="POST">`
         - 이를 이벤트와 연동시켜서 구현한다.

    8. Tomcat으로 전달받은 출력 문자열을 그대로 유저에게 response한다.

    9. 유저의 브라우저는 웹서버로 부터 받은 문자열을 DOM(Tree 구조)로 parsing하고, 그다음 유저의 메모리에 로딩하고 웹페이제 rendering한다. 

    

    

### 2. JavaScript의 개발 환경

------

- 자바스크립트는 웹 브라우저에서 작동하는 프로그래밍 언어라는 점, 인터프리터 언어라는 점에서 기존의 JAVA와 다른 개발 환경이 필요하다.

- 모든 웹 브라우저는 자바스크립트를 해석하는 자바스크립트 엔진을 내장하므로 **웹 브라우저의 개발자 도구를 이용**하여 개발 할 수 있다.

- **웹 브라우저의 개발자 도구를 이용한 자바스크립트 개발**

  - **개발자 도구**: 모든 웹 브라우저는 개발자 도구가 존재한다.

    - 개발자 도구의 실행

      - Windows: `F12`또는 `Ctrl+Shift+I` 
      - MAC: `command + option + I`
      
    - 개발자 도구의 주 기능

      - Element: 

        - 로딩된 웹 페이지의 DOM과 CSS를 편집하여 랜더링된 뷰를 확인할 수 있다.
        - 단 편집된 내용이 저장되지는 않는다.
        - 웹 페이지가 의도된 대로 랜더링되지 않았다면 이 패널을 확인하여 유용한 힌트를 얻을 수 있다.

      - **Console**: 

        - 로딩된 웹 페이지의 에러를 확인하거나 자바스크립트 소스코드에 포함시킨 `console.log` 메소드의 결과를 확인

        - 이 개발자 도구의 Console를 이용하여 자바스크립트 코드상의 오류를 확인할 수 있다.

        - `console.log()`는 이 콘솔에 파라미터를 출력하는 메소드이다.

          - `console.log()`를 이용하여 진법변환을 쉽게할 수 있다.

            ```javascript
            <body>
                <script>
                    //기본: 10진법
                    var num = 128;//10진수
                    var num1 = 023;//2진수
                    //진법 변환
                    console.log('2진수 = ' + num.toString(2));
                    console.log('2진수 = ' + num.toString(8));
                    console.log('2진수 = ' + num.toString(16));
                    console.log('2진수 = ' + num.toString(32));
                    console.log('2진수 = ' + num1.toString(10));
                </script>
            </body>
            ```

            

      - Sources: 로딩된 웹 페이지의 자바스크립트를 디버깅할 수 있다.

      - Network: 로딩된 웹 페이지에 관련한 네트워크 요청 정보와 퍼포먼스 확인

      - Application: 웹 스토리지, 세션, 쿠키를 확인하고 관리할 수 있다.

### 3. JavaScript의 주의점

------

- **자바스크립트는 HTML에 포함되어야 한다.**

  - 자바스크립트는 HTML에서 `<head></head>`또는 `<body></body>`에 `<script></script>`태그를 넣어서 작성할 수 있다.

    - <u>만약 `<body></body>`에 `<script></script>`가 위치한다면 반드시 `<body>`의 마지막에 위치해야한다.</u>
      - 이유
        - 브라우저는 다음과 같이 작동한다.	
          1. HTML을 읽는다.
          2. HTML을 파싱한다.
          3. DOM 트리를 생성한다.
          4. Render 트리(DOM tree + CSS의 CSSOM 트리 결합)가 생성된다.
          5. Display에 표시
        - 여기서 `<script>`가 `<body>`앞에 위치한다면 HTML을 읽는 과정에 스크립트를 만나면 중단 시점이 생기고 Display에 표시되는 것이 지연되며
        - DOM 트리가 생성되기 전에 자바스크립트가 생성되지도 않은 DOM의 조작을 시도한다.

  - 예

    ```html 
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script>
            //자바스크립트가 위치할 곳1: head
        </script>
    </head>
    <body>
        <script>
            //자바스크립트가 위치할 곳2: body
        </script>
    </body>
    </html>
    ```

- 자바스크립트의 기본 구문

  - 유니코드 지원
  - case-sensitive: 대/소문자 구분
  - Escaping Charaters 사용
    - `\` 사용
    - `var a = "그의 이름은 \"한지민\" 입니다."`
  - 특수문자는 `$`와`_`만 가능
  - 키워드는 소문자를 사용
    - buttonone, txt1
  - white Space
    - 구문에서 들여쓰기, 띄어쓰기는 구문에 영향을 주지 않는다.
      - 들여쓰기 권장
  - 주석
    - `/**/`
    - `//`
  - `;`: 문장은 반드시 세미콜론을 사용해야한다.
  
- HTML의 `<input>`태그의 text박스는 유저가 무엇을 입력했던간에 문자형이다.

  - `<input type='number'>`라도 입력을 숫자로 제한하는 것이지, 입력값이 숫자인 것은 아니다.
  - 따라서 parseInt()함수를 이용해서 사용자가 텍스트박스에 입력한 값을 숫자로 변환해야한다.

### 4. JavaScript의 변수

------

- **자바스크립트의 변수에는 데이터 타입과 상관없이 한 키워드를 사용한다.**

  - 데이터 타입

    - 프로그래밍을 변수를 통해 값을 저장하고 참조하며 연산자로 값을 연산, 평가하고 조건문과 반복문에 의한 흐름제어로 데이터의 흐름을 제어하고 함수로 재사용이 가능한 구문의 집합을 만들며 객체, 배열 등으로 자료를 구체화 한다.
  - 여기서 변수는 값의 위치(주소)를 기억하는 저장소이다. 값의 위치란 값이 위치하고 있는 메모리상의 주소를 의미한다. 즉 변수란 값이 위치하기 위한 메모리 주소에 접근하기 위해 사람이 이해할 수 있는 언어로 명명한 식별자이다.
    
    - 메모리에 값을 저장하기 위해서는 먼저 메모리 공간을 확보해야 할 메모리의 크기(Byte)를 알아야 한다. 이는 값의 종류에 따라 확보해야할 메모리의 크기가 다르기 때문이다. 이때 값의 종류, 즉 데이터의 종류를 데이터 타입이라고 한다.
  - 정적 타입(Static/Strong Type)과 동적 타입(Dynamic/weak Type)의 데이터 타입 이용
      - C나 Java와 같은 C 계열의 언어는 변수를 선언할 때 반드시 변수에 저장해야할 데이터의 타입을 지정(Type Annotation)해야한다.
        - char a = 'a';
        - 정적 타입의 경우 변수 선언을 만나면 해당하는 메모리 영역을 확보한다. 
          - int를 만나면 4byte를 확보 
            - 따라서 변수 타입에 잘못된 값을 넣는다면 오류가 난다.
      - <u>자바스크립트는 동적 타입이다. 동적 타입은 변수의 타입 지정(Type Annotation)을 자동으로 추론(Type Inference)한다.</u>
        - *따라서 자바스크립트는 키워드 `var` 하나로 모든 데이터 타입을 자유롭게 할당한다.* 
          - 따라서 변수에 다양한 타입을 지정할수 있다.
          - **var 키워드로 선언한 변수는 중복 선언이 가능하다.**
            - 이 경우 해당 변수는 이전 변수의 값을 덮어쓴다.
              - 하지만 이는 비권장
    
  - <u>keyword: `var`</u>

  - `typeof()`: var에 넣을 값이 어떤 타입인지 모르므로 typeof()를 사용하여 타입을 알 수 있다.

    ```html
    <body>
        <script>
            var str = 'Hello, World';
            var num = 3;
            var num1 = 3.0;
            var boo = true;
            var un;
            var nul = null;
            var str1 = new String('Hello');
            console.log(str.length);
            var str2 = String('World');
            console.log(str1.length);
            //typeof: var의 형식이 계속해서 바뀌므로 typeof로 변수의 타입을 확인
            console.log(typeof(str1));
        </script>  
    </body>
    ```

- **자바스크립트의 Literal**

  - 리터럴은 값 자체를 의미

    - `5`, `8.96`처럼 변수에 속하지 않은 값 자체 

  - Number Literal

    - 자바스크립트에서는 정수와 실수를 합쳐서 Number이다.

  - Boolean Literal

    - Boolean의 기본값

      - undefined: null의 경우 flase
      - number: 값이 없으면 false, 0은 거짓
      - String의 경우 값이 없으면 false
      - object는 true
      - NaN

    - 예

      ```javascript
      <body>
          <script>
              var unde; //undefied
              var numb = 3;//number
              var str1 = "";
              var str2 = null;
              var student = {name:'aa'};
      
              if(unde){
                  console.log("true");
              }else{
                  console.log("false");
              }
              if(str1){
                  console.log("true");
              }else{
                  console.log("false");
              }
          </script>
      </body>
      ```

  - String Literal

  - Array Literal

    - `var array = [4, 'Hello', true]`처럼 한 배열에 다른 타입을 넣을 수 있다.
      - 이는 객체와 비슷하지만 배열은 인덱스 기준, 객체는 key를 기반으로 자료를 저장한다는 점이 다르다.

  - Object Literal

- **자바스크립트의 Primitive Type**

  1. Number
     - 자바스크립트의 Number는 정수와 실수를 모두 포함
  2. String
     - 자바스크립트에는 Charater형이 없으므로 모두 String형
     - `""` `''`은 모두 사용할 수 있다.
  3. Boolean
     - Boolean의 기본값을 유의
  4. Undefined
     - `var a;`와 변수의 값이 무엇인지 판단할 수 없는 경우
     - 즉 변수에 어떤 형식이 들어올지 모른다는 의미
  5. Null
  6. Symbol: ES6에서 추가

- **전역변수와 지역변수**

  - 자바스크립트에서 함수내에 사용하면 지역변수, 함수 밖에서 사용하면 지역변수이다.
  - 하지만 이외에 따로 구분이 없기 때문에 다음과 같은 방법으로 지역변수, 전역변수를 구별한다.
    - `var`키워드를 사용: 지역변수
    - `var`키워드를 사용하지 않거나 ES6에서 추가된 `let`키워드를 사용: 전역변수
  
- 변수 호이스팅(Variable Hoisting)

  - **호이스팅**

    -  호이스팅이란 var 선언문이나 function 선언문 등 모든 선언문이 해당 [Scope](https://poiemaweb.com/js-scope)의 선두로 옮겨진 것처럼 동작하는 특성을 말한다. 즉, 자바스크립트는 모든 선언문(var, let, const, function, [function*](https://poiemaweb.com/es6-generateor), class)이 선언되기 이전에 참조 가능하다.

  - **따라서 변수 호이스팅이란 나중에 선언된 변수가 Scope의 선두로 옮겨진 것처럼 작동하여 선언 이전에 참조될 수 있다.**

  - 이게 가능한 이유는 다음과 같다.

    - 자바스크립트의 변수는 3단계에 걸쳐 생성된다.
      1. 선언 단계(Declaration phase): 변수 객체(Vaiable Object)에 변수를 등록, 이 변수 객체는 스코프가 참조하는 대상이 된다.
      2. 초기화 단계(Initialization phase): 변수 객체(Vaiable Object)에 등록된 변수를 메모리애 할당, 이 단계에서 변수는 undefined로 초기화
      3. 할당 단계(Assignment phase): undefined로 초기화된 변수에 실제값을 할당
    - `var` 키워드로 선언된 변수는 선언 단계와 초기화 단계가 한번에 이루어진다.
    - 나중에 선언된 변수는  Scope의 선두로 옮겨진 것처럼 작동하여 참조할 수 있다.
    - 하지만 할당 단계는 따로 이루어지기 때문에, 즉 호이스팅된 변수는 초기화 단계까지만 이루어지기때문에 
    - 호이스팅된 변수의 값은 `undefined`이다.

  - 자바스크립트의 경우 함수 레벨 스코프(Function-level scope)를 사용한다.

  - 예

    ```javascript
       <script>
            console.log(a); //hosting: undefined
            //여기까지만 하면 오류: 당연하지만 a변수는 없다.
            //Uncaught ReferenceError: a is not defined
            var a = 'Hosting';
            //여기까지하면 처음 a의 log는 undefined로 나온다.
            //이게 Hosting
            /*
            이게 자바스크립트의 호이스팅이다.
            자바스크립트의 모든 선언문은 호이스팅된다.
            호이스팅이란 var 선언문이나 function 선언문 등 모든 선언문이 
            해당 Scope의 선두로 옮겨진 것처럼 동작하는 특성이다.
            즉 나중에 var a = 'Hosting';으로 선언했지만 a라는 변수가 scope의 선두
            로 옮겨져서 console.log()로 a를 참조할 수 있었던 것이다.
            여기서 중요한거: 자바스크립트의 var는 선언단계와 초기화 단계가 동시에 이루어진다.
            즉 var a;로 선언한 것은 할당 단계가 이루어 지지 않은 것으로 값은 undefined이다.
            하지만 변수 선언/초기화 단계는 동시에 이루어지고 할당단계는 따로 이루어지기에
            a는 초기화 단계에만 진행된 상태로 undefined라는 값이 선언되어 있다.
            */
            console.log(a);//Hosting
        </script>
    ```

- var 키워드로 선언된 변수의 문제점

  - 함수 레벨 스코프
    - 전역 변수의 남발
    - for loop 초기화에 사용된 변수를 해당 함수에서 참조 가능
  - var 키워드 생략 허용
    - 의도치 않은 변수의 전역화
  - 중복 선언 허용
    - 의도치 않은 변수값 변경
  - 변수 호이스팅
    - 변수 선언 이전에 참조 가능 
  - 따라서 변수의 스코프는 좁을수록 좋다.
    - ES6에서는 이래서 let과 const 키워드를 도입

### 5. JavaScript의 연산자

------

- 자바스크립트의 연산자는 다음과 같다.

  ![](https://github.com/sis92345/TIL/blob/master/Java/png/operator1.jpg)

  ![](https://github.com/sis92345/TIL/blob/master/Java/png/operator2.jpg)
  - 자바스크립트의 연산자는 자바와 거의 비슷하지만 다음의 연산자는 자바와는 다르므로 주의해야 한다.
    - `void`: 단항 undefined 연산자, 피연산자로 무엇을 지정하든지 연산의 결과는 undefined이다.
    - `delete`: 객체의 속성 값을 제거한다.
    - `in`: 객체의 속성이 존재하면 true를 반환
    - `==`과`===`: 비교 연산자, `==`는 값만 비교, `===`는 값과 타입을 비교

- void: 단항 undefined 연산자, 피연산자로 무엇을 지정하든지 연산의 결과는 undefined이다.

  - `console.log(void "안녕하세요");`: 결과값은 undefined

  - void는 자바스크립트에서 몇가지 관용구로 사용한다.

    ```html
     <ul>
            <li><a href="#">Naver</a></li><!--링크가 안걸리게 하는법1: #-->
            <li><a href="javascript:void(0)">Google</a></li><!--링크가 안걸리게 하는법2: javascript:void(0)-->
            <!--
                #은 url에 #이 생기는데 void는 깔끔
            -->
    </ul>
    ```

- `delete`: 객체의 속성을 삭제, 실제로는 값을 삭제한다.

  ```javascript
   <script>
          var fruits = ['사과', '딸기', '복숭아', '포도'];
          console.log(fruits.length);     //4
          console.log(fruits[0]);          //사과
          delete fruits[0];
          console.log(fruits.length);    //4
          console.log(fruits[0]);         //undefined
          //fruit[0]이 delete가 되어서 값이 날아갔다. 따라서 undefined로 출력
          //즉 공간은 남아있고 값이 delete
  
          var car = {name: 'Sonata', maker: 'Hyendai', price: 30000000};
          console.log(car.maker);//Hyundai
          delete car['maker']; //JavaScript에서 객체를 표현하는 방법
          /*
          JSON: javaScript가 객체를 표현하는 방법
  	    var car = {'name': 'Sonata', 'maker': 'Hyendai', 'price': 30000000};
  	    */
          console.log(car.maker);//undefined
  		//전역변수에서 var 키워드를 사용하지 않으면 delete로 삭제가 가능하지만
  		//변수에서 var키워드로 선언된 상태에서 delete하면 삭제가 안된다.
  		var myworld = 'Hello, World';
          console.log(myworld);
          delete myworld;
          console.log(myworld);
  
          num = 100;
          console.log(num);
          flag = delete num;
          console.log(flag); //true를 삭제
      </script>
  ```

- `in`: oracle의 in연산자와 비슷, 객체의 속성이 존재하면 true를 반환

  ```javascript
   <script>
           var fruits = ['사과', '딸기', '복숭아', '포도'];
           console.log('사과' in fruits);
  </script>
  ```

  - 주의점

    - 위 코드에서 결과는 false다.

    - '사과'는 멤버의 값이지 멤버가 아니다.

    - fruits에 존재하는 멤버는 0, 1, 2, 3이다.

      - 0멤버가 가르키는 값이 '사과이다.'

    - 따라서 멤버의 결과를 확인한다는 의미는 다음과 같다.

      ```javascript
          <script>
              var fruits = ['사과', '딸기', '복숭아', '포도'];
              console.log('사과' in fruits);
              delete fruits[0];
              console.log(0 in fruits);//멤버는 날라갔지만
              console.log(fruits.length);//공간은 4개 그대로
              var car = {name: 'Sonata', maker: 'Hyendai', price: 30000000};
              console.log('name' in car);
              flag = delete car.maker;
              console.log(flag);
              console.log('maker' in car);
          </script>
      ```

- `==`과 `===`

  - `==`: 비교시 비교 대상의 타입을 일치시켜서 비교

    - 즉 `==`는 값만 비교

  - `===`: 타입과 값을 비교

    ```javascript
        <script>
            if('1.0' == 1.0){ //값만 비교
                console.log('같다');
            }else
            {
                console.log('다르다.');
            }
            if('1.0' === 1.0){ //값과 타입을 비교
                console.log('같다');
            }else
            {
                console.log('다르다.');
            }
        </script>
    ```

    

