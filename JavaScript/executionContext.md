# 실행 컨텍스트

### 1. 실행 컨텍스트의 개념과 소스 코드 타입

- <u>자바스크립트의 동작원리를 담은 핵심 개념</u>

  - 실행 컨텍스트는 다음의 구조로 이루어져 있다.
    - Lexical Environment : 소스코드의 스포크와 식별자를 관리 , 상위 스코프 참조를 기록
    - 실행 컨텍스트 스택(콜스택) : 코드의 실행 순서를 관리
  - 실행 컨텍스트를 이해하면 자바스크립트의 개념 중 다음을 이해할 수 있다
    - 호이스팅
    - 클로저 동작 방식
    - 비동기 처리 동작 방식
    - 스코프 기반 식별자 관리 방식

- 소스코드 타입 : 실행 컨텍스트를 이해하기 위해서는 ECMAScript에서 정의한 소스코드 타입을 알아야 한다 : 각 소스코드마다 실행 컨텍스트를 실행하는 과정이 다르기때문이다.

  - **`Global code`** : 전역에 존재하는 소스 코드 , 전역에 정의된 함수 , 클래스의 내부 코드는 포함 X
    - 전역변수를 관리하는 최상위 스코프인 전역 스코프를 생성한다.
  - **`function code`** : 함수 내부의 소스 코드 , 함수 내부의 중첩 함수 , 클래스는 포함 X
    - 함수 내부의 지역 스코프를 생성
      - 지역 변수 , 매개변수 , argument 객체를 관리
    - 생성된 지역 스코프는 전역 스코프에서 시작하는 스코프 체인의 일원으로 연결
  - **`eval code`** : eval 함수에 인수로 전달되어 실행되는 소스코드
  - **`module code`** : 모듈 내부에 존재하는 소스코드

- 아래 예제에서 각 소스코드를 볼 수 있다.

  ```javascript
  // 전역 소스 코드 : x , y , plus() -> golbal code의 전역 스코프에 등록
  const x = 100;
  const y = 111;
  
  function plus(){
    //plus 함수의 function code : x , y -> function code 지역 스코프에 등록
    const x = 0;
    const y = 1;
  	
    console.log( x + y );	//1
  }
  
  plus();
  
  console.log( x + y ); //211
  
  ```

  

### 2. 소스코드의 평가과 실행

- 모든 소스코드는 코드 평가를 한 후 코드 실행을 위한 준비를 한다 :  <u>자바스크립트 엔진은 소스코드를 평가하는 과정 , 실행하는 과정을 나누어서 처리한다.</u>

  1. **소스코드의 평가 과정**

     - 실행 컨텍스트를 생성

     - 변수 , 함수 등의 **선언문**을 실행
       - 즉 `let x = 0;`이라는 코드를 평가과정에서 `let x;`로 먼저 선언한다고 보면 편하다,

       - 해당 변수와 선언문을 실행 컨텍스트가 관리하는 스코프에 키로 등록한다

  2. **소스코드의 실행 과정**

     - 소스코드의 평가 과정이 끝나면 선언문을 제외한 소스코드가 순차적으로 실행 : 런타임

     - 선언된 변수는 소스코드의 평가 과정에서 생성한 실행 컨텍스트의 스코프에서 참조해서 사용한다.
       - `let x = 0;`이 선언되었다면 소스코드의 평가 과정에서 `let x;`가 선언되고 소스코드의 실행 과정에서 선언문을 만나면 그 때 x라는 변수를 실행 컨텍스트의 스코프에서 참조하여 0을 할당하는 방식이다. 즉 `x = 0;`만 선언된다고 보면 편하다.

<img width="616" alt="실행 컨텍스트의 과정" src="https://user-images.githubusercontent.com/68282095/134183414-bec58304-8d4b-42ec-8a9d-42bc1d27b7b1.png">

- 예

  - 아래 코드가 어떤 순서로 실행될까?

  ```javascript
  const x = 100;
  const y = 111;
  
  function plus(){
    const x = 0;
    const y = 1;
  	
    console.log( x + y );
  }
  
  plus();
  
  console.log( x + y );
  ```

  1. 전역 코드 평가

     - 전역코드에 선언된 선언문을 먼저 실행한다. 따라서 아래와 같은 결과가 실행된다.

       ```javascript
       const x;
       const y;
       
       function plus(){}
       ```

     - 전역 코드에 선언된 x , y와 선언문 plus가 실행 컨텍스크가 관리하는 전역 스코프에 등록

  2. 전역 코드 실행

     - 전역 코드가 실행된다. 변수 할당문에 도달하면 해당 변수를 실행 컨텍스트의 전역 스코프에서 참조해서 값을 할당한다.
     - 이때 함수가 호출되면 전역 코드 실행을 멈추고 함수 내부로 진입한다.

  3. 함수 코드 평가

     - 함수 내부의 지역 변수 선언문이 실행되고 실행 컨텍스트가 관리하는 지역 스코프에 등록된다.
     - 이때 arguments 객체와 this가 바인딩된다.

  4. 함수 코드 실행

     - 함수 코드를 실행한다.

  5. console.log 메소드의 실행

     - console 객체는 빌트인 객체로 전역 스코프에 바인딩되어 있다. **즉 console 객체를 사용하기 위해서는 지역 스코프가 상위 스코프와 연결되어야만 사용할 수 있다.**
     - 그 다음 실행 결과는 다음과 같다
       1. 스코프 체인으로 전역 스코프의 console을 검색
       2. 프로토타입 체인으로 log메소드를 실행
       3. 스코프 체인을 이용해서 log 메소드의 파라메터로 지역 스코프에 선언된 `x + y`를 참조한다.

