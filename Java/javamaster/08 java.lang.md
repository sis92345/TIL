# 1. Java.lang 패키지

> java.lang 패키지는 자바프로그래밍에 가장 기본이 되는 클래스들을 포함한다. 그렇기 때문에 java.lang패키지의 클래스들은 import문 없이 사용 할 수 있게 된다.
>

---

## 1.1 Object 클래스

Object 클래스를 자세히 알아보자

> Object는 최상위 클래스 이다.
>

그렇기 때문에 Object의 멤버들은 모든 클래스에서 사용이 가능하다

protecte 키워드로 붙은 것은 모두 직접 구현해야 한다.

---

| Object 클래스의 메서드 | 설명 |
| --- | --- |
| protected Object clone() | 객체 자신의 복사본을 반환한다. |
| public boolean equals(Object objec) | 객제 자신과 객체 obj가 같은 객체인지 알려준다 |
| protected void finalize()
| 객체가 소멸될 때 가비지 컬렉터에 의해 자동적으로 호출된다. 이 때 수행되어야 하는 코드가 있을 때 오버라이딩한다(거의 사용안함) |
| public Class getClass() | 객체 자신의 클래스 정보를 담고 있는 Class 인스턴스를 반환한다. |
| public int hashCode() | 객체 자신의 해시코드를 반환한다. |
| public String toString() |  객체 자신의 정보를 문자열로 반환한다. |
| public void notify() | 객체 자신을 사용하려고 기다리는 쓰레드를 하나만 깨운다 |
| public void notifyAll() | 객체 자신을 사용하려고 기다리는 모든 쓰레드를 깨운다 |
| public void wait()
public void wait(long timeout)
public void wait(long timeout,int nanos) | 다른 쓰레드가 notify()나 notifyAll()을 호출할 때까지 현재 쓰레드를 무한히 또는 지정된 시간(timeout,nanos)동안 기다리게 한다.
(timeout은 천분의 1초, nanos는 10의 3승분의 1초) |

예시 )

1) equals

```
packageorg.example.tv;

public class EqualTest {

}

```

test

```
    @Test
voidname() {
        EqualTest test =newEqualTest();
        EqualTest test2 =newEqualTest();

        System.out.println(test.equals(test2)); //false 출력
    }
}
```

※ 해당 클래스는 object 클래스기 때문에 오버라이딩 할 수 있다.

```
package org.example.tv;

public class EqualTest {

	public EqualTest() {
		super();
	}
	
  @Override
	public int hashCode() {
		return super.hashCode();
  }
	
  @Override
	public boolean equals(Object obj) {
		return super.equals(obj);
  }
	
  @Override
	protected Object clone() throws CloneNotSupportedException {
		return super.clone();
  }

  @Override
	public String toString() {
		return super.toString();
  }
	
  @Override
	protected void finalize() throwsThrowable {
		 super.finalize();
  }
}

```

## 얕은 복사와 깊은 복사

복제와 복사의 개념을 알고 가자

- 복사와 복제 사전적 의미

  > 복사: 다른곳에 쓰여진 내용이나 또는 그림을 그대로 옮겨 쓰거나 또는 그리는 일
  복제:본래의 것과 똑같은 것을 만듦. 또는 그렇게 만든 것.
>

프로그램적 언어도 똑같다

복사 → 같은 인스턴스 주소를 공유하는것

복제 → 값을 똑같이 가지는 하나의 인스턴스를 만드는것

ex) 얕은 복사

```java
package org.example.ofTestCopy;

public class ShallowCopy {

    public int a;
    public int b;

    @Override
    public String toString() {
        return "ShallowCopy{" +
                "a=" + a +
                ", b=" + b +
                '}';
    }
}

```

위의 코드가 있다



```java
package org.example.ofTestCopy;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class ShallowCopyTest {

    @Test
    @DisplayName("얕은복사 테스트")
    void shallowCopyTest() {
        ShallowCopy copy = new ShallowCopy();

        ShallowCopy copyObject = copy;

        copy.a = 10;
        System.out.println(copy.a); //10
        copyObject.a = 20;
        System.out.println(copy.a); //20

        assertThat(copy).isEqualTo(copyObject);

    }
}
```

copyObject를 변경했지만 copy의 a가 값이 바뀌었다

clone은 얕은 복사이다

## **1.2 String클래스**

char 와는 다른 String은 클래스이다

### **변경 불가능한(immutable)클래스**

String클래스는 값이 한번 등록되면 바뀌지 않는다 확인해 보자

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

