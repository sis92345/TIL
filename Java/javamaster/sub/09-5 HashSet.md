# 1. HashSet

<aside>
💥 Set은 중복된 요소를 저장하지 않으며 저장순서를 유지하지 않는다.
HashSet은 중복제거 요소로서 HashMap을 사용해서 중복을 제거한다.

</aside>

- Set은 중복을 허용하지 않는다

    ```java
    /**
     * set은 중복을 허용하지 않는다.
     * */
    @Test
    public void setTest() {
    		
    		HashSet<Integer> set = new HashSet<>();
    		
    		set.add( 1 );
    		set.add( 1 );
    		
    		assertThat( set.size() ).isEqualTo( 1 );
    }
    ```

- HashSet은 순서를 보장하지 않는다. 순서를 보장하는 Set을 사용하려면 LinkedHashSet을 사용하면 된다.

    ```java
    /**
     * Adds the specified element to this set if it is not already present.
     * More formally, adds the specified element {@code e} to this set if
     * this set contains no element {@code e2} such that
     * {@code Objects.equals(e, e2)}.
     * If this set already contains the element, the call leaves the set
     * unchanged and returns {@code false}.
     *
     * @param e element to be added to this set
     * @return {@code true} if this set did not already contain the specified
     * element
     */
    public boolean add(E e) {
        return map.put(e, PRESENT)==null;
    }
    ```

- HashSet의 Set은 중복검사를 `equals()` 와 `hashCode()`를 사용해서 중복검사를 하기 때문에 다른 인스턴스라면 중복체크가 되지 않는다.

    ```java
    @Override
    public int hashCode() {
    		return ( kind ).hashCode();
    }
    
    @Override
    public boolean equals( Object obj ) {
    		
    		if ( obj instanceof Card ) {
    				Card target = (Card) obj;
    				return target.kind.equals( ((Card) obj).getKind() );
    		}
    		else {
    				return super.equals( obj );
    		}
    }
    
    /**
     * 여기서 set을 하면
     * 객체끼리의 Set 1 : set의 기본
     * */
    @Test
    public void setTest2() {
    		
    		Card heart = new Card( Kind.HEART );
    		Card space = new Card( Kind.SPACE );
    		
    		HashSet<Card> set = new HashSet<>();
    		
    		set.add( heart );
    		set.add( new Card( Kind.HEART ) );
    		
    		System.out.println( set );
    }
    
    // 중복 제거 완료
    [oopbasic.Card@707194ba]
    ```


# 2. HashSet의 구현 원리

HashSet은 HashMap을 사용한다. HashMap의 Key로 사용자가 입력한 요소를 넣고, Value로 내부에 가진 값을 넣는다. 따라서 Set에서 인스턴스간 중복검사를 더 철저히 하기위해서 각 Object의 equals와 hashCode를 오버라이딩해야 한다.

# 3. 시간복잡도

***HashSet* , *LinkedHashSet* 및 *EnumSet의* 경우 add *(), remove()* 및 *contains() 작업은 내부 HashMap* 구현 덕분에 일정한 *O(1) 시간이 소요됩니다***

# 99. 참고사항

- 1. Method 요약

### *Method Summary*

| Modifier and Type | Method and Description |
    | --- | --- |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html e) set에 이미 존재하지 않는다면 요소를 추가한다. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#clear--() set의 모든 요소를 제거한다. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#clone--() hashSet instance의 얕은복사 : 요소 그 자체는 클론 안됨 |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o) set에 특정 요소가 있는지 판별 |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#isEmpty--() set에 아무것도 없으면 true를 반환 |
| https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#iterator--() iterator 반환 |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o) set에 데이터가 존재한다면 삭제 |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#size--()Returns the number of elements in this set (its cardinality). |
| https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html#spliterator--()Creates a https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html#binding and fail-fast https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html over the elements in this set. |
1. Collection의 시간 복잡도

[](https://www.baeldung.com/java-collections-complexity)