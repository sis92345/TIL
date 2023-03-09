# 14. 람다식 (Lambda Expression)

---

<aside>
🌐 람다식은 JDK 1.8 부터 등장한 메서드를 하나의 식으로 표현한 것이다
정확히 말하면 람다식은 익명 클래스의 객체와 동등하다.

</aside>

람다식을 사용하면 메소드의 반환값과 이름이 없어지므로 익명 함수라고도 한다.

람다식은 익명 클래스의 객체와 동등하다. 아래 람다식과 익명 클래스는 서로 동등한 관계이다.

```java
( int a, int b ) -> Math.max( a, b )
```

```java
new Object() {
	int max ( int a, int b ) {
		return Math.max( a, b );
	}
}
```

# 1. 람다식 작성

메소드

```java
반환 타입 메소드이름 (매개변수 선언) {
	문장들
}
```

람다식

```java
(매개변수 선언) -> {
	문장들
}
```

## 1-1. 람다식의 다양한 표현 방법

람다식은 메소드의 형태에 따라 다양하게 작성할 수 있다. 어떤 형태이든 모두 같은 람다식이란 것 만 알아보면 된다.

- 대상 메소드

    ```java
    int method( int i ) {
    	return (int) (Math.random() * 5) + i;
    }
    
    int methodWithoutParam() {
    	return (int) (Math.random() * 5) + 1;
    }
    ```


### 1-1-1. 다양한 표현 방법 : FM

매개변수 타입과 리턴 명시

```java
// 1. FM
int result = list.stream().max( ( Integer o1, Integer o2 ) -> { return o1 < o2 ? 1 : -1; } ).get();
```

### 1-1-2. 매개변수 타입은 생략 가능

매개변수 타입 생략 가능

```java
// 2. 매개변수 타입 생략
list.stream().max( ( o1, o2 ) -> { return o1 < o2 ? 1 : -1; } ).get();
```

### 1-2-3. 문장이 하나라면 `return`을 생략할 수 있다.

문장이 하나라면 `return`을 생략할 수 있다.

- 첫번째 식의 결과가 그대로 반환한다.

```java
list.stream().max( ( o1, o2 ) ->  o1 < o2 ? 1 : -1 ).get();
```

### 1-2-4. 매개변수가 하나라면 매개변수 괄호 생략 가능

매개변수가 하나라면 매개변수 괄호 생략 가능

```java
list.stream().filter( item -> 1 < item ).collect( Collectors.toList() );
```

# 2. 함수형 인터페이스 (Function interface)

아래 MyFunction는

```java
interface MyFunction {
		public abstract int max ( int a, int b );
}

MyFunction f = new MyFunction() {
		
		@Override
		public int max( int a, int b ) {
				return Math.max( a, b );
		}
};
```

하나의 추상메소드만 존재하고 아래 람다식과 매개변수의 타입과 개수, 반환값이 일치하기 때문에 람다식으로 대체할 수 있다.

```java
/**
 * 람다식은 익명 함수와 동일하다
 * */
@Test
public void lambda2() {
		
		MyFunction func = ( a , b ) -> Math.max( a, b );
		
}
```

**따라서 람다식을 다루기 위한 인터페이스가 등장했으며 이 인터페이스를 함수형 인터페이스(functional interface)라고 한다.**

## 2-1. 함수형 인터페이스의 선언

함수형 인터페이스는

- `**@FunctionalInterface` annotation을 붙여서 정의한다.**
- **단 하나의 추상 메소드만 정의되어야 한다**(그래야만 람다식과 1 : 1로 연결된다)
    - 만약 추상 메소드가 2개 이상인 인터페이스를 함수형 인터페이스로 선언하면 `Multiple non-overriding abstract methods found in interface lambda.functionInterface` 오류가 발생한다.
    - 단 default 메소드와 static 메소드는 제한이 없다

```java
@FunctionalInterface
public interface functionInterface {
		
		public int max ( int a, int b );
}
```

## 2-2. 매개변수 타입으로 람다식을 선언할 수 있다.

메소드의 매개변수로 람다를 받을 수 있다. 함수형 인터페이스의 타입을 매개변수로 선언할 수 있다.

```java
/**
 * 매개변수로 함수형 인터페이스 타입 가능 -> 람다식 받을 수 있다.
 * */
@Test
public void lambda3() {

		int result = lambdaParamMethod( ( a, b ) -> a );
		
		System.out.println( result );
}

public int lambdaParamMethod ( MyFunction f ) {
		return f.max( 1, 3 );
}
```

## 2-3. 함수형 인터페이스 팁

