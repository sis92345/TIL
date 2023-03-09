# 1. Collections Framework

<aside>
💥 컬렉션 프레임워크는 **데이터 군을 저장하는 클래스들을 표준화한 설계**

</aside>

- 데이터 군 → Collection
- 표준화 설계 → Framework

## 1-2. Collection Framework 핵심 인터테이스

Collection Framework는 데이터 그룹을 크게 3가지로 나누어서 인터페이스로 정의하였다. Map은 공통된 부분이 없기 때문에 상속계층도에서 분리되었다.

- 전체 구조

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6c6f8dd7-a47a-48f2-b0c0-8be892168e30/Untitled.png)

- 실제 상속계층도
    - Collection의 상속도

      ![https://media.geeksforgeeks.org/wp-content/cdn-uploads/20200811210521/Collection-Framework-1.png](https://media.geeksforgeeks.org/wp-content/cdn-uploads/20200811210521/Collection-Framework-1.png)

    - Map

      ![https://media.geeksforgeeks.org/wp-content/cdn-uploads/20200811210611/Collection-Framework-2.png](https://media.geeksforgeeks.org/wp-content/cdn-uploads/20200811210611/Collection-Framework-2.png)

- 실제 Java Doc 상속 트리
    - java.lang.**[Iterable](https://docs.oracle.com/javase/8/docs/api/java/lang/Iterable.html)**<T>
        - java.util.**[Collection](https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html)**<E>
            - java.util.**[List](https://docs.oracle.com/javase/8/docs/api/java/util/List.html)**<E>
            - java.util.**[Queue](https://docs.oracle.com/javase/8/docs/api/java/util/Queue.html)**<E>
            - java.util.**[Set](https://docs.oracle.com/javase/8/docs/api/java/util/Set.html)**<E>
    - java.util.**[Map](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html)**<K,V>

컬렉션의 세 인터페이스의 특징을 적은 표이다. 이 표는 컬렉션의 핵심이므로 반드시 숙지하는 것이 필요하다.

| Interface | 알고리즘 | 데이터 중복 허용 | 구현체 |
| --- | --- | --- | --- |
| List | 순서가 있는 데이터의 집합 | O | ArrayList, LinkedList, Stack, Vector |
| Set | 순서를 유지하지 않는 데이터의 집합 | X | HashSetm TreeSet |
| Map | Key-Value 행으로 이루어진 순서를 유지하지 않는 데이터의 집합 | 키 - X
값 - O | HashMap, TreeMap, Hashtable, Properties |

## 1-2. Collection Interface

[Collection (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html)

### 매소드 요약

| Modifier and Type | Method and Description |
| --- | --- |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html e)  Collection에 element를 추가합니다(optional operation). |
|  | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#addAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> c) Collection에 있는 데이터를 모두 추가합니다. (optional operation). |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#clear--() Collection의 모든 element를 제거합니다 (optional operation). |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o) 특정 객체가 Collection에 존재하는지 체크합니다 |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#containsAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c) 특정 객체가 Collection에 존재하는지 체크합니다 |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#equals-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o) 동일한 Collection인지 판별 |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#hashCode--()Returns the hash code value for this collection. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#isEmpty--()Returns true if this collection contains no elements. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#iterator--() Collection의 iteterator를 얻어서 반환 |
| default https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#parallelStream--()Returns a possibly parallel Stream with this collection as its source. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o) 객체가 존재한다면 Collection에서 데이터를 삭제합니다.(optional operation). |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#removeAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c) 특정 객체가 존재한다면 해당 모든 element를 삭제합니다. (optional operation). |
| default boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#removeIf-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> filter)Removes all of the elements of this collection that satisfy the given predicate. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#retainAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c) 지정된 Collection에 포함된 객체만 남기고 다른 객체들은 Collection에서 삭제한다. 이 작업으로 Collection에 변화가 있으면 true를 반환한다.(optional operation). |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#size--()Returns the number of elements in this collection. |
| default https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#spliterator--()Creates a https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html over the elements in this collection. |
| default https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html<https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#stream--()Returns a sequential Stream with this collection as its source. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html[] | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#toArray--()Returns an array containing all of the elements in this collection. |
| <T> T[] | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#toArray-T:A-(T[] a)Returns an array containing all of the elements in this collection; the runtime type of the returned array is that of the specified array. |

## 왜 Collection은 Framework 인가

<aside>
💥 프레임워크는 **문제를 극복하기 위해 코드를 추가할 수 있는 미리 작성된 코드(클래스 및 함수)를 포함하는 본체**이다.

</aside>

- 라이브러리 → 내 코드에서 라이브러리 코드를 사용
- 프레임워크 → 프레임워크에서 내 코드를 사용

자바에서 크게 프레임워크이면 아래 3가지 특성을 제공한다.

1. 이미 설계된 아키텍쳐, 알고리즘을 제공한다.
2. 클래스 및 인터페이스의 집합을 나타낸다
3. 선택사항이다.

컬렉션 프레임워크는 데이터 군을 다루기 위한 통합된 아키텍쳐를 제공한다. 즉 컬렉션은 인터페이스와 구현 클래스의 집합이며 데이터 군을 다루기 위한 알고리즘과 아키텍쳐가 준비되어 있다. 따라서 개발자는 이미 정의된 아키텍쳐와 알고리즘 안에서 코드를 채워 넣어서 컬렉션을 구현할 수 있다.

예를 들어 순서가 있는 데이터의 집합을 구현하기 위해서 list interface를 구현하면 순서 리스트 알고리즘과 아키텍쳐를 그대로 사용할 수 있다. 따라서 컬렉션은 프레임워크라 할 수 있다.

## 2. List / Set / Map Interface 요약

## 2-1. List Interface

<aside>
💥 List Interface는 저장순서가 유지되는 컬렉션을 구현하는데 사용된다.
- 중복 허용 : O
- 순서 유지 : X
- 구현체 : vector, LinkedList, ArrayList, stack

</aside>

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9f7727a9-cfb4-4240-a7ad-a49676a987be/Untitled.png)

- Method 요약

  ### *Method Summary*

  | Modifier and Type | Method and Description |
      | --- | --- |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/List.html e)Appends the specified element to the end of this list (optional operation). |
  | void | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#add-int-E-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/List.html element)Inserts the specified element at the specified position in this list (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#addAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/List.html> c)Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's iterator (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#addAll-int-java.util.Collection-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/List.html> c)Inserts all of the elements in the specified collection into this list at the specified position (optional operation). |
  | void | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#clear--()Removes all of the elements from this list (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns true if this list contains the specified element. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#containsAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Returns true if this list contains all of the elements of the specified collection. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#equals-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Compares the specified object with this list for equality. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/List.html | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#get-int-(int index) 특정 위치의 element를 반환한다. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#hashCode--()Returns the hash code value for this list. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#indexOf-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns the index of the first occurrence of the specified element in this list, or -1 if this list does not contain the element. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#isEmpty--()Returns true if this list contains no elements. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#iterator--()Returns an iterator over the elements in this list in proper sequence. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#lastIndexOf-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)   지정된 객체의 위치를 반환한다. List의 마지막 요소에서 부터 역방향으로 찾는다. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/ListIterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#listIterator--()  List 객체에 접근할 수 있는 Iterator를 반환한다 |
  | https://docs.oracle.com/javase/8/docs/api/java/util/ListIterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#listIterator-int-(int index) List 객체에 접근할 수 있는 Iterator를 반환한다. 지정된 index에서 부터 시작한다. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/List.html | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#remove-int-(int index)Removes the element at the specified position in this list (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Removes the first occurrence of the specified element from this list, if it is present (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#removeAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Removes from this list all of its elements that are contained in the specified collection (optional operation). |
  | default void | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#replaceAll-java.util.function.UnaryOperator-(https://docs.oracle.com/javase/8/docs/api/java/util/function/UnaryOperator.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> operator)Replaces each element of this list with the result of applying the operator to that element. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#retainAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Retains only the elements in this list that are contained in the specified collection (optional operation). |
  | https://docs.oracle.com/javase/8/docs/api/java/util/List.html | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#set-int-E-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/List.html element 지정된 index에 객체를 저장한다. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#size--()Returns the number of elements in this list. |
  | default void | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#sort-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/List.html> c) 지정된 https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html 에 따라서 List를 정렬한다.
    Sorts this list according to the order induced by the specified https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#spliterator--()Creates a https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html over the elements in this list. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/List.html<https://docs.oracle.com/javase/8/docs/api/java/util/List.html> | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#subList-int-int-(int fromIndex, int toIndex) fromIndex에서 toIndex에 있는 데이터를 반환한다. |
  | https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html[] | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#toArray--()Returns an array containing all of the elements in this list in proper sequence (from first to last element). |
  | <T> T[] | https://docs.oracle.com/javase/8/docs/api/java/util/List.html#toArray-T:A-(T[] a)Returns an array containing all of the elements in this list in proper sequence (from first to last element); the runtime type of the returned array is that of the specified array. |

## 2-2. Set Interface

<aside>
💥 Set Interface는 중복을 허용하지 않고 저장순서가 유지되지 않는 컬렉션을 반환한다.
- 중복 허용 : O
- 순서 유지 : X
- 구현체 : HashSet, TreeSet

</aside>

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/817cf173-9746-4849-9fdd-bcc2a654c5b8/Untitled.png)

- Method 요약

  ### *Method Summary*

  | Modifier and Type | Method and Description |
      | --- | --- |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/Set.html e)Adds the specified element to this set if it is not already present (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#addAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/Set.html> c)Adds all of the elements in the specified collection to this set if they're not already present (optional operation). |
  | void | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#clear--()Removes all of the elements from this set (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns true if this set contains the specified element. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#containsAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Returns true if this set contains all of the elements of the specified collection. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#equals-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Compares the specified object with this set for equality. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#hashCode--()Returns the hash code value for this set. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#isEmpty--()Returns true if this set contains no elements. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Set.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#iterator--()Returns an iterator over the elements in this set. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Removes the specified element from this set if it is present (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#removeAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Removes from this set all of its elements that are contained in the specified collection (optional operation). |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#retainAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Retains only the elements in this set that are contained in the specified collection (optional operation). |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#size--()Returns the number of elements in this set (its cardinality). |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Set.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#spliterator--()Creates a Spliterator over the elements in this set. |
  | https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html[] | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#toArray--()Returns an array containing all of the elements in this set. |
  | <T> T[] | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html#toArray-T:A-(T[] a)Returns an array containing all of the elements in this set; the runtime type of the returned array is that of the specified array. |

## 2-3. Map Interface

<aside>
💥 Map은 `key-value` 을 하나의 쌍으로 저장하여 구현하는 컬렉션 클래스이다
- 중복 허용 : Key는 허용하지 않지만 value는 허용
- 구현체 : HashSet, LinkdedHashMap, TreeMap

</aside>

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3d7f8fb5-5644-4c75-8ce8-07615a6c4d17/Untitled.png)

- Method 요약

  ### *Method Summary*

  | Modifier and Type | Method and Description |
      | --- | --- |
  | void | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#clear--()Removes all of the mappings from this map (optional operation). |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#compute-K-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> remappingFunction)Attempts to compute a mapping for the specified key and its current mapped value (or null if there is no current mapping). |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#computeIfAbsent-K-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> mappingFunction)If the specified key is not already associated with a value (or is mapped to null), attempts to compute its value using the given mapping function and enters it into this map unless null. |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#computeIfPresent-K-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> remappingFunction)If the value for the specified key is present and non-null, attempts to compute a new mapping given the key and its current mapped value. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#containsKey-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Returns true if this map contains a mapping for the specified key. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#containsValue-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html value)Returns true if this map maps one or more keys to the specified value. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,https://docs.oracle.com/javase/8/docs/api/java/util/Map.html>> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#entrySet--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Set.html view of the mappings contained in this map. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#equals-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Compares the specified object with this map for equality. |
  | default void | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#forEach-java.util.function.BiConsumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> action)Performs the given action for each entry in this map until all entries have been processed or the action throws an exception. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#get-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Returns the value to which the specified key is mapped, or null if this map contains no mapping for the key. |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#getOrDefault-java.lang.Object-V-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html defaultValue)Returns the value to which the specified key is mapped, or defaultValue if this map contains no mapping for the key. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#hashCode--()Returns the hash code value for this map. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#isEmpty--()Returns true if this map contains no key-value mappings. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Set.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#keySet--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Set.html view of the keys contained in this map. |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#merge-K-V-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html value, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> remappingFunction)If the specified key is not already associated with a value or is associated with null, associates it with the given non-null value. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#put-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html value)Associates the specified value with the specified key in this map (optional operation). |
  | void | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#putAll-java.util.Map-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> m)Copies all of the mappings from the specified map to this map (optional operation). |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#putIfAbsent-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html value)If the specified key is not already associated with a value (or is mapped to null) associates it with the given value and returns null, else returns the current value. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Removes the mapping for a key from this map if it is present (optional operation). |
  | default boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#remove-java.lang.Object-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key, https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html value)Removes the entry for the specified key only if it is currently mapped to the specified value. |
  | default https://docs.oracle.com/javase/8/docs/api/java/util/Map.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#replace-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html value)Replaces the entry for the specified key only if it is currently mapped to some value. |
  | default boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#replace-K-V-V-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html key, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html oldValue, https://docs.oracle.com/javase/8/docs/api/java/util/Map.html newValue)Replaces the entry for the specified key only if currently mapped to the specified value. |
  | default void | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#replaceAll-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/Map.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> function)Replaces each entry's value with the result of invoking the given function on that entry until all entries have been processed or the function throws an exception. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#size--()Returns the number of key-value mappings in this map. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.html> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#values--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html view of the values contained in this map. |

### 2-3-1. Map.Entry Interface

Map 내부 인터페이스인 Entry Interface는 `Key-value` 쌍을 다루기 위한 인터페이스이다. Map 구현시 반드시 Entry interface도 구현해야 한다.

```java
public interface Entry<K, V> {
        K getKey();

        V getValue();

        V setValue(V var1);

        boolean equals(Object var1);

        int hashCode();

        static <K extends Comparable<? super K>, V> Comparator<Entry<K, V>> comparingByKey() {
                return (Comparator)((Serializable)((c1, c2) -> {
                        return ((Comparable)c1.getKey()).compareTo(c2.getKey());
                }));
        }

        static <K, V extends Comparable<? super V>> Comparator<Entry<K, V>> comparingByValue() {
                return (Comparator)((Serializable)((c1, c2) -> {
                        return ((Comparable)c1.getValue()).compareTo(c2.getValue());
                }));
        }

        static <K, V> Comparator<Entry<K, V>> comparingByKey(Comparator<? super K> cmp) {
                Objects.requireNonNull(cmp);
                return (Comparator)((Serializable)((c1, c2) -> {
                        return cmp.compare(c1.getKey(), c2.getKey());
                }));
        }

        static <K, V> Comparator<Entry<K, V>> comparingByValue(Comparator<? super V> cmp) {
                Objects.requireNonNull(cmp);
                return (Comparator)((Serializable)((c1, c2) -> {
                        return cmp.compare(c1.getValue(), c2.getValue());
                }));
        }
}
```

- Method 요약

  ### *Method Summary*

  | Modifier and Type | Method and Description |
      | --- | --- |
  | static <K extends https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html<? super K>,V>https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<K,V>> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#comparingByKey--()Returns a comparator that compares https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html in natural order on key. |
  | static <K,V> https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<K,V>> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#comparingByKey-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super K> cmp)Returns a comparator that compares https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html by key using the given https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html. |
  | static <K,V extends https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html<? super V>>https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<K,V>> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#comparingByValue--()Returns a comparator that compares https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html in natural order on value. |
  | static <K,V> https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<K,V>> | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#comparingByValue-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super V> cmp)Returns a comparator that compares https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html by value using the given https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html. |
  | boolean | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#equals-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Compares the specified object with this entry for equality. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#getKey--()Returns the key corresponding to this entry. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#getValue--()Returns the value corresponding to this entry. |
  | int | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#hashCode--()Returns the hash code value for this map entry. |
  | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html | https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html#setValue-V-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html value)Replaces the value corresponding to this entry with the specified value (optional operation). |

# 3. List 구현체

1. ArrayList

   [ArrayList](https://www.notion.so/ArrayList-b71563365e9a4aad85b2f60dbc911ba5)

2. LinkedList

   [LinkedList](https://www.notion.so/LinkedList-1f4039b18b9d4fc497a8da3d8e5d3b09)

3. Stack

   [Stack](https://www.notion.so/Stack-9be1bbb787194fe0be96cbf62f48da0e)


| 리스트 | 설명 |
| --- | --- |
| Array | 정적인 길이를 제공하는 배열 |
| Vector | Java 1.0 에서 추가. 동기화 기능이 제공되는 가변이 가능한 자료구조 |
| ArrayList | Java 1.2 에서 추가. 동기화가 제공되지 않음. 데이터의 검색에 유리하며 추가, 삭제에는 성능을 고려해야 한다. → 아님 |
| LinkedList | Java 1.2 에서 추가. ArrayList 에 비해 데이터의 추가, 삭제에 유리하며 데이터 검색 시에는 성능을 고려해야 한다. |

# 4. Queue

1. Queue

   [Queue](https://www.notion.so/Queue-17f3b8680c8f4d11b7b71f0f5dbb9799)

2. PriorityQueue

   [PriorityQueue](https://www.notion.so/PriorityQueue-69fc2ac554ea4b4cb9d3f45aab608234)

3. Deque

   [Deque ( Double-Ended Queue )](https://www.notion.so/Deque-Double-Ended-Queue-7cce02a3a2df4f3a9efb338d32718b34)


# 5. Set

1. HashSet

   [HashSet](https://www.notion.so/HashSet-84db9f9bb5a34d02a83ac37c66cd3b75)

2. TreeSet

   [TreeSet](https://www.notion.so/TreeSet-28d0708fc3ce4fa0bca884969e709979)


# 6. Map

1. HashMap

   [HashMap](https://www.notion.so/HashMap-2f04e4924eb74c8b810831a6ce8248ac)

2. TreeMap
    - 이진검색트리 형태로 키와 값이 쌍으로 이루어진 데이터를 저장
    - 범위검색이나 정렬의 경우 TreeMap을 사용하는 것이 좋다
3. Properties
    - HashTable을 상속받아 구현한 Map
    - Properties는 무조건 <String,String>으로 저장
    - 파일을 읽고 쓰는데 주로 사용

# 7. 멀티쓰레드에 최적화된 컬렉션

- ConcurrentSkipListSet
- ConcurrentHashMap
- ConcurrentSkipListMap
- ConcurrentLinkedQueue

# 8. Iterator

# 9. Comparator와 Comparable

Comparator와 Comparable모두 컬렉션을 정렬하는데 필요한 메소드를 정의한 인터페이스이다.

**Comparable**

- **기본 정렬기준을 구현하는데 사용**
- **같은 타입의 인스턴스끼리 비교할 수 있는 것들에 사용**
- Comparable은 정렬이 가능한 클래스임을 나타냄
- 모든 Wrapper 클래스와 String, Date,File이 Comparable을 구현함

Comparator

- **기본 정렬기준 외에 다른 기준으로 정렬하고자 사용 ( 내림차순, 올림차순 이외에 )**

두 인터페이스의 비교 메소드 모두 int를 반환하며 두 객체가 같으면 0, 비교하는 값보다 작으면 음수, 비교하는 값보다 크면 양수를 반환한다

**Comparable로 구현**

```java
public class Card implements Comparable {
	//...생략
	/**
	 * Compatable을 구현
	 * */
	@Override
	public int compareTo( Object obj ) {
			
			if ( obj instanceof Card ) {
					Card target = (Card) obj;
					return number < target.number ? -1 : 1; //오름차순
			}
			return -1;
	}

/**
 * Comparotor를 구현
 * */
@Override
public int compare( Object obj1, Object obj2 ) {
		
		if ( obj1 instanceof Card && obj2 instanceof Card ) {
				Card target1 = (Card) obj1;
				Card target2 = (Card) obj2;
				
				return target1.compareTo( obj2 );
		}
		
		return -1;
}
}

```

# 10. Arrays

공사중

# — 참고

1. 자바에서의 Framework

   [What is Framework in Java - Javatpoint](https://www.javatpoint.com/what-is-framework-in-java)

2. Java Util Tree

   [java.util Class Hierarchy (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/package-tree.html)

3. Collection Interface

   [Collection (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html)

4. 참고

   [GrepIU](https://www.grepiu.com/post/9)