- 위 예제에서 중요한 점은 코드가 실행되기 위해서는 스코프 , 식별자 , 실행 순서의 관리가 필요하다는 점이다.

  - 선언에 의해 생성된 모든 식별자( 변수 , 클래스 , 함수 등 )를 스코프별로 등록하고 상태관리를 지속적으로 관리할 수 있어야 한다,
  - 스코프는 중첩 관계에 의해 스코프 체인을 형성해야 한다. 즉 스코프에서 다른 스코프로 검색이 가능해야 한다.
  - 현재 실행중인 코드의 실행 순서를 변경할 수 있어야 하며 되돌아갈 수 있어야 한다.

### 3. 실행 컨텍스트 실행 (콜스택)

- 위 예제에서 전역코드를 실행하고 함수를 만나면 함수 코드를 평가한 후 함수 실행 컨텍스트를 실행한다. 즉 위의 예제에서 생성되는 실행 컨텍스트는 2개이다

  - 전역 컨텍스트
    - scope
      - x
      - y
      - plus()
  - plus 함수 컨텍스트
    - scope
      - x
      - y

- 이렇게 동시에 생성되는 **실행 컨텍스트는 실행 컨텍스트 스택에서 관리한다.** 

  - 스택 구조이므로 `FILO`이다, 

  - 코드를 실행하는 과정에서 실행 컨텍스트를 생성할 필요가 있으면 실행 컨텍스트를 생성한 뒤 push한다. 해당 코드가 종료된다면 실행 컨텍스트는 pop되며 제어권을 본래 실행 컨텍스트로 옮긴다.

  - 예 : 전역 코드에 foo 함수가 선언 , foo 함수 내부에 중첩 함수로 bar 함수가 선언

    <img width="704" alt="실행 컨텍스트 스택" src="https://user-images.githubusercontent.com/68282095/134189026-334d9610-8a74-4928-95ae-6c3b7648690d.png">

### 4. Lexical Environment

- 실행 컨텍스트를 구성하는 자료구조이다. key와 value 구조이다.
- Lexical Environment의 목적
  - 스코프를 구분
  - 스코프의 식별자를 등록, 관리
  - 상위 스코프를 참조
- 실행 컨텍스트의 구조
  - Lexical Environment
    - EnvironmentRecord : 환경 레코드 , 스코프에 포함된 식별자를 등록하고 등록된 식별자에 바인딩된 값을 관리하는 저장소
      - 전역 코드일 경우
        - Object Environment Record : 객체 환경 레코드 , `var`로 선언한 변수와 함수 선언문으로 정의된 전역 함수를 Object Environment Record의 Binding Object를 통해 전역 객체의 프로퍼티와 메소드로 정의
          - 그래서 `var` 키워드로 선언한 변수를 `window` 객체의 프로퍼티로 조회할 수 있는 것
      - Declarative Environment Reocrd : 선언적 환경 레코드 , let , const로 선언된 전역 변수를 관리
        - 그래서 let , const로 선언한 객체를 `window` 로 조회할 수 없는 것
    - 함수일 경우
      - function Lexical Environment : 함수의 매개변수 , argument , 함수 내부의 지역 변수를 관리
      - this 바인딩
        - [ThisValue[]] 내부 슬롯에 this가 바인딩 함수 호출방식에 따라 다르나 일반 함수의 경우 this는 전역 객체를 가르킨다.
    - OuterLexicalEnviromentReference : 외부 렉시컬 환경에 대한 참조 , 상위 스코프를 가르킨다.
  - VariableEnviroment

- 아래는 실행 컨텍스트 실행의 예제이다, 생성될 때 임을 유의해야한다. 실제 코드 실행시 변수에 값이 할당된다. 이때 `var`키워드 변수는 선언과 초기화가 동시에 이루어져 `undefined`가 할당되며 , `let`과 `const`로 선언된 변수는 초기화 작업을 하지 않으므로 할당 전까지 TDZ가 생긴다.

  <img width="750" alt="실행 컨텍스크 개요" src="https://user-images.githubusercontent.com/68282095/134194987-fda2a668-9943-4123-a59b-b06b979dc2b1.png">

  - 전역 코드 : global Exection Context
    - Global Lexical Environment : 전역 실행 컨텍스트 , 코드 실행 시 가장 먼저 콜스택에 push
      - GlobalEnvironmentRecord
        - Object Environment Record : Binding Object로 전역 객체가 바인딩 , `var` 키워드로 선언된 변수와 함수 선언문이 전역 객체의 프로퍼티로 바인딩된다.
        - Declarative Environment Record : `let`, `const`키워드로 선언된 전역 변수가 바인딩
      - OuterLexicalEnvironmentReference : 전역 실행 컨텍스트 이므로 null
  - 함수 코드
    - foo Exection Context
      - foo Lexical Context
        - functionEnvironmentRecord
          - 지역 변수 , 중첩 함수 등 지역 스코프
        - OuterLexicalEnvironmentReference : Global Lexical Environment
    - bar
      - foo와 동일 단 OuterLexicalEnvironmentReference는 foo를 가르킴

### 5. 블록 레벨 스코프의 경우

- 다음의 코드를 살펴보자

  ```javascript
  let x = 0;
  
  if(true){
  	let x = 3;
  	console.log( x ); //3
  }
  
  console.log( x ); //0
  ```

- `let` , `const`의 경우 코드 블록을 지역 스코프로 인정하는 블록 레벨 스코프를 따른다. 

- 이를 위해서 실행 컨텍스트는 블록 레벨 스코프를 생성한다. if문을 만나면 블록 레벨 렉시컬 환경을 기존 Lexical Environment에 넣어서 대채한 뒤 outerLexicalEnvironmentReferenece로 기존 Lexical Environment를 할당한다. 블록이 끝나면 다시 이전의 렉시컬 환경으로 되돌린다.