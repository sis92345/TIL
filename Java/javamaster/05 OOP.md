[객체지향 프로그래밍 Ⅰ.md](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b81902f0-c58d-4ba8-a41b-873d2cac2ba2/%E1%84%80%E1%85%A2%E1%86%A8%E1%84%8E%E1%85%A6%E1%84%8C%E1%85%B5%E1%84%92%E1%85%A3%E1%86%BC_%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%80%E1%85%B3%E1%84%85%E1%85%A2%E1%84%86%E1%85%B5%E1%86%BC_.md)

# 1. 객체지향언어

<aside>
👌🏻 객체지향의 기본 개념은 “실제 세계는 **사물(객체)**로 이루어져 있으며, 발생하는 모든 사건들은 **사물들의 상호작용**이다” 라는 것이다

</aside>

## 1-1. 객체지향언어는 아래 이유때문에 사용한다.

1. **코드의 재사용성이 높다**
2. **코드의 관리가 용이하다**
3. **신뢰성이 높은 프로그래밍을 가능하게 한다**

# 2. 클래스와 객체

클래스와 객체는 설계도와 설계도로 만든 제품으로 비유할 수 있다. 클래스는 단지 설계도이며 실제 사용되지는 않는다.

<aside>
👌🏻 Class : 클래스란 객체를 정의해 놓은 것이다. 객체를 생성하는데 사용된다
좀더 어려운 표현으로 객체지향에서 추상화를 직접 구현한 것

</aside>

<aside>
👌🏻 Object : 실제로 존재하는 사물 또는 개념으로 Class에 정의된 기능과 속성에 따라 용도가 다르다. 객체는 정의된 클래스로 부터 생성된다.
- 유형 : TV, 자동차
- 무형 : 수학 공식, 논리 등

</aside>

## 2-1. 객체와 인스턴스

1. 클래스에서 객체를 만드는 것을 **인스턴스화 (Instantiate)** 라고 한다.
2. **어떤 클래스로 부터 만들어진 객체를 인스턴스** 라고 한다

   ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0b71418d-459a-42cc-9587-54370cb6bc4c/Untitled.png)


## 2-3. 객체의 구성 요소

객체는 속성과 기능으로 구성된다

<aside>
👌🏻 속성 : **Member Variable**, Attribute, Field, State

</aside>

<aside>
👌🏻 기능 : **Method**, Function , behavior

</aside>

- 속성 (멤버 변수)와 기능 (메소드)으로 이루어진 클래스

    ```java
    package java.operator;
    
    public class TV {
    		
    		/** Member */
    		
    		private final String color; 		// TV 색상
    		private boolean power;  	// 전원
    		private int 	channel;	// 채널
    		
    		public TV( String color ) {
    				this.color = color;
    				this.power = false;
    				this.channel = -1;
    		}
    		
    		/** METHOD */
    		
    		/**
    		 * TV 전원을 킵니다.
    		 * */
    		public void powerOn () {
    				this.power = true;
    		}
    		
    		/**
    		 * TV 전원을 킵니다.
    		 * */
    		public void powerOff () {
    				this.power = false;
    		}
    		
    		/**
    		 * 채널을 돌립니다.
    		 *
    		 * @param channel
    		 * */
    		public void setChannel( int channel ) {
    				
    				if ( !this.power ) {
    						System.out.println( "전원을 켜주세요" );
    				}
    				
    				this.channel = channel;
    		}
    		
    		public String getColor() {
    				return color;
    		}
    }ß
    ```


## 3-2. 인스턴스의 유의점

1. **인스턴스는 참조변수를 통해서만 다룰 수 있다. 참조변수의 타입은 인스턴스의 타입과 일치해야 한다.**

```java
@Test
@DisplayName( "클래스로 객체를 만들기 위해서 new를 생성한다." )
void INSTANTIATE_TEST () {
		
		// 1. TV 인스턴스는 0x001에 생성되고 blackTV 변수에 참조값이 저장된다.
		// 2. 각 멤버 변수는 초기값으로 할당된다.
		TV blackTV = new TV( "Black" );
		
		Assertions.assertThat( blackTV.getColor() ).isEqualTo( "Black" );
}
```

