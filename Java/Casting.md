Casting(형변환)
==========
> 형변환의 개념

> 예제

### 1. 값복사와  주소복사의 개념
---------------
- **형변환의 개념**

    - 형변환은 **데이터의 형을 바꾸려는 목적으로 사용하며 형변환은 다형성의 측면에서도 활용한다.** 

    - 형변환은 참조형에서 상속관계를 이용해서 다형성을 활용한다.

    

### 2 형변환의 종류
---------------
- **자동형변환**(암시적형변환/ Implicit Conversion, promotion)

  - 자동 형변환은 형변환 시 코드에 명시적으로 캐스팅 연산자를 사용하지 않는 것으로, 컴파일러가 알아서 형변환을 담당한다.
  - **작은 범위를 가진 데이터 타입 -> 큰 범위를 가진 데이터 타입으로 자료형을 변환 할 경우**에 해당한다.

- **강제형변환**(명시적형변환/ Explicit Conversion, demotion)

  - 형변환을 위해서 코드에 명시적으로 캐스팅 연산자를 사용해야 하는 경우이다. 
  - **큰 범위를 가진 데이터 타입 -> 작은 범위를 가진 데이터 타입**으로 자료형을 변환 할 경우에 해당한다.
  - 데이터의 손실이 일어날 수 있다

- 예제

  ```java
  public class Casting {
  	public static void main(String[] args) {
  	//자동형변환
  	int a = 100;
  	double b = a;
  	//int 4byte, double 8byte --> 자동 형변환
  	System.out.println(b); // 100 -> 100.0
  	//String의 자동형변환
  	String s = "가";
  	System.out.println(s + 2 + 3); //2와 3이 String으로 형변환한다. 즉 s + "2" + "3"인 것 
  	//증명
  	String s1 = s + 2 + 3;
  	String stringCast = s1.substring(1); //23은 int가 아닌 String형이다.
  	System.out.println(stringCast);
  	//강제형변환
  	double a1 = 89.52;
  	//강제형변환은 형변환하고자 하는 데이터 형식을 명시적으로 작성해야 한다.
  	int b1 = (int)a1;
  	System.out.println(b1); // 89.25 --> 89, 즉 강제형변환은 데이터 손실이 일어날 수 있다.
  	}
  }
  ```

  - 결과

    ```java
    100.0
    가23
    23
    89
    ```

### 3 참조형의 형변환

------

- **참조형의 형변환**: 참조형의 형변환으로 다형성을 활용할 수 있다.

- **참조형의 형변환의 원칙**

  - 객체사이에는 형변환이 안된다.

  - 부모-자식끼리는 형변환이 된다.

    ```java
    public class ReferenceCasting {
    	public static void main(String[] args) {
    	//참조형의 자동형변환
    	//모든 클래스의 부모 클래스는 Object class 이므로....
    	Object obj = new String("저는 String class입니다.");
    	System.out.println(obj.toString());
    	
    	//참조형 형변환의 원칙
    	// 상속관계가 아닌 객체 사이에는 형변환이 불가능하다.
    	Car car = new Drivaer("AN"); // --> Driver와 Car은 상속 관계가 아니므로 형변환이 불가능하다.
    	}
    }
    ```