public class StringTest {

   @Test
   void name() {
       String test = "1234";
       System.out.println(test.hashCode()); //1509442
       test = "3456";
       System.out.println(test.hashCode()); //1571010
  }
}
```

위처럼 같은 test에 값을 넣어도 해쉬값이 달라지는것을 볼수 있다

![https://user-images.githubusercontent.com/85658845/205300912-49ca3be8-b85e-4c3a-9e0d-5f966d520282.png](https://user-images.githubusercontent.com/85658845/205300912-49ca3be8-b85e-4c3a-9e0d-5f966d520282.png)

### **문자열 비교**

문자열은 == 으로 비교할수 없다 각자의 인스턴스 주소가 다르기 때문에 다르다고 나온다

문자열 비교는 equals를 사용하자

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class StringTest {

   @Test
   void name() {
      String a = "가나다라";
      String b = "가나다라";
      String c = new String("가나다라");
      String d = new String("가나다라");

       System.out.println(a == b); true
       System.out.println(c == d); false
       System.out.println( a.equals(b)); true
       System.out.println(c.equals(d)); true
  }
}
```

### **빈 문자열(empty string)**

char과는 다르게 String 은 배열이기 때문에 길이가 0인 빈 문자열이 가능하다

### **String클래스의 생성자와 메서드**

