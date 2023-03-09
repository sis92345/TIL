<aside>
🌐 지네릭스(Generics)는 다양한 타입의 객체들을 다루는 **메서드나 컬렉션 클래스에 컴파일 시의 타입 체크를 해주는 기능**이다.
- 장점
1. 타입 안전성을 제공한다.
2. 타입 체크와 형변환을 생략할 수 있으므로 코드가 간결해 진다.

</aside>

# 0. **제네릭이 등장하기 이전**

제네릭은 JDK 1.5에 등장하였는데, 제네릭이 존재하기 전에 컬렉션의 요소를 출력하는 메소드는 다음과 같이 구현할 수 있었다.

```java
void printCollection(Collection c) {
    Iterator i = c.iterator();
    for (k = 0; k < c.size(); k++) {
        System.out.println(i.next());
    }
}
```

하지만 위와 같이 컬렉션의 요소들을 다루는 메소드들은 타입이 보장되지 않기 때문에 문제가 발생하곤 했다. 예를 들어 컬렉션이 갖는 요소들의 합을 구하는 메소드를 구현했다고 하자.

```java
int sum(Collection c) {
    int sum = 0;
    Iterator i = c.iterator();
    for (k = 0; k < c.size(); k++) {
        sum += Integer.parseInt(i.next());
    }
    return sum;
}
```

문제는 위와 같은 메소드가 String처럼 다른 타입을 갖는 컬렉션도 호출이 가능하다는 점이다. String 타입을 갖는 컬렉션은 컴파일 시점에 문제가 없다가 런타임 시점에 메소드를 호출하면 에러가 발생하였다. 그래서 Java 개발자들은 타입을 지정하여 컴파일 시점에 안정성을 보장받을 수 있는 방법을 고안하였고, 그렇게 제네릭이 등장하게 되었다.

# 1. 지네릭스의 사용

<aside>
🌐 지네릭스는 클래스와 메서드에 타입변수(Type Variable)를 선언한다. 
**타입 변수는 임의의 참조형 타입을 말한다. 정해진 기호는 없고 보통 T, E를 암묵적으로 사용한다**

</aside>

<aside>
🌐 지네릭스 용어
class Wrapper<T>

Wrapper<T> : 지네릭 클래스
T : 타입 변수 또는 타입 매개변수
Wrapper : 원시 타입(raw type), 컴파일 후 클래스의 타입은 원시 타입으로 변경된다.

</aside>

1. 기본적인 메소드와 클래스에서 지네릭스의 사용

    ```java
    package generics;
    
    public class Wrapper<T> {
    		
    		T item;
    		
    		public T getItem() {
    				return item;
    		}
    		
    		public void setItem( T item ) {
    				this.item = item;
    		}
    }
    ```

2. 지네릭스의 사용 방법

    ```java
    @Test
    @DisplayName( "지네릭스의 기본적인 사용" )
    public void generics1() {
    		
    		// jdk 1.7 이전
    		Wrapper<String> str = new Wrapper<String>();
    		
    		// jdk 1.7 이후		
    		Wrapper<Integer> intWrapper = new Wrapper<>();
    
    		str.setItem( "test" );
    		
    		Assertions.assertThat( str.getItem() ).isInstanceOf( String.class );
    }
    ```

3. 제한된 지네릭스 클래스 : 타입 변수의 서브클래스만 대입 가능

    ```java
    // 제한된 지네릭 클래스
    Fruit<T extends Object>
    ```

4. 제한된 클래스와 인터페이스 구현 강제

    ```java
    Box<T extends Object & Cloneable>
    ```


## 1-1. 지네릭스의 제한

1. static 메소드에서 사용이 불가능하다.

    ```java
    // 지네릭스는 인스턴스 변수로 간주되므로 static에서 사용 불가
    public static T getType() {
    		return item.getClass();
    }
    ```

2. 지네릭스는 배열로 만들 수 없다.

    ```java
    public T[] getArray() {
    						
    						// new 연산자는 컴파일 시점에 타입을 알아야 하므로 지네릭스는 배열 생성 불가
    						// instanceof도 마찬가지 
    						// T[] tempArr = new T[3];
    						
    						return null;
    				}
    ```

