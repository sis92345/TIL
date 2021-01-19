## 0. 자바스크립트: 객체와 배열, 함수

### 1.   자바스크립트의 객체

- **객체**	
  - 자바스크립트에서는 원시값을 제외한 모든 것이 객체이다.
    - 원시타입:
      - number, string, boolean, undefined, null,  object
      - ES6에서 추가: symbol
  - 자바스크립트에서 <u>객체는 `키와 값`을 한쌍으로 묶은 데이터</u>를 여러개 묶은 개념이다.
    - 즉 객체에 포함된 데이터는 `Property`다. 
- **객체의 생성**
  - 객체 리터럴
  - 생성자

### 2. 객체 리터럴

- 리터럴의 개념

  - 상수와 리터럴의 비교
    - 상수는 변하지 않는 변수이다.
    - 리터럴은 상수나 변수에 들어갈 *값 자체*를 말한다.
    - 즉 리터럴은 데이

- **객체 리터럴의 규칙**

  ```javascript
  {key1 : "value" , key2 : 1 }
  ```

  - 객체 리터럴을 다음과 같이 변수에 대입할 수 있다.

    ```javascript
    var card = {key1 : "value" , key2 : 1 }
    ```

    

  - `{...}`로 표현된 것이 바로 객체 리터럴

    - `:`: 키와 값의 분류
    - `,`: 프로퍼티 구분

  - 프로퍼티 키로 다음과 같은 것을 사용할 수 있다.

    - 모든 식별자
    - 문자열 리터럴

  - 객체안의 프로퍼티를 읽을 때는 다음과 같은 방법으로 읽을 수 있다.

    ```javascript
    var card = {key1 : "value" , key2 : 1 };// Object
    card.key1;    //value
    card["key2"];//1
    ```

    - **객체에 없는 프로퍼티를 읽으면 `undefined`를 반환한다.**

      ```javascript
      var card = {key1 : "value" , key2 : 1 };// Object
      card.value //undefined
      ```

  - 객체 리터럴안에 프로퍼티를 작성하지 않으면 빈 객체가 생성된다.

    ```javascript
    var bottle = {};
    console.log(bottle);
    ```

  - 프로퍼티의 추가 및 삭제

    - **프로퍼티의 추가**: <u>객체에 없는 프로퍼티 키 값을 대입</u>하면 새로운 프로터피가 추가된다.

    - **프로터티의 삭제**: `delete 연산자` 사용

      ```javascript
      var card = {key1 : "value" , key2 : 1 };// Object
      card.key3 = "value1"; //add Property
      delete card.key2      //delete Property
      ```

    - **객체의 프로퍼티 확인**: **`in` 연산자**

      - `in` 연산자로 해당 객체의 프로퍼티를 확인할 수 있다.

        ```javascript
        var card = {key1 : "value" , key2 : 1 };// Object
        console.log( key1 in card );   //Uncaught ReferencrError: Key1 is not defined
        console.log( "key1" in card ); //true
        console.log( "value" in card );    //false
        console.log( "key3" in card );    //false
        console.log( "toString" in card );    //true: 상속
        ```

        - key로만 확인 가능: `""`같이 문자열에 키를 넣어야한다.
          - 안쓰면 객체로 인식
        - value는 in 연산자에서 false로 나온다.
        - **따라서 `in`연산자가 조사하는 대상은 다음과 같다.**
          - **객체가 가진 프로퍼티**
          - **객체가 상속받는 모든 프로터티**

  - 객체 리터럴의 프로터피로 객체 리터럴을 사용할 수 있다.

    ```javascript
    var card = {key1 : "value" , key2 : 1 };// Object
    card.key3 = { x : 1.3, y : 2.5 }	//card 객체에 객체 리터럴을 프로터리로 추가
    card.key3.x    //1.3
    ```

- **메서드**

  - **객체 리터럴에 저장된 프로퍼티의 타입이 함수라면 해당 함수를 메소드라고한다: 교재 108쪽에서 다시 설명**

- 객체는 참조 타입이다.

### 3. 함수

- 개념
  - 일련의 처리를 하나로 모아 언제든 호출될 수 있도록 만들어 둔 것
  - 함수의 입력값: 인수
  - 함수 정의문의 인수: 인자(Parameter)
  - 함수의 출력값: 반환값

- **함수의 정의: `function`**

  ```javascript
  // x 인수를 넣으면 x 인수 값 만큼 곱한 값을 출력하는 함수 
  function square(x){
  	return x * x;	
  }
  ```

  - **함수 반환값 작성시 주의점** 

    ![https://github.com/sis92345/TIL/blob/master/Java/png/jsFunction.jpg]()

    - return과 return할 값이나 표현식 사이에 줄 바꿈 문자가 들어가면 다음과 같이 인식한다.

      ```javascript
      ///////////////////////////////작성한 코드
      return 
      x * x;
      ///////////////////////////////내가 의도한 코드
      return x * x;
      ///////////////////////////////엔진이 작성한 코드
      return;
      x * x;
      
      ```

- 함수의 기본적인 규칙

  1. 함수이름

     - 모든 식별자를 사용할 수 있다.
     - 함수 이름은 캐멀 표기법이나 밑줄 표기법을 권장

  2. 함수 호출

     - 함수 이름뒤에 소괄호를 묶어 입력

       ```javascript
       square(3); //square 함수에 3 인수를 넣어서 호출
       ```

  3. 인수

     - 함수는 인수를 여러개 사용할 수 있다.
     - 인수를 받지 않은 함수도 정의 가능