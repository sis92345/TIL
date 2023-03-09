# 1. TreeSet

<aside>
💥 Set은 중복된 요소를 저장하지 않으며 저장순서를 유지하지 않는다.
TreeSet은 이진 검색 트리라는 자료구조의 형태로 데이터를 저장한다.

</aside>

# 2. 이진 검색 트리 ( Binary Search Tree )

이진검색트리는 여러 개의 Node가 서로 연결된 구조이다. 각 노드는 최대 2개의 Node를 연결할 수 있으며 루트라고 불리는 하나의 노드에서부터 시작해서 계속 확장해나갈 수 있다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9939c987-8bb1-40ad-902b-12c638adb622/Untitled.png)

![https://velog.velcdn.com/images%2Fseochan99%2Fpost%2Fbfbe7cbc-770b-462d-b8b1-108a60bfdc5f%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-04-15%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%208.48.51.png](https://velog.velcdn.com/images%2Fseochan99%2Fpost%2Fbfbe7cbc-770b-462d-b8b1-108a60bfdc5f%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-04-15%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%208.48.51.png)

트리 노드의 구조

```java
class TreeNode {
	TreeNode left;
	Object   element; // 객체 저장을 위한 참조 변수
	TreeNode right;
}
```

이진 트리의 저장 구조, 작은값은 왼쪽에, 큰 값은 오른쪽에 저장됨

이진 검색 트리는 아래의 특징을 가진다.

1. 모든 노드는 최대 2개의 노드를 가진다
2. 왼쪽 자식노드의 값은 부모보다 작다. 오른쪽 자식노드의 값은 부모노드의 값보다 커야한다.
3. 노드의 추가삭제에 시간이 걸린다
4. 범위검색과 정렬에 유리
5. 중복된 값을 저장하지 못한다.

# 3. Set의 기본적인 사용

```java
/**
 * TreeSet의 기본 사용
 * */
@Test
public void treeSetTest() {
		
		Set<Integer> set = new TreeSet<>();
		
		for ( int i = 0; set.size() < 6; i++ ) {
				int num = (int)(Math.random()*45)+1;
				set.add( num );
		}
		
		System.out.println( set );
}

```

TreeSet에 저장된 객체가 Comparable를 구현하지 않던가 Comparator를 제공하지 않으면 순서를 모르기 때문에 사용할 수 없다. 따라서 Set에 저장될 객체는 Comparable을 구현하던가 Comparator를 제공해야 한다.

```java
public class Card implements Comparable {
	//...생략
	@Override
	public int compareTo( Object obj ) {
			
			if ( obj instanceof Card ) {
					Card target = (Card) obj;
					return number < target.number ? -1 : 1;
			}
			return -1;
	}
}
```

```java
/**
 * TreeSet의 일반적인 객체일 경우 비교가 불가능하기 때문에 각 요소는 Comparable또는 Comparator를 구현해야 한다.
 * */
@Test
public void treeSetTest2() {
		
		Card heart = new Card( Kind.HEART , 2 );
		Card space = new Card( Kind.SPACE , 1 );
		
		Set<Card> set = new TreeSet<>();
		set.add( space );
		set.add( heart );
		
		Iterator<Card> iterator = set.iterator();
		
		for ( Iterator<Card> it = iterator; it.hasNext(); ) {
				Card card = it.next();
				
				System.out.println( card.getNumber() );
		}
}

// 테스트 결과 1,2
```

# 4. 시간 복잡도

참고

[Computational complexity of TreeSet operations in Java?](https://stackoverflow.com/questions/3390449/computational-complexity-of-treeset-operations-in-java)

# 99. 참고사항

- 1. Method 요약

### *Method Summary*

| Modifier and Type | Method and Description |
    | --- | --- |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#add-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html e)Adds the specified element to this set if it is not already present. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#addAll-java.util.Collection-(https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> c)Adds all of the elements in the specified collection to this set. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#ceiling-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html e)Returns the least element in this set greater than or equal to the given element, or null if there is no such element. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#clear--()Removes all of the elements from this set. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#clone--()Returns a shallow copy of this TreeSet instance. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#comparator--()Returns the comparator used to order the elements in this set, or null if this set uses the https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html of its elements. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#contains-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Returns true if this set contains the specified element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#descendingIterator--()Returns an iterator over the elements in this set in descending order. |
| https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#descendingSet--()Returns a reverse order view of the elements contained in this set. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#first--()Returns the first (lowest) element currently in this set. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#floor-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html e)Returns the greatest element in this set less than or equal to the given element, or null if there is no such element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#headSet-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html toElement)Returns a view of the portion of this set whose elements are strictly less than toElement. |
| https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#headSet-E-boolean-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html toElement, boolean inclusive)Returns a view of the portion of this set whose elements are less than (or equal to, if inclusive is true) toElement. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#higher-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html e)Returns the least element in this set strictly greater than the given element, or null if there is no such element. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#isEmpty--()Returns true if this set contains no elements. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#iterator--()Returns an iterator over the elements in this set in ascending order. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#last--()Returns the last (highest) element currently in this set. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#lower-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html e)Returns the greatest element in this set strictly less than the given element, or null if there is no such element. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#pollFirst--()Retrieves and removes the first (lowest) element, or returns null if this set is empty. |
| https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#pollLast--()Retrieves and removes the last (highest) element, or returns null if this set is empty. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html o)Removes the specified element from this set if it is present. |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#size--()Returns the number of elements in this set (its cardinality). |
| https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#spliterator--()Creates a https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html#binding and fail-fast https://docs.oracle.com/javase/8/docs/api/java/util/Spliterator.html over the elements in this set. |
| https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#subSet-E-boolean-E-boolean-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html fromElement, boolean fromInclusive, https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html toElement, boolean toInclusive)Returns a view of the portion of this set whose elements range from fromElement to toElement. |
| https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#subSet-E-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html fromElement, https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html toElement)Returns a view of the portion of this set whose elements range from fromElement, inclusive, to toElement, exclusive. |
| https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#tailSet-E-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html fromElement)Returns a view of the portion of this set whose elements are greater than or equal to fromElement. |
| https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html<https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html> | https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html#tailSet-E-boolean-(https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html fromElement, boolean inclusive)Returns a view of the portion of this set whose elements are greater than (or equal to, if inclusive is true) fromElement. |
1. Collection의 시간 복잡도

[](https://www.baeldung.com/java-collections-complexity)