3. 객체 생성시 타입변수는 무조건 같아야 한다. 단 지네릭 클래스가 상속관계이며 타입 변수가 같으면 가능

    ```java
    @Test
    @DisplayName( "타입 변수는 무조건 같아야 한다" )
    public void generics2() {
    		
    		// 두 타입은 같아야 한ㄷ,
    		//Fruit<String> fruit = new Fruit<Integer>();
    }
    
    @Test
    @DisplayName( "단 지네릭 클래스의 타입이 상속관계이머 타입 변수가 같을때는 가능" )
    public void generics3() {
    		
    		// 두 타입은 같아야 한ㄷ,
    		Fruit<String> fruit = new Apple<>();
    }
    ```

4. 단 타입변수의 서브클래스는 매개변수가 될 수 있다.

    ```java
    @Test
    @DisplayName( "타입변수가 상속관계일 경우 서브 클래스를 받을 수 있다." )
    public void generics4() {
    		
    		// 두 타입은 같아야 한다.
    		Fruit<Fruit> fruit = new Apple<>();
    		
    		fruit.setItem( new Apple<>() );
    		
    }
    ```


## 1-2. 지네릭 메서드

<aside>
🌐 메서드의 선언부에 지네릭 타입이 선언된 메서드를 지네릭 메서드라 한다.

</aside>

지네릭 메소드는 반환타입 앞에 지네릭 타입을 선언해서 사용한다. **지네릭 메소드의 타입 변수는 메소드 내에서만 사용되므로 static에서 사용이 가능하다.**

```java
static **<T>** Comparator<T> comparingLong(ToLongFunction<? super T> keyExtractor) {
        Objects.requireNonNull(keyExtractor);
        return (Comparator)((Serializable)((c1, c2) -> {
                return Long.compare(keyExtractor.applyAsLong(c1), keyExtractor.applyAsLong(c2));
        }));
}
```

```java
/**
 * 지네릭 메소드로 사용 : 지역 변수로 간주해서 사용 가능
 * */
public <T> String makeJuiceWithGenericMethod( Wrapper<? super T> item ) {
		return item.getItem().toString();
}
```

### 1-2-1. 지네릭 메소드의 사용

```java
@Test
@DisplayName( "지네릭 메소드의 사용" )
public void genericMehtod() {
		
		Juice<String> item = new Juice<>();
		
		Wrapper<Object> wrapper = new Wrapper<>();
		
		// 일반적인 지네릭 메소드의 사용
		item.<Fruit>makeJuiceWithGenericMethod( new Wrapper<Object>() );
		
		// 컴파일러가 타입 추론이 가능한 경우 : 위에 선언부에 이미 지네릭이 정의되어 있기 때문
		item.makeJuiceWithGenericMethod( wrapper );
		
}
```

### 1-2-2. Collections.sort() 분석

```java
public static <T extends Comparable<? super T>> void sort(List<T> list)
```

- sort 메소드는 Comparable을 구현한 List를 매개변수로 받는다는 의미이다.
    1. 타입 T를 요소로 하는 List를 매개 변수로 허용한다.
    2. 이때 타입 T는 Comparable을 구현한 요소여야 한다.
    3. 이때 Comparable은 타입 T와 그 부모 클래스만 비교하여야 하는 Comparable이어야 한다.

## 1-3. 지네릭의 형변환

1. 넌지네릭과 과 지네릭 타입간의 형변환 : 가능하나 경고
2. 다른 타입 변수간의 변환 : 절대 불가능
3. 상한,하한이 적용된 와일드 카드 타입과의 형변환

# 2. 와일드 카드

아래 코드를 보자, 타입 변수를 쓴다고 해서 Colleciton<Integer>가 Collection<Object>의 하위 타입이 아니다. 즉 지네릭 타입은 상속 관계를 따지지 않기 때문에 아래 코드는 진짜

```java
void printCollection(Collection<Object> c) {
    for (Object e : c) {
        System.out.println(e);
    }
}
```

따라서 아래 테스트는 컴파일 에러가 발생한다. Wrapper<Fruit>가 아닌 Wrapper<Apple>이 들어왔기 때문이다.

```java
@Test
@DisplayName( "지네릭스의 타입 변수는 상속 관계를 따지지 않는다." )
public void generics21() {
		
		Juice<String> item = new Juice<>();
		
		// 오류 지네릭스의 타입 변수는 상속 관계를 따지지 않는다.
		//item.makeJuice( new Wrapper<Apple>() );
}
```

