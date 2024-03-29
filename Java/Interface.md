Interface
==========
1. Interface

---------------
-  __Interface__: 추상 클래스의 일종으로 오직 상수와 추상 메소드만 가질 수 있다.
    + 인터페이스의 모든 상수는 `public static final`을 접근자로 가진다.(생략 가능)
    + 인터페이스의 모든 메소드는 `public abstract`이다.(생략 가능)
        + 따라서 자식 클래스는 반드시 인터페이스의 메소드를 재정의해야 한다.
    
- __Interface의 선언__
    ```java
    public interface interfaceName{
    }
    public class Main implements interfaceName{
        public static void main(String[] args) {
        }
    }
    ```
    
- __Interface와 추상 메소드의 선택__: 인터페이스는 멤버 메소드를 가질 수 없으므로 멤버 메소드가 있어야 할 경우는 인터페이스가 아닌 추상메소드를 사용한다?
### 2. Interface의  용법

------

- ###### Interface의 모든 멤버는 `public static final`이며, 모든 메소드는 `public abstract`이다.

  - *public static final, public abstract는 생략 가능하다.*

  - 서브클래스는 상속받은 메소드를 오버라이딩 할 때 접근 지정자가 기존보다 크거나 같아야하므로 <u>인터페이스로 상속받아 재정의한 메소드는 모두 public이다.</u>

  - 인터페이스의 멤버는 상수이므로 인터페이스이름.상수이름으로 접근한다. (예: test1.TEN)

    ```java
    public class Test implements test1 {
    	public static void main(String[] args) {
            
    		int a = test1.TEN+1;
    		test1.TEN-=1;; //컴파일 오류: TEN은 아무 형식도 안붙혔지만 인터페이스의 멤버는 모두 public static final, 즉 상수이다.
    	}
    	
    }
    interface test1{
       //Member
    	//1. Interface의 모든 변수는 public static final, 즉 상수이며
    	public static final double PI = 3.14;
    	int TEN = 10; //public static final이 없다면 생략 한 것
    	//2. Interface의 모든 메소드는 public abstract이며 생략 가능: 따라서 인터페이스를 상속받는 경우 오버라이딩할 메소드는 모두 public이어야 한다.
       //Method
    	public abstract void print();
    	int plus() { // 컴파일 오류: 인터페이스의 모든 메소드는 추상메소드이다. 따라서 바디를 생략한다. 
    		return 2;
    	}
    }
    ```

  - **인터페이스도 상속이 가능하다.**

    - `extends`를 사용하며 다중상속이 가능하다.

      - 단 `implements`는 불가능

      ```java
      
      public class Test implements test1 {
      	public static void main(String[] args) {
      		int a = test1.TEN;
      		System.out.println(a);
      	}
      	//compareTo(Integer o)를 구현해야 한다.
      }
      interface test1 extends Comparable<Integer>, test2 {
      	int TEN = THOUSAND;
      
      
      }
      interface test2{
      	int THOUSAND = 1000;
      }
      ```

    - **상속받은 interface형 주소는 상속한 interface의 메소드 만 접근 가능**

    - interface는 추상클래스의 일종이기 때문에 역시 `new`로 인스턴스화할 수 없다:  다형성으로 표현해야 한다.

      - 인터페이스형 주소는 본인의 추상메소드를 제정의한 메소드만 접근 가능

      - 상속받은 interface형 주소는 상속한 interface의 메소드 만 접근 가능

        ```java
        public class Test {
        
        	public static void main(String[] args) {
        		People a = new Chulsu();
        		a.money(); //컴파일 오류: money는 오버라이딩된 메소드가 아니므로 People형 참조 변수 a는 접근할 수 없다.
        	}
        
        }
        class Chulsu implements People{
        
        	@Override
        	public void moneyPlus() {
        		int money = 1000;
        		money += People.THOUSAND;
        		
        	}
        	public int money() {
        		int money = 1202315;
        		return money;
        		
        	}
        	
        }
        interface People{
        	int THOUSAND = 1000;
        	public void moneyPlus();
        	
        }
        ```

      - FlagInterface(Maker Interface)

        - 메소드를 하나도 정의하지 않는 인터페이스
        - 예 `public interface Serializable { }` 
        - 마커 인터페이스는 타입 체크의 역할을 한다.
          - 예를 들어 Serializable interface를 상속받은 클래스만이 직렬화를 할 수 있다.

### 3. implement의 활용

---------------
#### 3.1 Comparable<t>
---------------
-  __Comparable<t>__: 객체를 정렬하는데 사용되는 compareTo()를 정의한다.
    
    + Comparable이 있는 클래스는 객체간 정렬이 가능하다.
-  __Comparable<t>이 필요한 이유__: Primitive Data는 명확한 대소 비교가 가능하기에 자바에서 Primitive Type은 쉽게 정렬이 가능하다.(Natural order). 이러한 경우 일반적으로 `.sort()`를 활용하거나 정렬 알고리즘을 활용할 수 있다.
    + 하지만 특정 타입의 객체는 명확한 대소 관계가 없어서 정렬할 수 없으며 따라서 Comparable을 상속받아서 compareTo를 재정의 함으로써 객체의 정렬을 할 수 있다.
    + 즉 다음과 같은 코드는 컴파일 에러를 일으킨다. 
     ```java
	player[] array = {new player("한지민"),new player("김지민"),new player("박지민")};
        for(int i=0;i<array.length-1;i++) {
			for(int j=0;j<array.length-1;j++) {
				if(array[j] > array[j+1]) {
					Student temp = array[j]; //String형간은 비교 연산자 사용이 불가능하다,String의 순서를 알기위해 compareTo를 사용하지만 player는 compreTo가 없다.
					array[j] = array[j+1];
					array[j+1] = temp;
				}
			}
		} //Description Resource Path Location Type The operator > is undefined for the argument type(s) Student, Student	InterfaceDemo4.java	/Test/src	line 17	Java Problem
    ```
    + 따라서 객체를 정렬할 필요가 있는 경우 Comparable을 implements해서 compareTo()를 재정의해서 사용해야 한다.
        + 만약 Comparable을 implements하지 않을 경우 해당 객체에는 comparrTo()가 없으므로 객체의 기본형 말고는 정렬할 방법이 없다: 확인
- compareTo()를 활용한 객체 정렬
    +  int compareTo​(T o): 해당 객체와 전달된 객체의 순서를 비교
    + compareTo 재정의: 
        + 만약 두 값을 비교해서 인자로 넘어온 객체가 더 작을 경우 음수를/ 동일하다면 0을/ 크다면 양수를 리턴한다.
        + 아래는 player의 name을 비교해서 이름을 정렬해주는 오버라이딩 메소드이다.

       ```
        public int compareTo(player o) {
		return this.name.compareTo(o.name);
        }
       ```
       
        + 이 경우 메소드의 메커니즘은 다음과 같다.
            + if 반환값이 0이라면 this.name과 name의 인자는 같다.
	        + if 반환값이 음수라면 compareTo를 호출하는 객체가 더 앞선다: 오름차순 
	        + if 반환값이 양수라면 cimpareTo 인자가 더 순서상 앞선다: 내림차순
     + 따라서 player객체에는 없었던 compareTo()를 재정의 해서 객체간의 정렬을 할 수 있다.
```java
	for(int i=0;i<array.length;i++) {
			for(int j=0;i<array.length;j++) {
				if(array[j].compareTo(array[j+1]) > 0) {
					player temp = array[j];
					array[j] = array[j+1];
					array[j+1] = temp;
				}
			}
		}
```