1. **모든 인스턴스는 참조형이므로 각 인스턴스의 멤버변수는 독립적으로 사용할 수 있다.**

```java
@Test
@DisplayName( "모든 인스턴스는 참조형이므로 각 인스턴스의 멤버변수는 독립적으로 사용할 수 있다." )
void MULTY_INSTNACE () {
		
		// 1. TV 인스턴스는 0x001에 생성되고 blackTV 변수에 참조값이 저장된다.
		// 2. 각 멤버 변수는 초기값으로 할당된다.
		TV blackTV = new TV( "Black" );
		TV whiteTV = new TV( "White" );
		
		Assertions.assertThat( whiteTV.getColor() ).isNotEqualTo( "Black" );
}
```

```java
@Test
@DisplayName( "참조형 이므로 덮어쓰기 가능" )
void INSTANCE_TEST3 () {
		
		TV blackTV = new TV( "Black" );
		TV whiteTV = new TV( "White" );
		
		// whiteTV는 GC에 의해 정리
		whiteTV = blackTV;
		
		Assertions.assertThat( whiteTV.getColor() ).isEqualTo( "Black" );
}
```

# 4. 변수

<aside>
👌🏻 변수의 종류
1. **클래스 변수** ( Class Variable ) : 클래스 영역에 선언되며 클래스가 메모리에 올라갈 때 생성
2. **인스턴스 변수** ( Instance Variable ) : 클래스에 영역에 선언되며 인스턴스 생성 시 생성
3. **지역 변수** ( Local Variable ) : 클래스 영역 이외에서 변수 선언문이 수행되었을 때 생성

</aside>

- 참고 1 : 클래스 영역과 클래스 이외의 영역

    ```java
    package oopbasic;
    
    public class Card {
    		
    		/**
    		 * 클래스 영역
    		 * */
    		
    		/** 인스턴스 변수 */
    		Kind 					kind;			// 무늬
    		int 					number;			// 수
    		
    		/** 클래스 변수 */
    		static int width 		= 100;
    		static int height 		= 250;
    		
    		{
    				// 초기화 블록
    				kind = Kind.SPACE;
    				number += 1;
    				
    				
    				if ( kind.equals( Kind.SPACE ) ) {
    						
    						// 지역 변수
    						int val = 7;
    						number+=val;
    				}
    		}
    		
    		
    		String getCard() {
    				
    				// 지역 변수
    				int val = 2;
    				return kind + " / " + ( number + val );
    		}
    }
    ```


## 4-1. Instance Variable

클래스에 영역에 선언되며 인스턴스 생성 시 생성된다.

인스턴스는 독립된 저장공간을 가지므로 인스턴스마다 다른 값을 가질 수 있다.

### 4-1-1. Instance Variable Initialization

**인스턴스 변수는 초기화를 하지 않아도 된다. 인스턴스 변수는 자동으로 초기화가 가능하다.**

| 자료형 | 기본값 |
| --- | --- |
| boolean | false |
| char | ‘\u0000’ |
| byte , short, int | 0 |
| long | 0L |
| float | 0.0f |
| double | 0.0d, 0.0 |
| 참조형 변수 | null |

인스턴스 변수를 별도로 초기화 하고 싶다면 아래 3가지 방법으로 가능하다

1. 명시적 초기화 ( Explicit Initialization ) : 변수를 선언과 동시에 초기화 하는 것

2. 초기화 블럭 ( Initialization Block ) : 인스턴스 / 클래스 초기화 블록이 있다. 각 변수의 복잡한 초기화에 사용한다.

3. 생성자 ( Constructor ) : 인스턴스를 생성할 때 호출된다.