```java
private class Juice<T> extends Fruit<T> {
				
				T item;
				
				public T getItem() {
						return item;
				}
				
				public String makeJuice( Wrapper<Fruit> item ) {
						return item.getItem().toString();
				}
		}
```

따라서 모든 타입을 대신할 수 있는 **와일드카드 타입(<?>)을 추가하였다. 와일드카드는 정해지지 않은 unknown type이기 때문에 Collection<?>로 선언함으로써 모든 타입에 대해 호출이 가능해졌다.**

## 2-1. 와일드 카드의 상하한

<aside>
🌐 와일드 카드 상한, 하한 제한
<? extends T> : 와일드 카드의 상한 제한, T와 그 자손들만 가능
<? super T> : 와일드 카드의 하한 제한 
<?> 제한 없음

</aside>

```java
@Test
@DisplayName( "와일드카드와 상하한 제한" )
public void wildCard() {
		
		Juice<String> item = new Juice<>();
		
		// 오류 지네릭스의 타입 변수는 상속 관계를 따지지 않는다.
		//item.makeJuice( new Wrapper<Apple>() );
		
		// 와일드 카드 : 사용 가능, <? extends Fruit> 이므로 상한 제한
		item.makeJuiceWithWildAndUpperBound( new Wrapper<Apple>() );
		
		// 상한 제한 이므로 Object는 안됨
		//item.makeJuiceWithWildAndUpperBound( new Wrapper<Object>() );
		
		// 하한 제한은 반대임 : Object는 가능하나
		item.makeJuiceWithWildAndLowerBound( new Wrapper<Object>() );
		
		// 자식인 Apple은 불가능
		//item.makeJuiceWithWildAndLowerBound( new Wrapper<Apple>() );
}
```

# 3. 열거형 (enums)

<aside>
🌐 열거형(enums)는 서로 연관된 상수의 집합이다.
JDK 1.5~

</aside>

## 3-1. 열거형의 사용

예를 들어 트럼프 카드의 종류를 상수로 정의한다고 하자, 이때 2가지 방법이 존재한다.

1. 상수 파일 정의 → static string으로 정의
2. enum 사용

이때 1번 방식으로 사용하면 각 종류가 하나의 집합이라는 것을 알 수 없다. 하지만 Enum을 사용하면 같은 논리 집합의 상수를 한 집합으로 관리할 수 있을 뿐만 안니라 타입으로 사용할 수 있기 때문에 상수를 정의하는데 필수적인 값이다.

열거형은 상수 하나하나가 모두 enum 클래스이다.

```java
public enum Kind {
		
		SPACE, CLOVER, HEART, DIAMOND
}

// 실제 사용
public Card( Kind kind , int number ) {
		this.kind = kind;
		this.number = number;
}
```

따라서 어떤 언어든 Enum을 사용한다는 것은 아래와 같은 장점을 지닌다

- 문자열과 비교해, **IDE의 적극적인 지원**을 받을 수 있다
    - 자동완성, 오타검증, 텍스트 리팩토링 등등
- 허용 가능한 값들을 제한할 수 있다
- **리팩토링시 변경 범위가 최소화** 된다
    - 내용의 추가가 필요하더라도, Enum 코드외에 수정할 필요가 없습다.

## 3-2. 열거형의 정의와 사용

```java
enum 열거형이름 {상수명1, 상수명2}
```

- 예

    ```java
    public enum Kind {
    		
    		SPACE, CLOVER, HEART, DIAMOND
    }
    
    // 사용
    this( Kind.DIAMOND , 3 );
    ```


## 3-3. 열거형의 멤버 추가

열거형에 멤버를 추가하고 싶으면 인스턴스 변수와 생성자를 추가한다

```java
enum 열거형이름 {
	상수1( 1, "A" ),
	상수2( 2, "B" ),
	
	// Enum의 멤버는 상수역할이 크므로 final을 붙이는 것이 좋으나 강제는 아님
	int member1;
	String member2;

	열거형이름( int member1 , String member2 ) {
		this.member1 = member1;
		this.member2 = member2;
	}	
}
```

- 예

    ```java
    public enum FLAG_YES {
    		
    		Y( 1, true ),
    		
    		N( 0, false );
    		
    		final int binary;
    		
    		final boolean trueFalse;
    		
    		FLAG_YES( int binary, boolean trueFalse ) {
    				
    				this.binary = binary;
    				this.trueFalse = trueFalse;
    		}
    
    		binaryCheck() { 
    			//...구현
    	  }
    		
    }
    ```


