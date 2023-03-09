# 1. ArrayList

Collection Framework에서 가장 많이 사용하는 컬렉션 클래스이다. 리스트 인터페이스를 구현하기 때문에 중복을 허용하고 순서를 보장한다.

ArrayList는 Vector의 구현원리와 기능적인 측면에서 동일하다. 다만 Vector의 경우 Collection 이전부터 존재하던 클래스이기 때문에 ArrayList를 사용하는 것이 좋다

## 1-1. 시간복잡도

```
시간 복잡도 
add             : O(1), 최악의 경우 O(n)
remove          : O(n), 삭제하기 위해 전체 리스트를 반복한다.
get             : O(1)
Contains        : O(n)
iterator.remove : O(n)
```

# 2. ArrayList 유의사항1 : add

**ArrayList는 지정된 capacity를 초과하면 새 배열을 생성한 후 데이터를 복사하는 방식으로 배열을 늘린다. 다만 불필요하게 큰 capacity는 불필요하게 메모리를 많이 차지한다는 단점도 있다.**

새배열의 길이는 jdk 마다 다른것으로 추정된다. 이 문서에 쓰인 java는 zulu-open-jdk-11인데 +1되어서 반환된다.

1. 데이터를 추가한다 `add( data )` . 이때 capacity만큼 데이터가 있다면 grow() 메소드를 실행한다.

    ```java
    public boolean add(E e) {
            ++this.modCount;
            this.add(e, this.elementData, this.size);
            return true;
    }
    
    //...
    private void add(E e, Object[] elementData, int s) {
            if (s == elementData.length) {
                    elementData = this.grow();
            }
    
            elementData[s] = e;
            this.size = s + 1;
    }
    ```

2. `grow()` 메소드는 새로운 capacity를 계산 한 후 새로운 capacity 만큼의 배열에 기존 데이터를 복사해서 새로운 객체 배열 인스턴스를 반환한다.
    - newCapacity 메소드 : zulu-open-jdk-11 기준

        ```java
        	private int newCapacity(int minCapacity) {// 10
                int oldCapacity = this.elementData.length;          // 10
                int newCapacity = oldCapacity + (oldCapacity >> 1); // 5
                if (newCapacity - minCapacity <= 0) { // 5 - 10 <= 0 -> true
                        if (this.elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
                                return Math.max(10, minCapacity); //  11 
                        } else if (minCapacity < 0) {
                                throw new OutOfMemoryError();
                        } else {
                                return minCapacity;
                        }
                } else {
                        return newCapacity - 2147483639 <= 0 ? newCapacity : hugeCapacity(minCapacity);
                }
        }
        ```


    ```java
    private Object[] grow(int minCapacity) { // minCapacity = this.size + 1
            return this.elementData = Arrays.copyOf(this.elementData, this.newCapacity(minCapacity));
    }
    ```

3. **따라서 일반적인 add는 $O^1$이지만 최악의 경우 $O^n$ 의 시간 복잡도를 가진다. 따라서 삽입이 빈번한 리스트의 경우 저장할 요소의 개수를 고려해서 실제 저장할 개수보다 약간 더 많게 설정하는 것이 좋다**

    ```java
    @Test
    @DisplayName( "Capacity에 따른 시간 측정" )
    public void 시간_측정_테스트() {
    
    		List<String> addDynamic = new ArrayList<>();
    		List<String> addInitCapacity = new ArrayList<>( 10000000 );
    		
    		long startTime = System.currentTimeMillis();
    		
    		// 1. 일반
    		for ( int i = 0; i < 10000000; i++ ) {
    				
    				addDynamic.add( i , "Test" );
    		}
    		
    		printRunTime( startTime );
    		
    		startTime = System.currentTimeMillis();
    		
    		// 2. 초기 값 설정
    		for ( int i = 0; i < 10000000; i++ ) {
    				
    				addInitCapacity.add( i , "test" );
    		}
    		
    		printRunTime( startTime );
    }
    
    // addDynamic.     -> 438 MS
    // addInitCapacity -> 139 MS
    ```


# 3. ArrayList 주의사항2 : remove

순서대로 삭제하면 삭제 후 삭제된 인덱스 이후 배열의 인덱스를 다시 업데이트해야 하기 때문에 순서대로 삭제할 경우 속도가 매우 느리다.

하지만 역순으로 삭제할 경우 다시 업데이트해야 할 데이터가 없기 때문에 속도가 빠르다

```java
@Test
@DisplayName( "삭제 시간 측정 : 순서 vs 역순" )
public void 시간_측정_테스트2() {
		
		List<Integer> orderRemove = new ArrayList<>( 5000000 );
		List<Integer> notOrderRemove = new ArrayList<>( 5000000 );
		Integer[] values = new Integer[1000];
		
		for ( int i = 0; i < 5000000 ; i++ ) {
				
				orderRemove.add(  i );
				notOrderRemove.add( i );
		}
		
		// 순서 삭제 : 삭제 시 나머지 인덱스를 재배치 해야 하므로 속도 느림
		long startTime = System.currentTimeMillis();
		
		for ( Integer item : values ) {
				
				orderRemove.remove( item );
		}
		
		printRunTime( startTime );
		
		// 역순 삭제 : 삭제 시 나머지 인덱스를 재배치 해야 하므로 속도 느림
		startTime = System.currentTimeMillis();
		
		for ( int i = notOrderRemove.size() ; i > 0 ; i-- ) {
				
				notOrderRemove.remove( i - 1 );
		}
		
		printRunTime( startTime );
		
}

// 순서 삭제 -> 1979 MS
// 역순 삭제 -> 24 MS
```