1. **가급적이면  `java.util.function` 을 사용한다.**
    - 아래 함수형 인터페이스 Foo는 `Function<String,String>`, `UnaryOperator<String>`와 같다. Foo를 `Function<String,String>`, `UnaryOperator<String>`로 변경한다.

    ```java
    @FunctionalInterface
    public interface Foo {
        String method(String string);
    }
    
    // Bad
    public String add(String string, Foo foo) {
        return foo.method(string);
    }
    
    // Good
    public String add(String string, Function<String,String> foo) {
        return foo.method(string);
    }
    ```

2. `**@FunctionalInterface` 를 사용하자**
    - 주석을 사용하면 하나의 추상 메소드만 선언할 수 있고 오류를 반환한다.

        ```java
        // Bad
        public interface Foo {
            String method(String string);
        }
        
        // Good
        @FunctionalInterface
        public interface Foo {
            String method(String string);
        }
        ```

3. **함수형 인터페이스에서 default 메소드를 과도하게 사용하지 않는다.**
    - 함수형 인터페이스는 추상 메소드의 시그니쳐가 동일할 경우 다른 함수형 인터페이스로 extends할 수 있다.

        ```java
        @FunctionalInterface
        public interface FooExtended extends Baz, Bar {}
        	
        @FunctionalInterface
        public interface Baz {	
            String method(String string);	
            default String defaultBaz() {}		
        }
        	
        @FunctionalInterface
        public interface Bar {	
            String method(String string);	
            default String defaultBar() {}	
        }
        ```

    - 이때 기본 메소드의 이름이 같을 경우 컴파일 오류가 발생한다. 오류가 없어도 과도한 기본 메소드는 좋은 아키첵쳐가 아니므로 지양한다.
    - 물론 대안으로 상위 인터페이스에서 구현을 재사용할 수 있다.
4. **함수형 인터페이스는 람다식으로 인스턴스화 한다.**
    - 함수형 인터페이스는 내부 클래스로 인스턴스화 할 수 있다. 하지만 그러지 말자

        ```java
        // Bad
        Foo fooByIC = new Foo() {
            @Override
            public String method(String string) {
                return string + " from Foo";
            }
        };
        
        // Good
        Foo foo = parameter -> parameter + " from Foo";
        ```

5. 함수형 인터페이스를 매개변수로 사용할 경우 오버로딩이 안될 수 있다.
    - 예를 들어 아래 코드 처럼 다른 함수형 인터페이스를 받았다.

        ```java
        public interface Processor {
        		String process( Callable<String> c) throws Exception;
        		String process( Supplier<String> s);
        }
        
        class ProcessorImpl implements Processor {
        		@Override
        		public String process(Callable<String> c) throws Exception {
        				// implementation details
        				return "";
        		}
        		
        		@Override
        		public String process(Supplier<String> s) {
        				// implementation details
        				return "";
        		}
        }
        ```

    - 그러나 아래 코드는 오류가 발생한다. Callable의 시그니쳐와 Supplier의 시그니쳐가 같기 때문에 오류가 발생한다

        ```java
        /**
         * 함수형 인터페이스 오버로딩 시 주의
         * */
        @Test
        public void lambda4 () {
        		
        		Processor processor = new ProcessorImpl();
        		
        		String result = processor.process(() -> "abc");
        }
        ```

6. 람다식을 내부 클래스로 취급하지 말라
    - 이건 확인 : 변수 관련 이슈

7. 람다식은 짧고 이해하기 쉽게 유지한다.

# 3. 람다식의 제한

1. **람다식의 타입과 형변환**
    - 람다식은 익명 객체이다. 하지만 람다식은 오직 함수형 인터페이스로만 형변환이 가능하다.
    - 명시적으로 아래 처럼 람다식은 함수형 인터페이스 구현 객체 타입에 할당하기 위해 형변환을 해야하지만 형변환은 생략이 가능하다.

        ```java
        MyFunction func = ( a , b ) -> Math.max( a, b );
        ```

2. **람다식의 외부 변수 참조 : 람다식에서 외부 변수의 사용**
    - 람다식 내에서 참조하는 지역 변수는 상수로 간주된다 ⇒ 람다식에서 사용되는 변수는 final이어야 한다.

        ```java
        int b = 0;
        // 1. FM
        int result = list.stream().max( ( Integer o1, Integer o2 ) -> {
        		// 오류 -> Variable used in lambda expression should be final or effectively final
        		b = 3;
        		return o1 < o2 ? 1 : -1; } ).get();
        ```

    - 인스턴스 변수는 상수로 간주하지 않으므로 값을 변경할 수 있다.

        ```java
        int b = 0;
        // 1. FM
        int result = list.stream().max( ( Integer o1, Integer o2 ) -> {
        		// b = 3; 람다식 내부의 지역 변수는 final 이어야 한다 == 수정 못함 ㅋ
        		instanceVar = "test"; // 단 인스턴스 변수는 가능 -> 상수로 간주 안함
        		return o1 < o2 ? 1 : -1; } ).get();
        ```