- 위 초기화의 예제

    ```java
    package oopbasic;
    
    import oopbasic.overload.DateUtil;
    
    import java.time.Instant;
    import java.util.Date;
    
    /**
     * 멤버 변수의 3가지 초기화 방법
     * */
    public class InitializationOfMember {
    		
    		// 1. 암묵적
    		int implicitVar;
    		
    		// 2. 명시적
    		int explicitVar = 33;
    		Card card = new Card();
    		
    		// 3-1. 초기화 블록 : 클래스
    		static String staticVar;
    		
    		static {
    				
    				String today = DateUtil.getCurrentDate();
    				
    				staticVar = today.isEmpty() ? Date.from( Instant.now() ).toString() : today;
    		}
    		
    		// 3-2. 초기화 블록 : 인스턴스
    		String memberBar;
    		
    		{
    				memberBar = "String";
    		}
    		
    		// 4. 생성자
    		String initByConstructor;
    		
    		public InitializationOfMember( String initByConstructor ) {
    				
    				this.initByConstructor = initByConstructor;
    		}
    }
    ```


### 4-1-2. 변수의 초기화 순서

| 클래스 초기화 | 클래스 초기화 | 클래스 초기화 | 인스턴스 초기화 | 인스턴스 초기화 | 인스턴스 초기화 | 인스턴스 초기화 |
| --- | --- | --- | --- | --- | --- | --- |
| 기본값 | 명시적 초기화 | 클래스 초기화 블럭 | 기본값 | 명시적 초기화 | 인스턴스 초기화 블록 | 생성자 |
| static int val = 0; | static int val = 1; | static int val = 2; | static int val = 0;
String str = null; | static int val = 0;
String str = “test”; | static int val = 0;
String str = “test2”; | static int val = 0;
String str = “white”; |

## 4-2. Class Variable

`static` 키워드를 붙인 인스턴스 변수이다. 클래스 변수는 클래스가 메모리에 올라올 때 JVM의 Method Area에 올라온다. 이 값은 공통된 값으로 모든 인스턴스에서 공통된 값을 가지지만, 모든 쓰레드에서 접근할 수 있기 때문에 쓰레드에 안전하지 못하다.

```java
/** 클래스 변수 */
static int width 		= 100;
static int height 		= 250;
```

- 참고 2 : 메소드 영역

  ## **Method Area ( = static area )**

  **인스턴스 생성을 위한 객체 구조, 생성자, 필드등이 저장**됩니다. *Runtime Constant Pool* 과 *static* 변수, 그리고 메소드 데이터와 같은 *Class* 데이터들도 이곳에서 관리가 됩니다. *즉 Method Area는 메타 데이터를 저장하는 공간*이라고 할 수 있으며 따라서 모든 Thread는 하나의 Method Area를 공유합니다.

    - **메서드 영역은 여러 스레드에 대한 메모리를 공유하므로 저장된 데이터는 스레드로부터 안전하지 않습니다.**
    - Method Area는 JVM당 하나만 생성됩니다.
    - static 키워드를 붙인 필드나 메소드도 여기에 올라갑니다. 그래서 static 변수는 어디서나 접근이 가능합니다.

  *JVM* 의 다른 메모리 영역에서 해당 정보에 대한 요청이 오면, 실제 물리 메모리 주소로 변환해서 전달해줍니다. 기초 역할을 하므로 ***JVM* 구동 시작 시에 생성이 되며, 종료 시까지 유지되는 공통 영역**입니다.

  아래는 Method Area에 저장되는 정보입니다.

    1. `Type Information`
        - Type의 전체 이름 (패키지명 + 클래스명)
        - Type의 직계 하위 클래스 전체 이름
        - Type의 클래스 / 인터페이스 여부
        - Type의 modifier (public / abstract / final)
        - 연관된 인터페이스 이름 리스트
    2. `Runtime Constant Pool`
        - Type, Field, Method로의 모든 Symbolic Reference 정보를 포함
        - Constant Pool의 Entry는 배열과 같이 인덱스 번호를 통해 접근
        - Object의 접근 등 모든 참조를 위한 핵심 요소
    3. `Field Information`
        - Field Type
        - Field modifier (public / private / protected / static / final / volatile / transient)
    4. `Constructor를 포함한 모든 Methods`
        - Method Name
        - Method Return Type
        - Method Parameter 수와 Type
        - Method modifier (public / private / protected / static / final / syncronized / native / abstract) Method 구현 부분이 있을 경우 ( abstract 또는 native 가 아닐 경우 )
        - Method의 byteCode
        - Method의 Stack Frame의 Operand Stack 및 Local variable section의 크기
        - Exception Table
    5. `Class Variable`
        - static 키워드로 선언된 변수
        - 이 변수는 인스턴스의 것이 아니라 클래스에 속하게 된다.

