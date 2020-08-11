Inner class
==========
### 1. Inner class
---------------
- __Inner class__: 클래스 안에서 선언된 클래스
- __Inner class의 종류__: 선언된 위치에 따라서 내부 클레스를 구분한다.
    + 1. Instance class: 외부 클레스의 멤버변수 선언 위치에서 선언하며 클래스의 멤버와 성격이 같다.
    + 2. static class: 외부 클레스의 멤버변수 선언 위치에서 선언하며 static과 성격이 같다.
    + 3. local class: 메소드 안이나 초기화 블록에서 선언된 클래스
    + 4. anonymous class: 클래스의 선언과 객체의 생성을 동시에 하는 이름없는 클래스
    ```java
    class Outerclass{
	int a = 5; //인스턴스 변수
	class InnerClass{//인스턴스 클레스
		
	}
	static class staticInner{ //스테틱 클레스
		
	}
	//method
	public void print() {
		class LocalClass{//지역 클레스
			
		}
	}
    }
    ```
- __Inner class의 특징__
    + 내부 클레스에 개수 제한은 없다.   
    + 페키징을 위해서 작성된다   
    + 두 클래스간의 긴밀한 관계를 위해 작성된다.   
    + 내부클래스의 선언위치에 따라 선언위치의 변수와 동일한 유효범위와 접근성, 소멸을 가진다.   
        - a는 외부 클레스의 인스턴스 멤버이다. 하지만 static은 멤버 생성 전에 생성전에 만들어 지므로 아래의 코드는 오류이다.   
        - 즉 static은 member를 참조할 수 없는 것(변수의 경우와 같다.) 
    + private, protected 접근자는 외부 클래스에서 사용할 수 없다.
    + static class는 내부 클래스에서만 사용한다. 
   ```java
   static class staticInner{ 
		public void display() {
			System.out.println(a); // static 클래스가 외부 클래스의 인스턴스 멤버를 참조할 수 없으므로 컴파일 에러
		}
	}
   ```

### 2. Inner class의 종류
---------------
#### 2.1 Instance/static inner class
---------------
+ __Instace class__
    - Instace class의 구조
    ```java
     class Outerclass{
	int a = 5; //인스턴스 변수
	class InnerClass{
    	//인스턴스 클레스	
	    }
        }
    ```
 + __static class__
    - Instace class의 구조
    ```java
    class Outerclass{
	int a = 5; //인스턴스 변수
	static class staticClass{
    	//스테틱 클레스	
	}
    }
    ```
+ __Instance class와 static class가 다른 점__
     + instance class는 내부 클레스의 멤버로서 외부 클래스의 자원을 사용할 수 있다.
         + 또한 외부 클래스에 상속된 자원을 이용할 수 있다.
         + 이를 이용해서 자바의 다중 상속을 구현한다: 아웃 클래스에 상속 + 내부 클래스에 상속 = 내부 클래스는 총 4개 클래스 자원 이용
	```java
	class Outerclass extends Parent{
	int a = 5
	class InnerClass{
		public void display() {
			System.out.println(s);//인스턴스 클레스는 외부 클래스가 상속받은 Parent의 자원을 사용할 수 있다.
		}
	}
	class Parent{
	int s = 1000;
	}
	```
    + 하지만 static은 member와 별개로 생성되고 우선해서 생성되므로 static은 member를 참조할 수 없다.
         + 따라서 위의 코드의 경우에서 static class는 외부 클래스의 자원과 부모 클래스의 주소를 모르므로 참조 할 수 없다.
	```java
	class Outerclass extends Parent{
	int a = 5
	static c = 50;
	static class staticInner{ 
		public void display() {
			//System.out.println(s); //컴파일 오류: static은 member를 참조 할 수 없다.
			//System.out.println(a); //외부 클레스의 인스턴스변수 또한 이용할 수 없다.
			System.out.println(c) //하지만 static는 참조할 수 있다.
		}
	}
	class Parent{
	int s = 1000;
	}
	```
#### 2.2 local class
---------------
- __local class__
    + local class의 구조
    ```java
    class Outerclass extends Parent{
	int a = 5; //인스턴스 변수
	public void print() {
		class LocalClass{//지역 클레스

		}
		LocalClass lc = new LocalClass();
	}
    }
    ```
- __local class의 특징__
    + 1. 메소드는 순차적으로 실행: 지역 클래스 생성이 지역 클래스 블록보다 앞서면 컴파일 오류
    + 2. 추상 메소드 구현 가능
    + 3. 지역 클래스의 지역 변수는 오직 final만 가능하다: JDK 1.8이상은 생략 가능
    + 4. 클래스를 메소드 안에서만 사용하거나, 객체의 라이플사이클을 줄이기 위해 사용
    ```java
    class Outerclass extends Parent{
	public void print() {
		abstract class LocalClass{//추상 지역 클레스
			public void display() {
				//System.out.println(s);
			}
		}
		class SubLocalClass extends LocalClass{//지역 클레스
			public void display() {
				System.out.println(a);
			}
		}
		SubLocalClass sb = new SubLocalClass();
		sb.display();
	}
    }
    ```
#### 2.3 annonymous class
---------------