- **종류**

  - **UpCasting: 자동형변환(암시적형변환/ Implicit Conversion, promotion)**

    - <u>서브 클래스가 슈퍼 클래스로 형변환하는 것</u>으로 자동형변환이 가능하다.

    - 다형성의 구현

    - <u>생성된 객체는 자식 클래스이지만 참조 변수의 타입은 부모형이므로 접근 할 수 있는 변수와 메소드는 부모 클래스로 제한</u>

      - 따라서 오버라이딩된 메소드는 자식의 메소드를 참조하지만, 그렇지 않은 일반 메소드는 부모의 메소드로 접근을 제한한다.

      ```java
      
      public class ReferenceCasting {
      	public static void main(String[] args) {
      	// 참조형 자동형변환
      	// Rolls_Royce는 car의 자식 클래스이므로 부모 클래스인 car로 자동 형변화이 가능하다.
      	Car car = new Rolls_Royce(); //--> Driver와 Car은 상속 관계가 아니므로 형변환이 불가능하다.
      	
      	// 자동 형변환 시 원칙
      	// 생성된 인스턴스는 Rolls_Royce이지만 선언은 Car이므로 
      	// 참조 변수 car가 접근할 수 있는 변수와 메소드는 부모 클래스인 Car의 변수와 메소드로 제한하며
      	// 자식 클래스가 재정의한 메소드는 자식 클래스의 메소드를 사용한다. 
      	
      	//1. 참조형의 형변환의 경우 부모 클래스의 변수와 메소드로 제한한다. --> 자식 클래스의 일반 메소드를 사용할 수 없다.
      	car.getUmbrella(String s);//컴파일 오류 --> 자식 클래스의 일반 메소드를 사용할 수 없다.
      	//2. 자식 클래스에서 오버라디잉된 메소드를 참고한다. 
      	car.getName(); //자식 클래스에서 재정의된 getName()를 사용한다.
      	}
      }
      class Car{
      	public void Start() {
      		System.out.println("자동차에 시동이 걸렸습니다.");
      	}
      	public void Stop() {
      		System.out.println("자동차에 시동이 꺼졌습니다.");
      	}
      	public void getName(){
      		System.err.println("이것은 자동차 입니다.");
      	}
      }
      class Rolls_Royce extends Car{
      	public String getUmbrella(String s) {
      		String a = "우산";
      		if(s.equals("우산획득")) return a;
      		else return "우산이 없습니다.";
      	}
      	@Override
      	public void getName(){
      		System.err.println("이 자동차는 롤스로이스 입니다.");
      	}
      }
      class Driver {
      	private String name;
      	Driver(String name){
      		this.name = name;
      	}
      	public void getName(){
      		System.err.println("저는 " + this.name + " 입니다." );
      	}
      }
      ```

      

  - **DownCasting: 강제형변환(명시적형변환/ Explicit Conversion, demotion)**

    - <u>슈퍼 클래스가 서브클래스로 형변환 하는 것</u>으로 강제형변환 해야 한다.

    - 강제형변환은 형변환전 instanceof로 형변환이 가능한지 판단하고 형변환을 해야한다.

    - **부모 -> 자식 클래스로 형변환을 하기 위해서는 먼저 UpCasting이 선행되고 난 후 UpCasting된 클래스는 DownCasting이 가능하다.**

    - DownCasting 예

      ```java
      public class ReferenceCasting {
      	public static void main(String[] args) {
      	//선언
      	Car car = new Car(); //Car 인스턴스
      	Rolls_Royce rr = new Rolls_Royce();	 //Rolls_Royce rr인스턴스
      	Car carDriver = new Driver("AN");   //Driver로 자동형변환한 Car
      	
      	//1. Rolls_Royce의 참조변수 rr은 Car로 형변환이 가능한지 판단: Rolls_Royce는 Car의 자식 클래스이므로 자동형변환이 가능
      	if(rr instanceof Car) {
      		System.out.println("형변환이 가능합니다.");
      	}
      	else System.out.println("형변환이 불가능 합니다.");
      	
      	//2. Car 인스턴스 car이 자식 클래스인 Rolls_Royce로 강제 형변환이 가능한지 여부를 판단: 원칙상 부모 클래스는 자식 클래스로 형변환이 불가능하다.
      	if(car instanceof Rolls_Royce) {
      		System.out.println("형변환이 가능합니다.");
      	}
      	
      	else System.out.println("형변환이 불가능 합니다.");
       
      	Car carR = new Rolls_Royce(); //자동형변환
      	//3. Car 인스턴스 carR이 자식 클래스인 Rolls_Royce로 강제 형변환이 가능한지 여부를 판단
      	//원칙상 부모 -> 자식 형변환이 불가능 하지만
      	//부모 -> 자식 형변환이전에 자식 -> 부모로 자동 형변환한 이력이 있을 경우에는 형변환이 가능하다.
      	//즉 바로 부모 -> 자식 형변환 X, 자식 -> 부모 -> 자식으로 강제 형변환이 가능하다.
      	if(carR instanceof Rolls_Royce) {
      		Rolls_Royce roll = (Rolls_Royce)carR;//자동형변환한  Car타입 carR를 다시 자식 클래스로 강제형변환 하는 것은 가능하다. 
      		roll.getName();
      	}
      	else System.out.println("형변환이 불가능 합니다.");
      	}
      }
      class Car{
      	public void Start() {
      		System.out.println("자동차에 시동이 걸렸습니다.");
      	}
      	public void Stop() {
      		System.out.println("자동차에 시동이 꺼졌습니다.");
      	}
      	public void getName(){
      		System.err.println("이것은 Car 클래스의 getName() 입니다.");
      	}
      }
      class Rolls_Royce extends Car{
      	public String getUmbrella(String s) {
      		String a = "우산";
      		if(s.equals("우산획득")) return a;
      		else return "우산이 없습니다.";
      	}
      	@Override
      	public void getName(){
      		System.err.println("이 자동차는 롤스로이스 입니다.");
      	}
      }
      class Driver extends Car{
      	private String name;
      	Driver(String name){
      		this.name = name;
      	}
      	public void getName(){
      		System.err.println("저는 " + this.name + " 입니다." );
      	}
      }
      ```

      - 결과

        ```java
        형변환이 가능합니다.
        형변환이 불가능 합니다.
        형변환이 가능합니다.
        이 자동차는 롤스로이스 입니다.
        ```

        

      

      

    - **Instanceof**

      - 사용

        - 부모형을 자식형으로 강제형변환이 가능하다는 것을 true/false로 반환한다. 

          ```java
          
          public class InstanceOfDemo {
          	public static void main(String[] args) {
          	//1. 부모형을 자식형으로 강제형변환이 가능하다는 것을 true/false로 반환한다. 
          	A a = new B();
          	A a1 = new A();
          	//UpCasting을 선행된 a참조변수는 B로 DownCasting이 가능하다.
          	if(a instanceof B) {
          		System.out.println("형변환이 가능합니다.");
          		B b = (B)a;
          	}
          	else System.out.println("형변환이 불가능합니다.");
          	//UpCasting을 선행하지 않은 a1 참조변수는 B로 DownCasting이 불가능하다.
          	if(a1 instanceof B) {
          		System.out.println("형변환이 가능합니다.");
          		B b = (B)a1;
          	}
          	else System.out.println("형변환이 불가능합니다.");
          	}
          }
          class A{}
          class B extends A{}
          ```

        - 객체의 원형을 뽑아내기 위해서 사용한다.(부모형의 참조변수로 자식 클래스의 원형을 알고자 할 때 사용한다.)

          ```java
          
          public class InstanceOfDemo {
          	public static void main(String[] args) {
          	//2. 객체의 원형을 뽑아내기 위해서 사용한다.(부모형의 참조변수로 자식 클래스의 원형을 알고자 할 때 사용한다.)
          	int ran = (int) ((Math.random()*4) + 1);
          	Language lan = null;
          	switch(ran) { //사용자는 lan 참조변수에 어떤 인스턴스가 참조되는지 모른다. 
          		case 1: lan = new Korean(); break;
          		case 2: lan = new English(); break;
          		case 3: lan = new Deutsch(); break;
          		case 4: lan = new Franch(); break;
          	}
          	//instanceof를 사용해서 객체의 원형을 뽑아내자
          	if(lan instanceof Korean) System.out.println("len은 Korean");
          	else if(lan instanceof English) System.out.println("len은 English");
          	else if(lan instanceof Deutsch) System.out.println("len은 Deutsch");
          	else if(lan instanceof Franch) System.out.println("len은 Franch");
          	else System.out.println("?");
          	}
          }
          class Language{}
          class Korean extends Language{}
          class English extends Language{}
          class Deutsch extends Language{}
          class Franch extends Language{}
          ```

          - 결과

            ```java
            len은 Franch 
            ```

            

      

    - 결과

      

      

    

    