## 3-4. 열거형에 추상 메소드 추가

추상메소드 추가 가능

# 4. 자바의 Enum이 가지는 큰 장점

개인적으로 Enum을 좋아한다. Java Enum만이 가지는 특장점은 아래와 같다

****1. 데이터들 간의 연관관계 표현을 명확히 할 수 있다.****

아래 코드를 보라. 다양한 시스템에서 YES와 FALSE의 표현을 Enum으로 묶을 수 있다. 여기에 메소드만 추가하면 완벽하다

```java
public enum FLAG_YES {
		
		Y( 1, true ),
		
		N( 0, false );
		
		final int binary;
		
		final boolean trueFalse;
		
		FLAG_YES( int binary, boolean trueFalse ) {
				
				this.binary = binary;
				this.trueFalse = trueFalse;
		}
		
}
```

**2.데이터 그룹관리**

기관 데이터는 3개의 데이터 그룹으로 표현되어야 한다

- 물리적 이름
- 실제 Path
- 코드 Prefix

이걸 if문으로 처리한다고 하자 아래와 같은 문제점이 있다.

- **관계를 파악하기가 어렵다**.
    - IF문의 조건으로 관계 파악이 가능할까?
- 입력값과 결과값이 **예측 불가능하다**
- 그룹별 기능을 추가하기가 어렵습니다.
    - 기관 종류에 따라 추가 기능이 필요할 경우 현재 상태라면 어떻게 구현 해야할 까?
    - **또다시 기관 종류에 따른 if문으로 메소드를 실행**하는 코드를 작성해야 할까

이걸 Enum을 사용하면 한번에 해결된다. Enum 많이 사용하자 좋다

```java
public enum ORG_TYPE_ROOT {
				
				/** 신규 최상위 노드 */
				KINDERGARDEN(  "유치원" , "/유치원(K)" , "K"  ),
				ELEMENTARY( "초등학교" ,"/초등학교(E)" , "E" ),
				MIDDLE("중학교" ,"/중학교(M)" , "M"  ),
				HIGH( "고등학교" ,"/고등학교(H)"  , "H" ),
				SPECIAL( "특수학교" ,"/특수학교(S)" , "S" )
				;
				final String name;
				
				final String path;
				
				final String prefix;
				
				ORG_TYPE_ROOT( String name , String path, String prefix ) {
						
						this.name = name;
						this.path = path;
						this.prefix = prefix;
				}
				
				public String getName() {
						return this.name;
				}
				
				public String getPath() {
						return WS_ROOT_ORG + this.path;
				}
				
				public String getPrefix() {
						return this.prefix;
				}
				
				/**
				 * 최상위 조직을 객체로 생성합니다.
				 *
				 * - name : "초등학교"
				 * - path : /초등학교
				 * @return OrgUnit
				 * */
				public OrgUnit getOrgUnit() {
						return new Unit().setName( this.name + "(" + this.prefix + ")" ).setParentOrgUnitPath( this.getPath() );
				}
		}
```

# 🤔어노테이션이란?

위키백과에서는 다음과 같이 설명한다.

> 자바 애너테이션(Java Annotation)은 자바 소스 코드에 추가하여 사용할 수 있는 메타데이터의 일종이다. 보통 @ 기호를 앞에 붙여서 사용한다. JDK 1.5 버전 이상에서 사용 가능하다. 자바 애너테이션은 클래스 파일에 임베디드되어 컴파일러에 의해 생성된 후 자바 가상머신에 포함되어 작동한다.
>