# 4. `java.util.function`

<aside>
🌐 `java.util.function` 은 일반적으로 자주 사용되는 형식의 메소드를 함수형 인터페이스로 미리 정의하였다.

[java.util.function (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)

</aside>

## 4-1. 핵심 함수형 인터페이스 : `Supplier<T>`, `Consumer<T>`, `Function<T,R>`, `Predicate<T>`

`java.util.function` 에서 가장 많이 사용하는 함수형 인터페이스이다. stream에서 람다식을 받을 때 이 4가지 함수형 인터페이스를 요구하므로 반드시 알아야 하는 함수형 인터페이스이다.

| 함수형 인터페이스 | 메서드 | 매개변수 | 반환값 |
| --- | --- | --- | --- |
| java.lang.Runnable | void run() | 없음 | 없음 |
| Supplier<T> | T get() | 없음 | 있음 |
| Consumer<T> | void accpet(T t) | 있음 | 없음 |
| Function<T,R> | R apply(T t) | 있음 | 있음 |
| Predicate<T> | boolean test(T t) | boolean | 있음 |

예를 들어 stream의 filter에서 매개변수로 받는 함수형 인터페이스는 Predicate 이다. 따라서 나는 filter를 사용하기 위해서 T 타입을 매개변수로 받아서 boolean을 던지는 람다식을 구현해야 함을 알 수 있다.

```java
public abstract Stream<T> filter(     java.util.function.Predicate<? super T> predicate )
```

stream의 경우 특히 함수형 인터페이스로 위 4개 타입을 사용하고 있기 때문에 stream을 사용한다면 알아두는 것이 좋다.

## 4-2. 기타 : 매개변수가 두 개인 함수형 인터페이스

| 함수형 인터페이스 | 메서드 | 매개변수 | 반환값 |
| --- | --- | --- | --- |
| BIConsumer<T,U> | void accept(T t, U u) | 2개 | 없음 |
| BIPredicate<T,U> | boolean test (T t, U u) | 2개 | 있음 |
| BIFunction<T,U,R> | R apply(T t, U u) | 2개 | 없음 |

## 4-3. 기타 : Operator

Function의 변형이다. Function과 다르게 같은 타입을 반환한다.

| 함수형 인터페이스 | 메서드 | 매개변수 | 반환값 |
| --- | --- | --- | --- |
| UnaryOperator<T> | T accept(T t) | 1개 | T |
| BinaryOperator<T> | T test (T t, T u) | 2개 | T |

## 4-4. 제네릭이 없는 함수형 인터페이스

| 함수형 인터페이스 | 메서드 | 매개변수 | 반환값 |
| --- | --- | --- | --- |
| DoubleToIntFunction | int applyAsInt(double d) | double | int |
| ToIntFunction<T> | int applyAsInt(T value) | T | int |
| intFunction<R> | R apply(int i) | int | R |
| ObjIntConsumer<T> | void accept(T t, int val) | 2개 | 없음 |

## 4-5. 컬렉션 프레임워크에서 사용되는 함수형 인터페이스

| 인터페이스 | 메서드 | 설명 |
| --- | --- | --- |
| Collection | boolean removeIf(Predicate filter) | 조건에 맞는 요소를 삭제 |
| List | void replace(UnaryOperator operator) | 모든 요소를 변환하여 대체 |
| Iterable | void forEach(Consumer action) | 모든 요소에 작업 action을 수행 |
| Map | V compute(K key, V value, BiFunction<K,V,V> f) | 지정된 키의 값에 작업 f를 수행 |
|  | void forEach(BiConsumer<K,V> action) | 모든 요소에 작업 action을 수행 |

# 5. 메소드 참조

<aside>
🌐 **메소드 참조(method reference)**는 람다 표현식이 단 하나의 메소드만을 호출하는 경우에 해당 람다 표현식에서 불필요한 매개변수를 제거하고 사용할 수 있도록 한다.

</aside>

예를 들어 회사 타입별로 스트림으로 매핑한다고 하자 기존 람다식은 아래와 같이 사용할 수 있다.

```java
List<String> oidList = infoList.stream().map( obj -> obj.getType() )
```

위 예제는 하나의 람다 표현식이므로 메소드 참조로 줄여사용할 수 있다.

```java
List<String> oidList = infoList.stream()
												   .map( CompanyVC::getType )
```

# 6. 참고사항

1. 함수형 인터페이스 팁

   [](https://www.baeldung.com/java-8-lambda-expressions-tips)

2. 지연 연산
3. asd