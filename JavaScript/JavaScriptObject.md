JavaScript Object
==========

> 자바스크립트의 객체
>
> 자바스크립트 객체의 선언
>
> 자바스크립트 객체의 접근

> 객체의 분류
>
> Number
>
> Math
>
> Date
>
> String
>
> RegExp
>
> Arrop

### 1. 자바스크립트의 객체

---------------

- **객체(Object)란?**

  - 객체는 데이터를 의미하는 **프로퍼티(property)**와 데이터를 참조하고 조작할 수 있는 동작(behavior)을 의미하는 **메소드(method)**로 구성된 집합

    - 객체는 데이터(프로퍼티)와 그 데이터에 관련되는 동작(메소드)을 모두 포함할 수 있기 때문에 데이터와 동작을 하나의 단위로 구조화할 수 있어 유용

  - 속성(Property)와 Method

    - Property: 자바 클래스의 멤버 변수와 비슷한 역할
      - 자바의 멤버 변수와 다르게 **Property Key와 Property Value로 이루어져 있다.**
        - 프로퍼티 키의 명명 규칙과 프로퍼티 값으로 사용할 수 있는 값은 아래와 같다.
          - 프로퍼티 키 : 빈 문자열을 포함하는 모든 문자열 또는 symbol 값
            - 프로퍼티 키는 암묵적으로 문자열로 타입이 변환된다.
            - 중복 선언 가능: 나중에 선언한 프로퍼티가 먼저 선언한 프로퍼티를 덮어쓴다.
          - 프로퍼티 값 : 모든 값
    - Method: 프로퍼티 값이 함수일 경우, 이를 메소드라 한다.
      - 쉽게 말해 프로퍼티의 값이 함수로 선언되어 있을 경우이며, 함수가 함수안에 선언된 경우이다.
      - 해당 메소드는 객체에 재한된다.

  - 객체 리터럴

    - 중괄호를 이루어진 객체의 리터럴이다. 1개 이상의 프로퍼티를 기술하면 프로퍼티가 추가된 객체를 만들 수 있으며 중괄호에 아무것도 기술하지 않으면 빈 객체가 생성된다. `,`를 이용하여 프로퍼티들을 나열한다.

    - 객체 리터럴의 예

      ```javascript
      var person = {
      	//Property
      	name: 'AN',
      	age: 32,
      	//Method
      	sayHello: function(){
      		document.write('<p>Hello!</p>')
      	}
      }
      ```

      

### 2. 객체의 선언

------

- 자바스크립트에서 객체를 선언하는 방법은 3가지이다.

  - 객체 리터럴 사용
  - Object 생성자 함수, new 연산자 이용
  - 생성자 함수

- 위 3가지 방법 중 객체 리터럴 사용 방법과 Object 생성자 함수, new 연산자 이용의 경우 프로퍼티를 정의하는 문법이 살짝 다르다는 점을 유의하자

  - 객체 리터럴 사용

    - 프로퍼티 정의: `propertyKey: 'Property Value'`

    - 프로퍼티 나열: `,`

      ```javascript
      var person = {
      	//Property
      	name: 'AN',
      	age: 32,
      	//Method
      	sayHello: function(){
      		document.write('<p>Hello!</p>')
      	}
      }
      ```

  - Object 생성자 함수, new 연산자 이용

    - 프로퍼티 정의: `propertyKey = 'Property Value';`

    - 프로퍼티 나열: `;`

      ```javascript
      function person(){
          //Property
      	name = 'AN';
      	age = 32;
      	//Method
      	this.sayHello = function(){
      		document.write('<p>Hello!</p>')
      	}
      }
      ```