![https://velog.velcdn.com/images%2Fjkijki12%2Fpost%2Ff5d6c89c-baf2-4b1b-9f07-f0ec5f368f85%2Fxcvvvvvvvvvvvvvv.PNG](https://velog.velcdn.com/images%2Fjkijki12%2Fpost%2Ff5d6c89c-baf2-4b1b-9f07-f0ec5f368f85%2Fxcvvvvvvvvvvvvvv.PNG)

위의 그림은 과거의 파일 관리 방법이었다.

자바 코드와 관련 설정 파일을 따로 저장하고, "ver @.@"로 구분하여 관리했다.

위와 같이 관리를 하는데 두 가지의 어려움이 있었다.1. 사람들이 자바 코드는 변경하는데 설정 파일을 업데이트 하지 않는 어려움

1. 설정과 코드가 분리되어있어, 개발에 대한 어려움

그래서 다음과 같은 관리방법을 채택하게 되었다.

![https://velog.velcdn.com/images%2Fjkijki12%2Fpost%2Fa72428db-a55e-4377-8b90-a30c2ad50b7f%2Fxxcvvvvvv.PNG](https://velog.velcdn.com/images%2Fjkijki12%2Fpost%2Fa72428db-a55e-4377-8b90-a30c2ad50b7f%2Fxxcvvvvvv.PNG)

이제 하나의 파일에서 코드와 설정을 관리할 수가 있던 것이다.

## 📌어노테이션의 종류

어노테이션에도 종류가 있다.

- 표준(내장) 어노테이션 : 자바가 기본적으로 제공해주는 어노테이션
- 메타 어노테이션 : 어노테이션을 위한 어노테이션
- 사용자정의 어노테이션 : 사용자가 직접 정의하는 어노테이션

어노테이션을 하나씩 살펴보자!

---

# 🔎표준 어노테이션

표준 어노테이션(메타 어노테이션 제외)의 종류는 다음과 같다.

1. @Override
2. @Deprecated
3. @SuppressWarnings

## 📌@Override

> 오버라이딩을 올바르게 했는지 컴파일러가 체크한다.
>

Override는 오버라이딩할 때, 메서드의 이름을 잘못적는 실수를 방지해준다.

```
class Parent{
	void parentMethod(){}
}

class Child extends Parent{
	@Override
    void pparentmethod(){} // 컴파일 에러! 잘못된 오버라이드 스펠링 틀림

```

## 📌@Deprecated

> 앞으로 사용하지 않을 것을 권장하는 필드나 메서드에 붙인다.
>

자바에서 메소드를 사용했는데 다음과 같이 표시된 경험이 있을 것이다."~~getDate~~()"이유는 해당 메소드 상위에 @Deprecated 어노테이션이 붙어있기 때문이다.

자바의 Date 클래스의 getDate()

```
@Deprecated
public int getDate(){
	return normalize().getDayOfMonth();
}
```

위의 "getDate" 메서드는 자바에서 사용하지 않을 것을 권장하는 메소드이다.

**없애지 그랬니?**자바는 하위 호환성을 엄청나게 중요하게 여긴다. 이전에 해당 메소드로 개발을 진행한 프로젝트들이 있기 때문에 유지는 하되, 권장하지 않는다.

## 📌@FunctionalInterface

> 함수형 인터페이스에 붙이면, 컴파일러가 올바르게 작성했는지 체크
>

해당 어노테이션은, 함수형 인터페이스의 "하나의 추상메서드만 가져야 한다는 제약"을 확인해준다.또한 함수형 인터페이스라는 것을 알려주는 역할도 한다.

## 📌@SuppressWarnings

> 컴파일러의 경고메세지가 나타나지 않게 한다.
>

```
@SuppressWarnings("unchecked")
ArrayList list = new ArrayList(); // 제네릭 타입을 지정하지 않음!
list.add(obj); // 경고 발생 !!! 경고 내용 = unchecked

```

위의 코드를 보자.Array를 선언할 때 제네릭을 통해서 타입에 대한 정보를 기입하지 않았다.그래서 타입을 선언하지 않았다는 "unchecked"라는 경고가 뜬다.하지만 "@SuppressWarnings("unchecked)"를 입력해주었기 때문에 "unchecked"에 대한 경고는 억제된다.

**보통 경고가 많을 때, 확인된 경고는 해당 어노테이션을 붙여서 새로운 경고를 알아보지 못하는 것을 방지하기 위해 사용한다.**

---

# 🔎메타 어노테이션

메타 어노테이션은 어노테이션을 위한 어노테이션이다.

## 📌@Target

> 어노테이션을 정의할 때, 적용대상을 지정하는데 사용한다.
>

```
@Target({TYPE, FIELD, TYPE_USE})
@Retention(RetentionPolicy.SOURCE)
public @interface MyAnnotation{}

@MyAnnotation // 적용 대상이 Type(클래스, 인터페이스)
class MyClass{
	@MyAnnotation //적용 대상이 FIELD인 경우
    int i;

    @MyAnnotation //적용 대상이 TYPE_USE인 경우
    MyClass mc;
}
```

## 📌@Retention

> 어노테이션이 유지되는 기간을 지정하는데 사용
>
- SOURCE : 소스 파일에만 존재.
- RUNTIME : 클래스 파일에 존재. 실행시에 사용가능

```
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override{}

```

## 📌@Documented

> javadoc으로 작성한 문서에 포함시키려면 해당 어노테이션을 붙인다.
>

## 📌@Inherited

> 어노테이션도 상속이 가능하다. 어노테이션을 자손 클래스에 상속하고자 할 때, @Inherited를 붙인다.
>

```
@Inherited
@interface SuperAnno{}

@SuperAnno
class Parent{}

// <- 여기에 @SuperAnno 가 붙은 것으로 인식
class Child extends Parent{}
```

## 📌@Repeatable

> 반복해서 붙일 수 있는 어노테이션을 정의할 때 사용
>

```
@Repeatable(ToDos.class)
@interface ToDo{
	String value();
}

@ToDo("delete test codes.")
@ToDo("override inherited methods")
class MyClass{
	~~
}

@interface ToDos{
	ToDo[] value();
}

```

MyClass를 보면 "@ToDo" 어노테이션이 여러개가 정의된 것을 볼 수 있다.

@Repeatable 어노테이션은 위의 "ToDos"처럼 "컨테이너 어노테이션"도 정의해야 한다.

---

# 🔎어노테이션 생성하기

어노테이션을 생성하는 것은 매우 쉽다.다음 코드와 같이 작성해주면 끝이다.

```
@interface 이름{
	타입 요소 이름(); // 어노테이션의 요소를 선언
	    ...
}

```

실제로 만들고, 적용해보자.

```
@interface DateTime{
	String yymmdd();
    String hhmmss();
}

@interface TestInfo{
	int count() default 1;
    String testedBy();
    TestType testType();
    DateTime testDate();
}

@TestInfo{
	testedBy="Kim",
    testTools={"JUnit", "AutoTester"},
    testType=TestType.FIRST,
    testDate=@DateTime(yymmdd="210922", hhmmss="211311")
)// count를 생략했으므로 default인 "count=1"이 적용된다.
public class NewClass{...}

```

그리고 추가적인 특징을 보자.

### 📌어노테이션 요소 특징

- 적용시 값을 지정하지 않으면, 사용될 수 있는 기본값을 지정할 수 있다.(위의 default)
- 요소가 하나이고 이름이 value일 때는 요소의 이름 생략가능하다.

```
@interface TestInfo{
	String value();
}
@TestInfo("passed") // value="passed"와 동일
class NewClass{...}

```

- 요소의 타입이 배열인 경우, 괄호{}를 사용해야 한다.

```
@interface TestInfo{
	String[] testTools();
}

@TestInfo(testTools={"JUnit", "AutoTester"})
@TestInfo(testTools="JUnit") // 요소가 1개일 때는 {}를 사용하지 않아도 된다.
@TestInfo(testTool={}) // 요소가 없으면 {}를 써넣어야 한다.

```

---

# 🔎모든 어노테이션의 조상

> Annotation은 모든 어노테이션의 조상이지만 상속은 불가능하다.
>

"Annotation"은 다음과 같이 생겼다.

```
public interface Annotation{
	boolean equals(Object obj);
    int hashCode();
    String toString();

    Class<? extends Annotation> annotationType();
    }

```

---

# 🔎마커 어노테이션

> 요소가 하나도 정의되지 않은 어노테이션
>

대표적으로 "@Test"가 있다.해당 어노테이션은 테스트 프로그램에게 테스트 대상임을 알리는 어노테이션이다.

---

# 🔎어노테이션 규칙

어노테이션에도 반드시 지켜주어야 하는 규칙이 있다. 다음 4가지를 살펴보자.

- 요소의 타입은 기본형, String, enum, 어노테이션, Class만 허용된다.
- 괄호()안에 매개변수를 선언할 수 없다.
- 예외를 선언할 수 없다.
- 요소의 타입을 매개변수로 정의할 수 없다.(<T>)

잘못된 예시를 통해서 이해해보자!

```
@interface AnnoConfigTest{
    int id = 100; // 상수 ok
    String major(int i, int j) //매개변수 x
    String minor() throws Exception; // 예외 x
    ArrayList<T> list(); // 요소의 타입을 매개변수 x
```

# — 참고

[Java Enum 활용기 | 우아한형제들 기술블로그](https://techblog.woowahan.com/2527/)