JavaScriptOverview
==========

> 자바스크립트란
>
> 자바스크립트의 개발 환경

> 자바스크립트의 주의점
>
> 객체

### 1. 자바스크립트란

---------------

- **JavaScripts란?**

  - 자바스크립트는 *웹페이지에서 복잡한 무언가(주기적으로 내용을 갱신하는 기능이나 능동적인 지도, 변화하는 2D/3D 그래픽, 동영상 등)을 적용*할 수 있게하는 스크립트 또는 프로그래밍 언어이다.
  - 자바스크립트는단독으로는 사용할 수 없다.
    -  HTML5과 CSS3와 함께 표준 웹 기술을 이루어 사용된다,

- **웹 구성 요소**

  - **HTML5 + CSS3 + JavaScripts**

    - **HTML5**: 웹 컨텐츠의 구조와 의미를 문단, 제목, 표, 삽입 이미지 등으로 정의하여 <u>웹 페이지의 뼈대</u>를 구성하는 마크업 언어
    - CSS3: 뼈대를 구성한 HTML5에 배경색, 폰트 등을 구성하여 <u>HTML5를 꾸며주는 역할</u>
    - **JavaScript**: HTML5와 CSS3로 만든 페이지의 <u>컨텐츠를 동적으로 구성</u>하게 한다. 즉 JavaScript를 이용하여 움직이는 이미지, 그림과 기타 많은 일을 가능케한다.

    ![](https://github.com/sis92345/TIL/blob/master/Java/png/Web.png)

- **JavaScript의 특징**

  - **자바스크립트는 CSS, HTML과 함께 웹을 구성하는 요소이다.**
  - 자바스크립트는 웹 브라우저에서 동작하는 유일한 프로그래밍 언어이다.
  - <u>자바스크립트는 인터프리터 언어(Interpreter Language)</u>로서 별도의 컴파일 작업을 수행하지 않는다.
  - 자바스크립트는 기존의 프로그래밍 언어에 영향을 받았다.
    - 따라서 C, Java와 유사하다. 
    - 단 Java와 모든 부분이 같은 것이 아니다
      - 특히 변수에 타입이 없다는 점은 자바와 비교해서 주의할 점이다.
  - 자바스크립트는 다음을 지원한다.
    - 명령형(Imperative)
    - 함수형(Functional)
    - 프로토타입 기반(Prototype-based)
    - 객체지향 프로그래밍
  - 자바스크립트는 보안 문제때문에 유저의 하드디스크에 접근할 수 없다.
    - 단 읽기는 가능
  - **JavaScript와 ECMAScript**
    - ECMAScript는 자바스크립트의 표준 명세인 ECMA-262를 말한다.
      - 즉 ECMAScript는 스크립트 언어를 어떯게 만들어야 하는지를 설명하는 일종의 설명서, 규격, 표준이고, JavaScript는 ECMAScript를 사양을 바탕으로 만들어진 언어이다.
    - 기존 자바스크립트는 LiveScript였으나 자바의 인기에 영향을 받아 JavaScript로 이름이 바뀐다.
      - 즉 마케팅 측면의 영향이지 자바와는 기존 프로그래밍 언어의 영향을 받아 문법이 비슷한거 제외하고는 서로 상관이 없다.
    - ECMAScript의 현재 버전은 ES6(ES 2015)이다. 다음의 기능이 추가되었다.
      - let, const키워드 추가
      - arraw문법 지원
      - 클래스 추가 등

### 2. JavaScript의 개발 환경

------

- 자바스크립트는 웹 브라우저에서 작동하는 프로그래밍 언어라는 점, 인터프리터 언어라는 점에서 기존의 JAVA와 다른 개발 환경이 필요하다.

- 모든 웹 브라우저는 자바스크립트를 해석하는 자바스크립트 엔진을 내장하므로 **웹 브라우저의 개발자 도구를 이용**하여 개발 할 수 있다.

- 웹 브라우저의 개발자 도구를 이용한 자바스크립트 개발

  - 개발자 도구: 모든 웹 브라우저는 개발자 도구가 존재한다.

    - 개발자 도구의 실행

      - Windows: `F12`또는 `Ctrl+Shift+I` 
      - MAC: `command + option + I`
      
    - 개발자 도구의 주 기능

      - Element: 

        - 로딩된 웹 페이지의 DOM과 CSS를 편집하여 랜더링된 뷰를 확인할 수 있다.
        - 단 편집된 내용이 저장되지는 않는다.
        - 웹 페이지가 의도된 대로 랜더링되지 않았다면 이 패널을 확인하여 유용한 힌트를 얻을 수 있다.

      - Console: 

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

- 자바스크립트는 HTML에 포함되어야 한다.

  - 자바스크립트는 HTML에서 `<head></head>`또는 `<body></body>`에 `<script></script>`태그를 넣어서 작성할 수 있다.

    - 만약 `<body></body>`에 `<script></script>`가 위치한다면 반드시 `<body>`의 마지막에 위치해야한다.
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

### 4. JavaScript의 변수

------

- **자바스크립트의 변수에는 데이터 타입과 상관없이 한 키워드를 사용한다.**

  - keyword: `var`

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

공사중