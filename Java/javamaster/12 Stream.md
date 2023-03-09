# Stream API

<aside>
🎏 스트림 API는 데이터를 추상화하여 다루므로, 다양한 방식으로 저장된 데이터를 읽고 쓰기 위한 공통된 방법을 제공한다.

</aside>

주의할 것은 일반적인 프로그래밍 언어에서 이야기하는 Stream과 JAVA 8에서 추가된 Stream API는 다른 것을 의미한다. 전자는 실제의 입력이나 출력이 표현된 데이터의 이상화된 흐름을 의미한다. 즉 파이프라인을 이야기한다.

## 왜 Stream API를 사용하는가

> **스트림은 데이터 소스를 변경하지 않는다.**
아래 소스에서 List를 sort하지만 원본 List에는 영향을 미치지 않는다.
>
>
> ```java
> List<String> sortedList = strStream2.sorted().collect( Collectors.toList() );
> ```
>

> **스트림은 작업을 내부 반복으로 처리한다.**
람다식과 메서드참조와 결합하면 복잡한 반복문을 숨길 수 있다.
>
>
> ```java
> stream.forEach( System.out::println );
> ```
>

결국 stream은 Collection을 람다식과 여러 체이닝 형태의 파이프라인 메소드를 제공함으로써 가독성을 높여 가장 멋지게 처리할 수 있는 API이기 때문에 Collection을 사용할 경우 Stream은 반드시 따라오는 API이다.

# Stream 공부 전 반드시 알아야 할 것

## 중간연산과 최종연산

> **중간 연산** : **연산결과가 스트림인 연산**, 체인형으로 스트림을 연속해서 중간연산할 수 있다.
예 ) filter, sorted, distinct, map, peek
>
>
> ```java
> stream.sorted().filter( item -> item.getId().equals( "aa" ) )
> 							 .....//최종연산
> ```
>

> **최종 연산** : **연산결과가 스트림인 연산**, 스트림의 요소를 소모하는 용도로 사용한다.
예 ) collect, forEach
>
>
> ```java
> stream.sorted().filter( item -> item.getId().equals( "aa" ) )....// 중간연산
> 							 .collect( Collectors.toList() )
> ```
>

### `peek()`와 `forEach()`로 알아보는 중간연산과 최종연산의 차이점

`peek()`와 `forEach()` 는 둘 다 모든 요소를 순회하는 반복 메소드이다. 하지만 `peek()` 는 중간연산 `forEach()` 은 최종연산이다.

- peek()
    - 중간연산이기 때문에 최종연산이 없다면 실행되지 않는다. 보통 아래와 같이 중간에 내부 요소를 변경할 경우 사용한다.

        ```java
        Stream<User> userStream = Stream.of(new User("Alice"), new User("Bob"), new User("Chuck"));
        userStream.peek(u -> u.setName(u.getName().toLowerCase()))
          .forEach(System.out::println);
        ```

    - 참고로 **stream은 최종 연산에 따라 실행을 최적화 하기 때문에 peek로 실행했을 경우 전체순회가 된다는 보장을 할 수 없다.** 따라서 쓰지 말자, 왠만하면 forEach로 대체할 수 있다.

        ```java
        Arrays.asList("Fred", "Jim", "Sheila")
              .stream()
              .peek(System.out::println)
              .allMatch(s -> s.startsWith("F")); // Sheilas는 출력되지 않는다. Jim에서 false라서 여기서 stream 끝남
        ```

- forEach()
    - 최종연산이다. 따라서 단독으로 사용할 수 있다.
        - 물론 이것도 종료가 있는 반복문일 경우 일반 for문을 사용하는 것이 더 좋다.

        ```java
        Arrays.asList("Fred", "Jim", "Sheila")
              .stream()
              .filter( s -> s.startsWith("F") )
        		  .forEach( System.out::println );
        ```


## 지연된 연산 과 최적화

> **Stream은 최종 연산이 수행되기 전까지 중간 연산이 수행되지 않는다.**
>

stream에서 가장 중요한 개념이다. 위에서 peek가 왜 연산이 되지 않는지는 지연된 연산과 최적화에 달려있다.

예를 들어 아래 연산은 보기에는 이렇게 작동한다.

- 100개의 데이터를 조회 → 5개제한 → collect

실제 최적화된 연산은 아래와 같다.

- 5개 생성 → collect

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c9136a77-1e36-4a85-8d62-d98d567eae09/Untitled.png)

```java
List dataList = IntStream.generate(() -> 100) .mapToObj(Data::new) 
												 .limit(5) 
												 .collect(Collectors.toUnmodifiableList());

```