실제로 클래스 변수는 수정 시 모든 클래스의 값이 변경되는 것을 알 수 있다.

```java
@Test
@DisplayName( "클래스 변수는 한번 메소드 영역에 올라온 후 모든 인스턴스에서 접근이 가능하다" )
void CLASS_VARIABLE () {
		
		Card space = new Card();
		Card dia   = new Card();
		
		dia.setKind( Kind.DIAMOND );
		
		// 인스턴스 변수는 변경해도 인스턴스의 변수만 변경된다.
		Assertions.assertThat( space.kind ).isNotEqualTo( dia.kind );
		
		space.width = 10000;
		
		Assertions.assertThat( dia.width ).isEqualTo( 10000 );
}
```

## 3-3. Local Variable

메소드, 초기화 블록, 생성자 내부에서 사용되는 변수이다. 블록을 벗어나면 사용하지 못한다.

```java
String getCard() {
		
		// 지역 변수 : val은 이 블록을 벗어나면 사용하지 못한다.
		int val = 2;
		return kind + " / " + ( number + val );
}
```

# 5. 메소드

메소드 ( Method ) **특정 작업을 수행하는 일련의 문장을 하나로 묶을 것이다.**

메소드는 다음의 이유때문에 사용한다.

1. **높은 재사용성** : 한번 만들어진 메소드는 재사용이 가능하다.
2. **중복된 코드의 제거** : 같은 문장을 메소드로 묶어서 중복을 최소화한다.
3. **프로그램의 구조화** : 패턴 가능

## 5-1. 메소드의 선언

```java
{접근자} [반환타입] [메소드 이름] ( 타입 변수 명 ) {
	// ...메소드 코드 구현
	return [반환타입]
}
```

```java
접근자   반환타입 메소드 이름
public String getCard() {
		 
		// Return문은 메소드를 종료하고 호출부로 되돌아 간다.
		return kind + " / " + ( number + 2 );
}

public void setCard( Kind kind ) {
		 
		this.kind = kind;
}
```

## 5-2. 메소드의 호출

```java
[메소드 이름] ( 파라메터1 , 파라메터2 );
```

```java
space.setCard( Kind.space );

Kind target = space.getCard();
Kind reference = dia.getCard();

Assertions.assertThat( target ).isNotEqualTo( reference );
```

## 5-3. 기본형 매개변수와 참조형 매개변수

<aside>
👌🏻 매개 변수
1. 기본형 매개변수 : 변수의 값을 읽기만 할 수 있다.
2. 참조형 매개변수 : 변수의 값을 읽고 쓸 수 있다.

</aside>

예를 들어 아래 메소드에서 값을 변경하면

```java
public void toDiamond ( int a , Card b ) {
		
		a = 10;
		b.setKind( Kind.DIAMOND );
}
```

기본형은 그대로, 참조형은 값이 변경된다.

- 기본형은 지역변수로 스택에서 생성된 후 메소드가 종료되면 변경된 지역변수는 스택에서 나오므로 변경이 안된다.
- 참조형은 객체의 주소를 말한다. **반환타입이 참조형 이라는 것은 객체의 주소를 반환한다는 것을 의미한다.**