- 객체 리터럴 사용

  - 가장 일반적인 자바스크립트의 객체 생성 방식이다. 클래스 기반 객체 지향 언어와 비교할 때 매우 간편하게 객체를 생성할 수 있다. 중괄호({})를 사용하여 객체를 생성하는데 {} 내에 1개 이상의 프로퍼티를 기술하면 해당 프로퍼티가 추가된 객체를 생성할 수 있다. {} 내에 아무것도 기술하지 않으면 빈 객체가 생성된다.

    ```javascript
    var emptyObject = {};
    console.log(typeof emptyObject); // object
    
    var person = {
      name: 'Lee',
      gender: 'male',
      sayHello: function () {
        console.log('Hi! My name is ' + this.name);
      }
    };
    
    console.log(typeof person); // object
    console.log(person); // {name: "Lee", gender: "male", sayHello: ƒ}
    
    person.sayHello(); // Hi! My name is Lee
    ```

- Object 생성자 함수, new 연산자 이용

  - new 연산자와 [Object 생성자 함수](https://poiemaweb.com/js-built-in-object#11-object)를 호출하여 빈 객체를 생성

    - 생성자(constructor) 함수란 new 키워드와 함께 객체를 생성하고 초기화하는 함수
      - 생성자 함수를 통해 생성된 객체를 인스턴스(instance)라 한다

  - 빈 객체 생성 이후 프로퍼티 또는 메소드를 추가하여 객체를 완성하는 방법

    ```javascript
    // 빈 객체의 생성
    var person = new Object();
    // 프로퍼티 추가
    person.name = 'Lee';
    person.gender = 'male';
    person.sayHello = function () {
      console.log('Hi! My name is ' + this.name);
    };
    
    console.log(typeof person); // object
    console.log(person); // {name: "Lee", gender: "male", sayHello: ƒ}
    
    person.sayHello(); // Hi! My name is Lee
    ```

- 생성자 함수

  - 객체 리터럴 방식과 Object 생성자 함수 방식으로 객체를 생성하는 것은 프로퍼티 값만 다른 여러 개의 객체를 생성할 때 불편하다. 동일한 프로퍼티를 갖는 객체임에도 불구하고 매번 같은 프로퍼티를 기술해야 한다.

  - 생성자 함수를 사용하면 마치 객체를 생성하기 위한 템플릿(클래스)처럼 사용하여 프로퍼티가 동일한 객체 여러 개를 간편하게 생성할 수 있다.

    ```javascript
    //생성자
    function Student(hakbun, name, kor, eng, mat){
        //함수에서 var키워드를 붙이면 지역변수
        //Property
        var hakbun = hakbun;
        var name = name;
        var kor = kor;
        var eng = eng;
        var mat = mat;
        var tot= null;
        var avg= null;
        var grade= null;
        //지역변수로 접근하기위해서 public 사용 필요
        //자바스크립트의 public은 this를 이용해 getter setter 생성
        //익명함수 사용
        this.getKor = function(){
            return kor;
        }
        this.getEng = function(){
            return eng;
        }
        this.getMat = function(){
            return mat;
        }
        this.getTot = function(){   
            return tot;  
        }
        this.setTot = function(total){
            tot = total;
        }
        this.getAvg= function(){
            return avg;
        }
        this.setAvg = function(average){
            avg = average;
        }
        this.getGrade= function(){
            return grade;
        }
        this.setGrade = function(grd){
            grade = grd;
        }
        //toString
        this.toString = function(){
            var str = ' ';
            //하나의 학생은 테이블에 하나의 tr
            str = '<tr>';
            str += '<td>' + hakbun + '</td>';
            str += '<td>' + name + '</td>';
            str += '<td>' + kor + '</td>';
            str += '<td>' + eng + '</td>';
            str += '<td>' + mat + '</td>';
            str += '<td>' + tot + '</td>';
            str += '<td>' + avg.toFixed(1) + '</td>';
            str += '<td>' + grade + '</td>';
            str += '</tr>';
            return str;
        }
    }
    //생성자 함수를 이용해 객체를 생성
    var std = new Student('2020-01','chulsu', 78, 50, 100);
    var str = std.toString();
    document.write(str);
    ```

    - 생성자 함수를 이용해 객체를 생성할 때 주의점
      - 생성자 함수 이름은 일반적으로 대문자로 시작한다. 이것은 생성자 함수임을 인식하도록 도움을 준다.
      - 프로퍼티 또는 메소드명 앞에 기술한 `this`는 생성자 함수가 생성할 **인스턴스(instance)**를 가리킨다.
      - **this에 연결(바인딩)되어 있는 프로퍼티와 메소드는 `public`(외부에서 참조 가능)하다.**
      - **생성자 함수 내에서 선언된 일반 변수는 `private`(외부에서 참조 불가능)하다. 즉, 생성자 함수 내부에서는 자유롭게 접근이 가능하나 외부에서 접근할 수 없다.**

### 3. 객체 프로퍼티 접근

------

- Property Key

  - 프로퍼티 키는 일반적으로 문자열(빈 문자열 포함)을 지정한다.

    - 암묵적으로 타입이 변환되어 문자열이 된다.

    -  **프로퍼티 키는 문자열이므로 따옴표(‘’ 또는 ““)를 사용한다.** 

      - 하지만 자바스크립트에서 사용 가능한 유효한 이름인 경우, 따옴표를 생략할 수 있다.

        - 반대로 말하면 자바스크립트에서 사용 가능한 유효한 이름이 아닌 경우, 반드시 따옴표를 사용하여야 한다.

        - 예를 들어 자바스크립트에서 사용 가능한 특수문자는 `_`와 `$`이므로 이를 이용해 키를 지정하는 경우에는 문제가 없지만 이외의 다른 특수문자를 이용한다면 `''`를 사용해야 한다.

          - 이 경우 value로 접근하기 위해서 반드시 대괄호를 사용해야 한다.

            ```javascript
            var person = {
                      say_hello: 'hello',
                      'say-hello1': 'hello1',
                      sayHello: function(ob){
                          //value 접근 방법을 유의
                          console.log(this.say_hello + ob + person['say-hello1']);
                      }
                  }
            ```

            

  - Property Value를 접근하는 방법은 2가지가 있다.

    - 대괄호

      - FM
        - 자바스크립트에서 사용 가능한 유효한 이름이 아닌 경우로 key를 지정했다면 이 방법을 사용
        - Syntax: `functionName['Property Key']`

    - 마침표 이용

      - Syntax: functionName.propertyKey

    - 예

      ```javascript
      var person = {
        'first-name': 'Ung-mo',
        'last-name': 'Lee',
        gender: 'male',
        1: 10
      };
      
      console.log(person);
      
      console.log(person.first-name);    // NaN: undefined-undefined
      console.log(person[first-name]);   // ReferenceError: first is not defined
      console.log(person['first-name']); // 'Ung-mo'
      
      console.log(person.gender);    // 'male'
      console.log(person[gender]);   // ReferenceError: gender is not defined
      console.log(person['gender']); // 'male'
      
      console.log(person['1']); // 10
      console.log(person[1]);   // 10 : person[1] -> person['1']
      console.log(person.1);    // SyntaxError
      ```

  - 그 외 프로터피의 유의점

    - 객체에 존재하지 않는 프로퍼티를 참조하면 `undefined`를 반환한다.

    - 객체가 소유하고 있는 프로퍼티에 새로운 값을 할당하면 프로퍼티 값은 갱신된다.

    - 객체가 소유하고 있지 않은 프로퍼티 키에 값을 할당하면 하면 주어진 키와 값으로 프로퍼티를 생성하여 객체에 추가한다.

      ```javascript
      var person = {
        'first-name': 'Ung-mo',
        'last-name': 'Lee',
        gender: 'male',
      };
      
      person.age = 20;
      console.log(person.age); // 20
      ```

    - `delete` 연산자를 사용하면 객체의 프로퍼티를 삭제할 수 있다. 이때 피연산자는 프로퍼티 키이어야 한다.

      ```javascript
      var person = {
        'first-name': 'Ung-mo',
        'last-name': 'Lee',
        gender: 'male',
      };
      
      delete person.gender;
      console.log(person.gender); // undefined
      
      delete person;
      console.log(person); // Object {first-name: 'Ung-mo', last-name: 'Lee'}
      ```

### 4. JavaScript의  객체의 종류

------

- 자바스크립트에서 사용하는 객체의 종류는 다음과 같다.
  - Built-in Object	
    - Standart Built-in Object
      - Object
      - Function
      - Boolean
      - Number
      - Math
      - Date
      - String
      - RegExp
      - Array
    - BOM(Browser Object Model)
    - DOM(Document Object Model)
  - Host Object(사용자 정의 객체)

### 5. Number

------

- **Number 객체**

  - **원시 타입 number를 다룰 때 유용한 프로퍼티와 메소드를 제공하는 레퍼(wrapper) 객체**
  - 변수 또는 객체의 프로퍼티가 숫자를 값으로 가지고 있다면 Number 객체의 별도 생성없이 Number 객체의 프로퍼티와 메소드를 사용할 수 있다.

- Number Constructor

  - `Number()`이용

    - <u>Number()의 파라미터가 숫자로 변환될 수 없다면 NaN을 반환</u>
    - new 연산자를 사용하지 않으면 Primitive type의 Number를 반환
      - 변수, 프로퍼티의 값이 숫자라면 Number 객체의 프로퍼티, 메소드를 이용할 수 있음을 유의

  - 예: 

    ```javascript
    var a  = new Number(30);
    console.log(a); //30
    var a  = new Number('a');
    console.log(a); //NaN
    
    var a  = Number(30);
    console.log(typeof(a)); //Number
    var a  = new Number(30);
    console.log(typeof(a)); //Object
    ```

- Number Property

  - Number.EPSILON

    - ES6에서 사용
    -  JavaScript에서 표현할 수 있는 가장 작은 수
    - 자세한 사용은 https://poiemaweb.com/js-number참고

  - Number.MAX_VALUE

    - 자바스크립트에서 사용 가능한 가장 큰 숫자(1.7976931348623157e+308)를 반환

  - Number.MIN_VALUE

    - 자바스크립트에서 사용 가능한 가장 작은 숫자(5e-324)를 반환

  - Number.POSITIVE_INFINITY

    - 양의 무한대 `Infinity`를 반환한다.

  - Number.NEGATIVE_INFINITY

    - 음의 무한대 `-Infinity`를 반환한다.

  - Number.NaN

    - 숫자가 아님(Not-a-Number)을 나타내는 숫자값이다. Number.NaN 프로퍼티는 window.NaN 프로퍼티와 같다.

      ```javascript
      nsole.log(Number('xyz')); // NaN
      console.log(1 * 'string');  // NaN
      console.log(typeof NaN);    // number
      ```

- Number Method

  - Number.isFinite(testValue: number): boolean

    - 매개변수에 전달된 값이 정상적인 유한수인지를 검사하여 그 결과를 Boolean으로 반환한다.

      ```javascript
      /**
       * @param {any} testValue - 검사 대상 값. 암묵적 형변환되지 않는다.
       * @return {boolean}
       */
      //Number.isFinite(testValue)
      
      Number.isFinite('2005/12/12')   // false
      Number.isFinite(0)         // true
      ```

  - Number.isInteger(testValue: number): boolean

    - 매개변수에 전달된 값이 정수(Integer)인지 검사하여 그 결과를 Boolean으로 반환한다

      ```javascript
      /**
       * @param {any} testValue - 검사 대상 값. 암묵적 형변환되지 않는다.
       * @return {boolean}
       */
      //Number.isInteger(testValue)
      
      Number.isInteger(0)     //true
      Number.isInteger(0.5)   //false
      ```

  - Number.isNaN(testValue: number): boolean

    - 매개변수에 전달된 값이 NaN인지를 검사하여 그 결과를 Boolean으로 반환한다.

  

