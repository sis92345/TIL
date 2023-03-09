# 1. HashMap

<aside>
💥 Map은 키와 값을 하나의 쌍으로 데이터를 가진다. 키는 중복을 허용하지 않지만, 값은 중복을 허용한다.

</aside>

HashMap은 key-value를 가진 내부 클래스 Node배열로 데이터를 관리한다.

```java
transient Node<K,V>[] table;
```

- Node

    ```java
    static class Node<K,V> implements Map.Entry<K,V> {
            final int hash;
            final K key;
            V value;
            Node<K,V> next;
    
            Node(int hash, K key, V value, Node<K,V> next) {
                this.hash = hash;
                this.key = key;
                this.value = value;
                this.next = next;
            }
    
            public final K getKey()        { return key; }
            public final V getValue()      { return value; }
            public final String toString() { return key + "=" + value; }
    
            public final int hashCode() {
                return Objects.hashCode(key) ^ Objects.hashCode(value);
            }
    
            public final V setValue(V newValue) {
                V oldValue = value;
                value = newValue;
                return oldValue;
            }
    
            public final boolean equals(Object o) {
                if (o == this)
                    return true;
                if (o instanceof Map.Entry) {
                    Map.Entry<?,?> e = (Map.Entry<?,?>)o;
                    if (Objects.equals(key, e.getKey()) &&
                        Objects.equals(value, e.getValue()))
                        return true;
                }
                return false;
            }
        }
    ```

- Map의 기본

    ```java
    /**
     * Map 기본
     * */
    @Test
    public void mapTest() {
    		
    		Map<Kind, Card> map = new HashMap<>();
    		
    		
    		map.put( Kind.SPACE , new Card() );
    }
    ```


# 2. 시간 복잡도



```
시간복잡도
get           : O(1)
containsKey   : O(1)
next          : O(h/n) h는 테이블 용량
java 1.2 에서 나옴
특징 : 순서에 상관없이 저장됨, Null을 허용한다. thread-safe 보장하지 않는다.
```

참고

[Computational complexity of TreeSet operations in Java?](https://stackoverflow.com/questions/3390449/computational-complexity-of-treeset-operations-in-java)

# 99. 참고사항

- 1. Method 요약

### *Method Summary*

| Modifier and Type | Method and Description |
    | --- | --- |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#clear--()Removes all of the mappings from this map. |
| https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#clone--()Returns a shallow copy of this HashMap instance: the keys and values themselves are not cloned. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#compute-K-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> remappingFunction)Attempts to compute a mapping for the specified key and its current mapped value (or null if there is no current mapping). |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#computeIfAbsent-K-java.util.function.Function-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> mappingFunction)If the specified key is not already associated with a value (or is mapped to null), attempts to compute its value using the given mapping function and enters it into this map unless null. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#computeIfPresent-K-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> remappingFunction)If the value for the specified key is present and non-null, attempts to compute a new mapping given the key and its current mapped value. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#containsKey-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Returns true if this map contains a mapping for the specified key. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#containsValue-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html value)Returns true if this map maps one or more keys to the specified value. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Set.html<https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html<https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html>> | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#entrySet--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Set.html view of the mappings contained in this map. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#forEach-java.util.function.BiConsumer-(https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> action)Performs the given action for each entry in this map until all entries have been processed or the action throws an exception. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#get-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Returns the value to which the specified key is mapped, or null if this map contains no mapping for the key. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#getOrDefault-java.lang.Object-V-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html defaultValue)Returns the value to which the specified key is mapped, or defaultValue if this map contains no mapping for the key. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#isEmpty--()Returns true if this map contains no key-value mappings. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Set.html<https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#keySet--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Set.html view of the keys contained in this map. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#merge-K-V-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html value, https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> remappingFunction)If the specified key is not already associated with a value or is associated with null, associates it with the given non-null value. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#put-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html value)Associates the specified value with the specified key in this map. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#putAll-java.util.Map-(https://docs.oracle.com/javase/8/docs/api/java/util/Map.html<? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> m)Copies all of the mappings from the specified map to this map. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#putIfAbsent-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html value)If the specified key is not already associated with a value (or is mapped to null) associates it with the given value and returns null, else returns the current value. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#remove-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key)Removes the mapping for the specified key from this map if present. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#remove-java.lang.Object-java.lang.Object-(https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html key, https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html value)Removes the entry for the specified key only if it is currently mapped to the specified value. |
| https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#replace-K-V-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html value)Replaces the entry for the specified key only if it is currently mapped to some value. |
| boolean | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#replace-K-V-V-(https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html key, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html oldValue, https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html newValue)Replaces the entry for the specified key only if currently mapped to the specified value. |
| void | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#replaceAll-java.util.function.BiFunction-(https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html<? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? super https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html,? extends https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> function)Replaces each entry's value with the result of invoking the given function on that entry until all entries have been processed or the function throws an exception. |
| int | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#size--()Returns the number of key-value mappings in this map. |
| https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html<https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html> | https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html#values--()Returns a https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html view of the values contained in this map. |
1. Collection의 시간 복잡도

[](https://www.baeldung.com/java-collections-complexity)