```java
@Test
@DisplayName( "기본형 파라메터는 읽기만, 참조형 파라메터는 읽기 쓰기 가능" )
void PARAMETER_TYPE_TEST () {
		
		Card space = new Card();
		space.setKind( Kind.SPACE );
		
		Card heart = new Card();
		heart.setKind( Kind.HEART );
		
		int target = 0;
		
		heart.toDiamond( 0 , space );
		
		// 기본형은 읽기만
		Assertions.assertThat( target ).isEqualTo( 0 );
		
		// 참조형은 읽기 + 쓰기
		Assertions.assertThat( space.getKind() ).isEqualTo( Kind.DIAMOND );
}
```

## 5-4. Class Method와 인스턴스 메소드

<aside>
💡 `static` 키워드가 붙은 메소드는 클래스 메소드드로 객체를 생성하지 않고 사용이 가능하다.

</aside>

<aside>
💡 하기의 경우 클래스 메소드로 생성할 것을 고려한다.
1. **모든 인스턴스에 공통적으로 사용하는 메소드일 경우**
2. **인스턴스 변수를 사용하지 않을 경우 : 성능 상 유리**

</aside>

```jsx

public **static** Kind getKind ( String kind ) {
		
		return Kind.valueOf( kind );
}

//... Test
@Test
@DisplayName( "Class Method는 메소드 영역에 올라오므로 바로 사용이 가능하다, 하지만 인스턴스 변수는 인스턴스를 생성해야 사용이 가능하다/" )
void CLASS_METHOD () {
		
		Kind kind = Card.getKind( "DIAMOND" );
		
		Card card = new Card();
		
		card.setKind( Kind.HEART );
		
		assertThat( kind ).isEqualTo( Kind.DIAMOND );
		
		assertThat( card.getKind() ).isEqualTo( Kind.HEART );
}

```

따라서 클래스 메소드는 특별한 규칙이 있다.

1. 클래스 변수는 인스턴스를 생성하지 않아도 사용할 수 있다.

    ```java
    Kind kind = Card.getKind( "DIAMOND" );
    ```

2. 클래스 메소드는 인스턴스 변수를 사용할 수 없다.
    - static이 붙을 경우 JVM 로드 시 static이 붙은 메소드, 변수 등을 메소드 영역에 로드한다. 따라서 클래스 메소드가 올라갈 시점에는 인스턴스가 없으므로 참조할 수 없다.
    - 하지만 반대로 인스턴스 메소드에서는 이미 클래스 메소드가 생성된 시점이므로 인스턴스 메소드 내부에서는 클래스 메소드 / 변수를 사용할 수 있다.

    ```java
    public static Kind getKind ( String kind ) {
    
    	/**
    	 * 클래스 메소드에서 인스턴스 변수를 사용할 수 없다.
    	 * 'oopbasic.Card.this' cannot be referenced from a static context
    	 * */
    	// this.setKind( Kind.HEART );
    	
    	
    	return Kind.valueOf( kind );
    }
    ```


# 6. JVM 메모리 구조

개인적으로 정리한 사항 참고

Call Stack은 이 아래 문서에 있는 Stack을 함께 참조할 것