[https://t1.daumcdn.net/cfile/tistory/217D0143552A657317](https://t1.daumcdn.net/cfile/tistory/217D0143552A657317)

[https://t1.daumcdn.net/cfile/tistory/2117203D552A64FF2A](https://t1.daumcdn.net/cfile/tistory/2117203D552A64FF2A)

[https://t1.daumcdn.net/cfile/tistory/2523303D552A650023](https://t1.daumcdn.net/cfile/tistory/2523303D552A650023)

[https://t1.daumcdn.net/cfile/tistory/222EAB3D552A65021C](https://t1.daumcdn.net/cfile/tistory/222EAB3D552A65021C)

[https://t1.daumcdn.net/cfile/tistory/24721E41552A66B519](https://t1.daumcdn.net/cfile/tistory/24721E41552A66B519)

[https://t1.daumcdn.net/cfile/tistory/2320543D552A650725](https://t1.daumcdn.net/cfile/tistory/2320543D552A650725)

### **join() 과 StringJoiner**

구분자를 넣어 합치는 메서드

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class StringTest {

   @Test
   void name() {
      String animal = "dog,cat,bear";
      String[] arr = animal.split(",");
      String str = String.join("-",arr);
       System.out.println(str); // dog-cat-bear
  }
}
```

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

import java.util.StringJoiner;

import static org.assertj.core.api.Assertions.assertThat;

public class StringTest {

   @Test
   void name() {
      String animal = "dog,cat,bear";
      String[] arr = animal.split(",");
      System.out.println(String.join("-",arr)); //dog-cat-bear
      StringJoiner sj = new StringJoiner("/","[","]");
       for (String s:
            arr) {
           sj.add(s);
      }

       System.out.println(sj.toString()); //[dog/cat/bear]
  }
}
```

### **문자 인코딩 변환**

getByte(charsetName)으로 변활 할 수 있다만 알면 된다

### **String.format()**

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

import java.util.StringJoiner;

import static org.assertj.core.api.Assertions.assertThat;

public class StringTest {

  @Test
  void name() {
      String str = String.format("%d",1);
      System.out.println(str);
  }
}
```

printf 처럼 사용 가능 C언어에서 왔다

### **기본형 값을 String으로 변환**

모든 기본형 + ""

or

String.valueof(기본형)

String -> 기본형

int i = Integer.parseInt(String)

[https://t1.daumcdn.net/cfile/tistory/998A543E5B72BD0F20](https://t1.daumcdn.net/cfile/tistory/998A543E5B72BD0F20)

## **1.3 StringBuffer클래스와 StringBuilder**

### StringBuffer: 내부적으로 문자열을 편집할수 있는 Buffer를 가지고 있으며 그 크기를 지정할 수 있다.

### **StringBuffer 생성자**

```
public StringBuffer(int length){
value = new char[length];
shared = false;
}
public StringBuffer(){
this(16);
}
public StringBuffer(String str){
this(str.length() + 16);
append(str);
}
```

배열의 길이는 변경될 수 없으므로 새로운 길이의 배열을 생성한후 복사한다.

- 인스턴스가 달라진다

### StringBuffer 변경

> StringBuffer sb = new StringBuffer("abc")
>

![https://user-images.githubusercontent.com/85658845/205320661-66cce07d-3eaa-414b-8320-371a0286f22c.png](https://user-images.githubusercontent.com/85658845/205320661-66cce07d-3eaa-414b-8320-371a0286f22c.png)

> sb.append("123")
>

![https://user-images.githubusercontent.com/85658845/205321029-de001d30-b3c6-4e30-be4e-169112e13de8.png](https://user-images.githubusercontent.com/85658845/205321029-de001d30-b3c6-4e30-be4e-169112e13de8.png)

### **StringBuffer의 비교**

StringBuffer는 인스턴스 클래스기 때문에 String 비교로 비교할 수 없다.

toString으로 변경후 비교한다

![https://kookyungmin.github.io/image/java_image/java_image_165.png](https://kookyungmin.github.io/image/java_image/java_image_165.png)

![https://kookyungmin.github.io/image/java_image/java_image_166.png](https://kookyungmin.github.io/image/java_image/java_image_166.png)

![https://kookyungmin.github.io/image/java_image/java_image_167.png](https://kookyungmin.github.io/image/java_image/java_image_167.png)

![https://kookyungmin.github.io/image/java_image/java_image_168.png](https://kookyungmin.github.io/image/java_image/java_image_168.png)

### **StringBuilder란?**

> StringBuffer는 멀티쓰레드에 안전하도록 동기화 된다
>
>
>  StringBuilder에서 동기화만 뺀 StringBuffer
>

## **Math클래스**

수학에 관련된 메서드들을 구현해 놓은 클래스

### 울림,버림, 반올림

올림: ceil(소수) 소수점 자리를 올린다.

버림:floor() 소수점 아래 버림

반올림:round() int , rint() double

### 예외를 발생시키는 메서드

> 메서드 이름에 Exact 가 포함된 메서드들이 JDK 1.8부터 새로 추가되었다
>
>
> 오버플로우를 감지하도록 만들었다
>

```
int addExact(int a , int b) //int a + b
int subtractExact(int a , int b) //a - b
int multiplyExact (int a, int b) // a * b
int decrementExact(int a) //a++
int decrementExact(int a) //a--
int negateExact(int a) //-a
int toIntExact(long value) // (int)value - int로의 형변환
```

위 메서드들은 오버플로우 발생시 예외를 발생시킨다.

### **삼각함수와 지수, 로그**

sqrt()는 제곱근

pow(value , n)는 n제곱

![https://velog.velcdn.com/images%2Fppnrn%2Fpost%2Ff882870a-1a3f-43e1-9743-1dc659a0b44b%2Fimage.png](https://velog.velcdn.com/images%2Fppnrn%2Fpost%2Ff882870a-1a3f-43e1-9743-1dc659a0b44b%2Fimage.png)

![https://velog.velcdn.com/images%2Fppnrn%2Fpost%2F57f1689b-f7f1-4f73-bb55-716fe11aa2a1%2Fimage.png](https://velog.velcdn.com/images%2Fppnrn%2Fpost%2F57f1689b-f7f1-4f73-bb55-716fe11aa2a1%2Fimage.png)

## **1.5 래퍼(wrapper) 클래스**

기본형을 객체지향적으로 감싸 놓은 클래스

![https://velog.velcdn.com/images%2Fdoxxx93%2Fpost%2F4e189512-4f8a-4ebb-825f-66e4151bb87c%2Fimage.png](https://velog.velcdn.com/images%2Fdoxxx93%2Fpost%2F4e189512-4f8a-4ebb-825f-66e4151bb87c%2Fimage.png)

### **오토박싱 & 언박싱(autoboxing & unboxing)**

> JDK 1.5이전에는 기본형과 참조형은 연산이 불가능했다
>

컴파일러가 Integer 객체를 int 타입의 값으로 변환해주는 intValue()를 추가한다.

## **2.1 Objects 클래스**

Object클래스의 보조 클래스로 Math클래스 처럼 모두 static이다. 그래서 Null 체크가 유용하다

> static boolean inNull(Object obj)
>
>
> static boolean nonNull(Object obj)
>
> static boolean requireNonNull() // 해당 객체가 널이 아니어야 하는 경우에 사용한다. 널이면 예외 발생
>
> NullPointerException 2번째 매개변수는 예외 메시지가 된다
>

### **Random 클래스**

Math.random 안에 Random 클래스가 내부에 적용되어 있다

### **Random 클래스의 생성자와 메서드**

### 

![https://mblogthumb-phinf.pstatic.net/20140720_30/exploit_code_1405861052391vVGOk_PNG/2014-07-20_21%3B56%3B49.PNG?type=w2](https://mblogthumb-phinf.pstatic.net/20140720_30/exploit_code_1405861052391vVGOk_PNG/2014-07-20_21%3B56%3B49.PNG?type=w2)

## **정규식(Regular Expression)-java.util.regex 패키지**

정규식이란 텍스트 데이터 중에서 원하는 조건과 일치하는 문자열을 찾아 내기 위해 사용하는 것으로

미리 정의된 기호와 문자를 이용해서 작성한 문자열을 말한다.

> 1.정규식을 매개변수로 Pattern 클래스의 static 메서드인 Pattern compile(String regex)을 호출하여Pattern 인스턴스를 얻는다.Pattern p=Pattern.compile("c[a-z]*");2.정규식으로 비교할 대상을 매개변수로 Pattern 클래스의 Matcher matcher(CharSequence input)를 호출해서Matcher 인스턴스를 얻는다.Matcher m=p.matcher(data[i]);3.Matcher 인스턴스에 boolean matches()를 호출해서 정규식에 부합하는지 확인한다.if(m.matches())
>

![https://kookyungmin.github.io/image/java_image/java_image_184.png](https://kookyungmin.github.io/image/java_image/java_image_184.png)

그룹으로 나눌 수 있다 group(0)

```
package org.example.ofTestCopy;

import org.junit.jupiter.api.Test;

import java.util.StringJoiner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

public class StringTest {

  @Test
  void name() {
      String source = "HP:011-1111-1111, HOME:02-999-9999";
      String pattern = "(0\\d{1,2})-(\\d{3,4})-(\\d{4})";

      Pattern p = Pattern.compile(pattern);
      Matcher m = p.matcher(source);

      int i = 0;
      while (m.find()){
          System.out.println(++i + ": " + m.group() + " -> " + m.group(1) + "," + m.group(2) + "," +m.group(3));
      }
  }
}

// 1: 011-1111-1111 -> 011,1111,1111
// 2: 02-999-9999 -> 02,999,9999
```

```
0\\d{1,2} : 0으로 시작하는 최소 2자리 최대 3자리 숫자(0포함)

\\d{3,4} : 최소 3자리 최대 4자리의 숫자

\\d{4} : 4자리의 숫자
```

find()는 주어진 소스 내에서 패턴과 일치하는 부분을 찾아내면 true를 반환하고

찾지 못하면 false를 반환합니다.

find()를 호출해서 패턴과 일치하는 부분을 찾아낸 다음,

다시 find()를 호출하면 이전에 발견한 패턴과 일치하는 부분의 다음부터 다시 패턴매칭을 시작합니다.

## **java.util.Scanner 클래스**

Scanner는 화면, 파일, 문자열과 같은 입력소스로부터 문자데이터를 읽어오는데 도움을 줄 목적으로

JDK1.5부터 추가되었습니다.

Scanner가 없던 JDK 1.5 이전에는 자바는 화면으로부터 입력받는 것이 왜 이렇게 불편하냐는

개발자들의 문의가 많았습니다.

```
//JDK 1.5 이전
BufferedReader br=new BufferedReader(new InputStreamReader(System.in));

String input=br.readLine();
```

```
//JDK1.5 이후

Scanner s=new Scanner(System.in);
String input=s.nextLine();
```

## **java.util.StringTokenizer 클래스**

> StringTokenizer는 긴 문자열을 지정된 구분자를 기준으로 토큰이라는 여러 개의 문자열로 잘라내는 데 사용됩니다.
>

```
String[] result="100,200,300,400".split(",");

Scanner sc2=new Scanner("100,200,300,400").useDelimiter(",");
```

![https://kookyungmin.github.io/image/java_image/java_image_189.png](https://kookyungmin.github.io/image/java_image/java_image_189.png)

## **java.math.BigInteger 클래스**

정수형으로 표현할 수 있는 값의 한계가 있습니다.

가장 큰 정수형 타입인 long으로 표현할 수 있는 값은 10진수로 19자리 정도인데,

더 큰 값을 다뤄야할 때가 있습니다.

이 때 사용되는 클래스가 BigInteger 입니다.

정수의 큰 값을 다루기에 위해 BigInteger 클래스가 있듯이,

double보다 훨씬 정밀한 실수를 다루기 위해 사용하는 BigDecimal 클래스도 있습니다.

BigDecimal 클래스는 실수형과 달리 정수를 이용해서 실수를 표현합니다.