[[Java] 스트림: 지연 연산과 최적화](https://bugoverdose.github.io/development/stream-lazy-evaluation/)

## 오토박싱과 언박싱의 언박싱을 방지하기 위한 Stream 제공

stream은 객체를 사용하기 때문에 기본형은 Wrapper 클래스를 사용해야 한다. 따라서 여기에 따른 오토박싱, 언박싱의 오버헤드가 발생하는데 이를 방지하기 위한 stream도 제공한다.

- `IntStream`, `LongStream`, `DoubleStream`

## 병렬스트림

Stream의 가장 큰 장점중의 하나이다. 병렬스트림을 사용하면 자동으로 작업을 병렬처리할 수 있다.

---

# stream의 생성

## Collection의 stream의 생성 : `java.util.Collections.stream()`

`java.util.Collections` 에 `stream()` 메소드로 생성할 수 있다. 따라서 Collections를 구현한 모든 컬렉션 클래스는 stream을 생성할 수 있다.

```java
@Test
public void stream의_생성_Collection() {
		
		List<String> strings = new ArrayList<>();
		strings.add( "1" );
		strings.add( "2" );
		strings.add( "3" );
		
		strings.stream().collect( Collectors.toList() );
		
}
```

## 배열의 stream 생성 : `Arrays.stream()`

```java
@Test
public void stream의_생성_배열() {
		
		Arrays.stream( new String[] { "1" , "2" , "3" } ).collect( Collectors.toList() );
}
```

## 범위로 생성 : `Intstream.range( start, end )`

```java
@Test
public void stream의_생성_범위() {
		
		// 1 ~ 9
		IntStream stream = IntStream.range( 1 , 10 );
		// 1 ~ 10
		IntStream stream1 = IntStream.rangeClosed( 1 , 10 );
}
```

## 랜덤 스트림

```java
@Test
public void 랜덤스트림() {
		
		// 무한 스트림
		IntStream stream = new Random().ints( );
		
		// 무한 스트림의 제한
		IntStream stream1 = new Random().ints().limit( 50 );
		
		// 합쳐놓은거
		IntStream stream2 = new Random().ints( 5 );
}
```

## `inerate()`, `generate()`

> iterate()는 이전 요소를 seed로 해서 다음 요소를 계산한다.
>

> generate()는 seed를 사용하지 않는다.
>

```java
@Test
public void iterateAndGenerate() {
		
		// iterate()는 이전 요소를 seed로 해서 다음 요소를 계산한다.
		Stream.iterate( 0, n -> n  + 1 ).limit( 50 ).forEach( System.out::println );
		
		// generate()는 seed를 사용하지 않는다.
		Stream.generate( () -> 1 ).limit( 50 ).forEach( System.out::println );
}
```

## 비어있는 스트림

보통 null 반환대신 많이 사용한다.

```java
@Test
public void emptyStream() {
		
		// iterate()는 이전 요소를 seed로 해서 다음 요소를 계산한다.
		Stream.empty().collect( Collectors.toList() );
}
```

---

# 스트림의 중간연산

[스트림의 중간연산](https://www.notion.so/e9ef36a32ad648be8264b6e221828a0b)

# 스트링의 최종 연산

[스트림의 최종 연산](https://www.notion.so/37567947f5ed460082d1afdc9e186487)

# Optional

이건 생략, Optional은 Java8에서 나온 것으로 별도로 공부하는 것이 더 좋을 것 같음

---

# 참고

## stream Method

| Modifier and Type | Method and Description |
| --- | --- |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#allMatch-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> predicate)Returns whether all elements of this stream match the provided predicate. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#anyMatch-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> predicate)Returns whether any elements of this stream match the provided predicate. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.Builder.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#builder--()Returns a builder for a Stream. |
| <R,A> R | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#collect-java.util.stream.Collector-(https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collector.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,A,R> collector)Performs a https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#MutableReduction operation on the elements of this stream using a Collector. |
| <R> R | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#collect-java.util.function.Supplier-java.util.function.BiConsumer-java.util.function.BiConsumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html<R> supplier, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html<R,? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> accumulator, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html<R,R> combiner)Performs a https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#MutableReduction operation on the elements of this stream. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#concat-java.util.stream.Stream-java.util.stream.Stream-(https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<? extends T> a, https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<? extends T> b)Creates a lazily concatenated stream whose elements are all the elements of the first stream followed by all the elements of the second stream. |
| long | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#count--()Returns the count of elements in this stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#distinct--()Returns a stream consisting of the distinct elements (according to https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#equals-java.lang.Object-) of this stream. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#empty--()Returns an empty sequential Stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#filter-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> predicate)Returns a stream consisting of the elements of this stream that match the given predicate. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#findAny--()Returns an https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html describing some element of the stream, or an empty Optional if the stream is empty. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#findFirst--()Returns an https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html describing the first element of this stream, or an empty Optional if the stream is empty. |
| <R> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<R> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#flatMap-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<? extends R>> mapper)Returns a stream consisting of the results of replacing each element of this stream with the contents of a mapped stream produced by applying the provided mapping function to each element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/DoubleStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#flatMapToDouble-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/stream/DoubleStream.html> mapper)Returns an DoubleStream consisting of the results of replacing each element of this stream with the contents of a mapped stream produced by applying the provided mapping function to each element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/IntStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#flatMapToInt-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/stream/IntStream.html> mapper)Returns an IntStream consisting of the results of replacing each element of this stream with the contents of a mapped stream produced by applying the provided mapping function to each element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#flatMapToLong-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html> mapper)Returns an LongStream consisting of the results of replacing each element of this stream with the contents of a mapped stream produced by applying the provided mapping function to each element. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#forEach-java.util.function.Consumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> action)Performs an action for each element of this stream. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#forEachOrdered-java.util.function.Consumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> action)Performs an action for each element of this stream, in the encounter order of the stream if the stream has a defined encounter order. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#generate-java.util.function.Supplier-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html<T> s)Returns an infinite sequential unordered stream where each element is generated by the provided Supplier. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#iterate-T-java.util.function.UnaryOperator-(T seed, https://docs.oracle.com/javase/8/docs/api/java/util/function/UnaryOperator.html<T> f)Returns an infinite sequential ordered Stream produced by iterative application of a function f to an initial element seed, producing a Stream consisting of seed, f(seed), f(f(seed)), etc. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#limit-long-(long maxSize)Returns a stream consisting of the elements of this stream, truncated to be no longer than maxSize in length. |
| <R> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<R> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#map-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,? extends R> mapper)Returns a stream consisting of the results of applying the given function to the elements of this stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/DoubleStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToDouble-java.util.function.ToDoubleFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/ToDoubleFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> mapper)Returns a DoubleStream consisting of the results of applying the given function to the elements of this stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/IntStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToInt-java.util.function.ToIntFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/ToIntFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> mapper)Returns an IntStream consisting of the results of applying the given function to the elements of this stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToLong-java.util.function.ToLongFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/ToLongFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> mapper)Returns a LongStream consisting of the results of applying the given function to the elements of this stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#max-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> comparator)Returns the maximum element of this stream according to the provided Comparator. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#min-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> comparator)Returns the minimum element of this stream according to the provided Comparator. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#noneMatch-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> predicate)Returns whether no elements of this stream match the provided predicate. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#of-T...-(T... values)Returns a sequential ordered stream whose elements are the specified values. |
| static <T> https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<T> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#of-T-(T t)Returns a sequential Stream containing a single element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#peek-java.util.function.Consumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> action)Returns a stream consisting of the elements of this stream, additionally performing the provided action on each element as elements are consumed from the resulting stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#reduce-java.util.function.BinaryOperator-(https://docs.oracle.com/javase/8/docs/api/java/util/function/BinaryOperator.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> accumulator)Performs a https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Reduction on the elements of this stream, using an https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Associativity accumulation function, and returns an Optional describing the reduced value, if any. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#reduce-T-java.util.function.BinaryOperator-(https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html identity, https://docs.oracle.com/javase/8/docs/api/java/util/function/BinaryOperator.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> accumulator)Performs a https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Reduction on the elements of this stream, using the provided identity value and an https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Associativity accumulation function, and returns the reduced value. |
| <U> U | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#reduce-U-java.util.function.BiFunction-java.util.function.BinaryOperator-(U identity, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<U,? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html,U> accumulator, https://docs.oracle.com/javase/8/docs/api/java/util/function/BinaryOperator.html<U> combiner)Performs a https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Reduction on the elements of this stream, using the provided identity, accumulation and combining functions. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#skip-long-(long n)Returns a stream consisting of the remaining elements of this stream after discarding the first n elements of the stream. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#sorted--()Returns a stream consisting of the elements of this stream, sorted according to natural order. |
| https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#sorted-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html> comparator)Returns a stream consisting of the elements of this stream, sorted according to the provided Comparator. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html[] | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#toArray--()Returns an array containing the elements of this stream. |
| <A> A[] | https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#toArray-java.util.function.IntFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/IntFunction.html<A[]> generator)Returns an array containing the elements of this stream, using the provided generator function to allocate the returned array, as well as any additional arrays that might be required for a partitioned execution or for resizing. |