# 4. 구현 원리

<aside>
💥 ArrayList는 Object 배열을 사용해서 데이터를 순차적으로 저장한다.

</aside>

```java
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, Serializable {
      private static final long serialVersionUID = 8683452581122892189L;
      private static final int DEFAULT_CAPACITY = 10;
      private static final Object[] EMPTY_ELEMENTDATA = new Object[0];
      private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = new Object[0];
      **transient Object[] elementData;**

			//... 생략
}
```

# 5. Constructor

| 생성자 | 설명 |
| --- | --- |
| ArrayList() | 10개의 capacity를 가지는 빈 배열을 생성한다.  |
| https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#ArrayList-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?extends https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
> c) | 특정 Collectiond에 존재하는 list로 ArrayList를 생성합니다. |
| https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#ArrayList-int-
(int initialCapacity) | 지정된 capacity 만큼 list 초기 size를 생성한다. |

```java
@Test
@DisplayName( "ArrayList - 생성자" )
public void ArrayListTest1() {
		
		Random ineRandom = new Random();
		
		// 1. 기본 생성자 : 10개 사이즈를 가지는 배열 객체를 생성
		List<Integer> list = new ArrayList<>();
		
		list.add( ineRandom.nextInt() );
		list.add( ineRandom.nextInt() );
		list.add( ineRandom.nextInt() );
		list.add( ineRandom.nextInt() );
		list.add( ineRandom.nextInt() );
		
		// 2. Collection을 받는 생성자
		List<Integer> copiedList = new ArrayList<>( list.subList( 3 , 5 ) );
		
		// 3. 초기 사이즈를 받는 생성자
		List<Integer> manyInitSize = new ArrayList<>( 100 );
		
		Collections.sort( list );
		Collections.sort( copiedList );
		
		list.retainAll( copiedList );
		
		System.out.println( "List 1 : " + Arrays.toString( list.toArray() ) );
		System.out.println( "CopiedList : " + Arrays.toString( copiedList.toArray() ) );
		
		assertThat( list.get( 0 ) ).isEqualTo( copiedList.get( 0 ) );
}
```

---

# 99. 참고사항

- 1. Method 요약

### *Method Summary*

| Modifier and Type | Method and Description |
    | --- | --- |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html e)Appends the specified element to the end of this list. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#add-int-E-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html element)Inserts the specified element at the specified position in this list. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#addAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> c)Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's Iterator. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#addAll-int-java.util.Collection-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> c)Inserts all of the elements in the specified collection into this list, starting at the specified position. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#clear--()Removes all of the elements from this list. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#clone--()Returns a shallow copy of this ArrayList instance. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns true if this list contains the specified element. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#ensureCapacity-int-(int minCapacity)Increases the capacity of this ArrayList instance, if necessary, to ensure that it can hold at least the number of elements specified by the minimum capacity argument. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#forEach-java.util.function.Consumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> action)Performs the given action for each element of the Iterable until all elements have been processed or the action throws an exception. |
| https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#get-int-(int index)Returns the element at the specified position in this list. |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#indexOf-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns the index of the first occurrence of the specified element in this list, or -1 if this list does not contain the element. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#isEmpty--()Returns true if this list contains no elements. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#iterator--()Returns an iterator over the elements in this list in proper sequence. |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#lastIndexOf-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns the index of the last occurrence of the specified element in this list, or -1 if this list does not contain the element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/ListIterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#listIterator--()Returns a list iterator over the elements in this list (in proper sequence). |
| https://docs.oracle.com/javase/8/docs/api/java/util/ListIterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#listIterator-int-(int index)Returns a list iterator over the elements in this list (in proper sequence), starting at the specified position in the list. |
| https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#remove-int-(int index)Removes the element at the specified position in this list. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Removes the first occurrence of the specified element from this list, if it is present. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#removeAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Removes from this list all of its elements that are contained in the specified collection. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#removeIf-java.util.function.Predicate-(https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> filter)Removes all of the elements of this collection that satisfy the given predicate. |
| protected void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#removeRange-int-int-(int fromIndex, int toIndex)Removes from this list all of the elements whose index is between fromIndex, inclusive, and toIndex, exclusive. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#replaceAll-java.util.function.UnaryOperator-(https://docs.oracle.com/javase/8/docs/api/java/util/function/UnaryOperator.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> operator)Replaces each element of this list with the result of applying the operator to that element. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#retainAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<?> c)Retains only the elements in this list that are contained in the specified collection. |
| https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#set-int-E-(int index, https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html element)Replaces the element at the specified position in this list with the specified element. |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#size--()Returns the number of elements in this list. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#sort-java.util.Comparator-(https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> c)Sorts this list according to the order induced by the specified https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#spliterator--()Creates a https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html#binding and fail-fast https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html over the elements in this list. |
| https://docs.oracle.com/javase/8/docs/api/java/util/List.html<https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html> | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#subList-int-int-(int fromIndex, int toIndex)Returns a view of the portion of this list between the specified fromIndex, inclusive, and toIndex, exclusive. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html[] | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#toArray--()Returns an array containing all of the elements in this list in proper sequence (from first to last element). |
| <T> T[] | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#toArray-T:A-(T[] a)Returns an array containing all of the elements in this list in proper sequence (from first to last element); the runtime type of the returned array is that of the specified array. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#trimToSize--()Trims the capacity of this ArrayList instance to be the list's current size. |
1. Collection의 시간 복잡도

[](https://www.baeldung.com/java-collections-complexity)