[What and where are the stack and heap?](https://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)

[[JVM Internal] JVM 메모리 구조](https://12bme.tistory.com/382)

[TIL/JVM.md at master · sis92345/TIL](https://github.com/sis92345/TIL/blob/master/Java/JVM.md)

# 7.  Overroading

<aside>
💡 한 클래스에서 같은 이름의 메소드를 여러개 선언하는 것
오버로딩을 사용하면 한 클래스에서 동일한 이름을 갖는 메소드를 여러개 선언할 수 있다.

</aside>

오버로딩을 사용하기 위해서는 하기 조건을 만족해야 한다.

<aside>
💡 1. **메소드 이름이 같아야 한다**
2. **매개 변수의 개수 또는 타입이 다르다.**

</aside>

메소드가 다르면 그건 오버로딩이 아니라 그냥 다른 메소드이다.

## 7-1. 왜 오버로딩을 사용하는가

오버로딩은 메소드를 확장하여 메소드의 다형성을 구현할 수 있다. 오버로딩을 지원하는 언어는 하나의 메소드가 하는 역할을 타입별로 기능을 확장 할 수 잇다.

JavaScript(이하 JS)의 경우 오버로딩을 지원하지 않는다. 그래서 JS에서 오버로딩처럼 사용하기 위해서는..

1. 타입으로 구분 한 후 타입별로 메소드를 호출
    - EX

        ```java
        
        /**
         * 전달 받은 시간을 특정Format으로 변환합니다.
         *
         * @param {any} date - 현재 날짜
         * */
        const getDate = function ( date ) {
        	
        	const dateType = typeof date;
        	if ( dateType === "string" ) {
        		return getDateByString( date );
        	}
        	else if ( dateType === "number" ) {
        		return getDateByTimeStamp( date );
        	}
        	else {
        		return getDateByString( date );
        	}
        }
        ```

2. deault Parameter 활용
3. 그냥 때려박기

하지만 오버로딩을 사용하면 7-2의 예 처럼 같은 메소드 이름으로 다른 타입에 따른 다른 메소드를 부를 수 있다.

**즉 오버로딩을 사용하면 같은 이름을 사용하여 다른 함수를 호출할 수 있다.** 따라서 오버로딩된 메소드들은 모두 같은 논리를 지닐 수 있다. 아래처럼 getCurrentDate는 오늘 날짜를 반환한다는 기본적인 형식을 논리를 공유할 수 있다.

오버로딩이 가지는 장점이다.

1. 메소드 이름 절약 가능
2. 가독성 상승

오버로딩이 사용되는 경우는 크게 아래 2가지 경우이다.

1. 기본값 지정
2. **매개 변수 타입에 따른 다른 메소드 행위 정의**
    - getCurrentDate → 메개변수가 없으면 기본 값을 노출하고 포멧이 있으면 포멧으로 현재 날짜를 반환한다.
3. **매개 변수 타입에 따른 다른 메소드 행위 정의**
    - getCurrentDate → 메개변수가 없으면 기본 값을 노출하고 포멧이 있으면 포멧으로 현재 날짜를 반환한다.

## 7-2. 오버로딩의 예

```java
package oopbasic.overload;

public class DateUtil {
		
		/**
		 * 현재 날짜를 반환합니다.
		 *
		 * */
		public static String getCurrentDate () {
				return LocalDateTime.now().toString();
		}
		
		/**
		 * 현재 날짜를 반환합니다.
		 *
		 * */
		public static String getCurrentDate ( DateTimeFormatter dateTimeFormatter ) {
				return LocalDateTime.now().format( DateTimeFormatter.ISO_DATE_TIME );
		}
		
		/**
		 * 지정한 날짜를 반환합니다.
		 *
		 * */
		public static String getDate () {
				return DateUtil.getCurrentDate();
		}
		
		/**
		 * 지정한 날짜를 반환합니다.
		 *
		 * */
		public static String getDate ( int ...format ) {
				return LocalDateTime.of( format[0] , format[1] , format[2] , format[3] , format[4]).toString();
		}
		
}
```

- 사용

    ```java
    @Test
    @DisplayName( "오버로딩 기초" )
    void OVERLOAD_TEST () {
    		
    		String now 			= DateUtil.getCurrentDate();
    		String nowFormat	= DateUtil.getCurrentDate( DateTimeFormatter.ISO_DATE );
    		
    		String date			= DateUtil.getDate();
    		String fixDate		= DateUtil.getDate( 2022 , 10 ,27 , 23 , 21 );
    }
    ```


## 7-3. 가변인자 메소드의 오버로딩시 주의

가변인자를 사용하는 메소드는 가변인자의 타입과 같은 또다른 인자가 있다면 논리적으로 같기때문에 컴파일 오류를 발생시킨다. **따라서 가변인자를 사용하는 메소드는 오버로딩 하지 않는 것이 좋다.**

```java
/**
 * 지정한 날짜를 반환합니다.
 * */
public static String getDate( int getMonth , int ...format ) {
		
		return LocalDateTime.of( format[0] , format[1] , format[2] , format[3] , format[4]).withDayOfYear( getMonth ).toString();
}
/**
 * 지정한 날짜를 반환합니다.
 * @param format
 * */
public static String getDate ( int ...format ) {
		return LocalDateTime.of( format[0] , format[1] , format[2] , format[3] , format[4]).toString();
}
```

```java
java: reference to getDate is ambiguous
  both method getDate(int,int...) in oopbasic.overload.DateUtil and method getDate(int...) in oopbasic.overload.DateUtil match
```

# 8. 생성자 ( Constructor )

**인스턴스 생성 시 호출되는 인스턴스 초기화 메서드이다.**

인스턴스의 생성 과정은..

1. `new` 연산자로 인스턴스 생성
2. 생성자 호출
3. 인스턴스 참조값이 참조 변수에 저장

## 8-1. 생성자의 사용

<aside>
👌🏻 1. 생성자는 **클래스 이름과 같아야 한다**
2. 생성자는 **리턴값이 없다**

</aside>

```java
package oopbasic;

public class TV {
		
		/** Member */
		
		private final String color; 		// TV 색상
		private boolean power;  	// 전원
		private int 	channel;	// 채널

		// 기본 생성자
		public TV() {
				this.color = "Not Use";
				this.power = false;
				this.channel = -1;
		}
		
		// 생성자 클래스 이름과 같고 리턴값이 없다
		public TV( String color ) {
				this.color = color;
				this.power = false;
				this.channel = -1;
		}
		//... 생략
}
```

## 8-2. 기본 생성자 ( Default Constructor )

모든 클래스는 생성자를 가지고 있다. **생성자를 코드 상에서 정의하지 않으면 컴파일러가 자동으로 생성한다.**

**단 생성자가 하나라도 존재하면 기본 생성자는 생성되지 않는다.**

```java
클래스이름() {}
```

```java
@Test
@DisplayName( "생성자를 만들지 않아도 기본 생성자는 만들어 진다." )
public void DEFAULT_CONSTRUCTOR_TEST () {
		
		TV notUse = new TV();
		
	 	Assertions.assertThat( notUse.getColor() ).isEqualTo( "Not Use" );
}
```

## 8-3. 매개변수가 존재하는 생성자

생성자도 매개변수를 선언하여 인스턴스 생성시 지정한 값으로 초기화 작업을 수행할 수 있다.

```java
// 생성자 클래스 이름과 같고 리턴값이 없다
public TV( String color ) {
		this.color = color;
		this.power = false;
		this.channel = -1;
}

// 생성자 클래스 이름과 같고 리턴값이 없다
public TV( String color , boolean power ) {
		this.color = color;
		this.power = power;
		this.channel = -1;
}

// 생성자 클래스 이름과 같고 리턴값이 없다
public TV( String color , boolean power , int channel ) {
		this.color = color;
		this.power = power;
		this.channel = channel;
}
```

```java
@Test
@DisplayName( "매개변수가 존재하는 생성자" )
public void PARAMETER_CONSTRUCTOR_TEST () {
		
		TV blackTV = new TV( "black" );
		TV powerOnTV  = new TV( "blue" , true , 7 );
		TV kbsTV  = new TV( "blue" , true , 7 );
		
		Assertions.assertThat( blackTV.getColor() ).isEqualTo( "black" );
		Assertions.assertThat( powerOnTV.getPower() ).isTrue();
		Assertions.assertThat( kbsTV.getChannel() ).isEqualTo( 7 );
}
```

## 8-4. 생성자에서 생성자 호출 : this

```java
// 생성자 호출
this( "Parameter" );

this()
```

```java
public Card() {
				
		this( Kind.DIAMOND , 3 );
}

public Card( Kind kind ) {
		
		this( Kind.SPACE , 3 );
}

public Card( Kind kind , int number ) {
		this.kind = kind;
		this.number = number;
}
```

# — 참고