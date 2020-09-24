Generics
==========

> Generics의 개념
>
> Generics의 선언
>
> Generics의 제한
>
> 제한된 제네릭 클래스
>
> 와일드 카드
>
> Generics Method
>
> 

### 1. Generics 의 개념

---------------

- **Generics**
  
  - **다양한 타입의 객체를 다루는 메소드나 컬렉션 클래스에 컴파일시 타입체크를 해주는 기능이다.**
  - <u>Generics를 사용하는 이유는 다음과 같다.</u>
    - *타입 안정성*
    - *타입 체크와 형변환의 생략으로 코드 간략화*
  - 다만 Generic는 다음과 같은 <u>문제점</u>이 존재한다.
    - <u>제너릭스끼리는 형변환이 안된다</u> 
  
- Generics를 사용하는 이유

  - `SuperClass sc = new SupeClass()`과 같은 코드가 있다고 생각하자

    - SuperClass sc: 선언형, 컴파일 타입, Early Binding

      - 선언형은 컴파일 시 결정된다. 

    - new SuperClass(): 실제형, 런타입 타입, Late Binding

      - 실제형은 런타임시 new SubClass()로 인스턴스를 생성한다.

    - 따라서 선언형은 컴파일 시 결정되므로 실제형이 뭔지 모른다.

    - 선언형은 단지 sc란 참조변수에는 SuperClass만 들어갈 수 있다고 표시하는 것?

    - 이때 문제가 발생한다.

      - Mammal의 서브 클래스가 dog, cat, human이라면 
      - 컴파일 할 때는 Mammal[] array = new Mammal[3];에서 array[0]에 dog가 들어있는지, cat이 들어있는지 모른다.

    - Generics는 이런 문제를 방지하고자 객체의 타입을 알게해준다.

      - 즉  Mammal[] array가 컴파일 할 때 제너릭스로 객체의 타입을 알려주는 기능을 한다.
      - 따라서 제너릭스는 타입 안정성을 제공하고 타입 체크와 형변환을 생략한다.

    - 다음의 코드또한 제너릭스를 사용하는 이유가 된다.

      ```java
      public class Genrics {
      	private Object item;
      	
      	public Genrics(Object item) {
      		this.item = item;
      	}
      	public Object getItem() {
      		return this.item; -- 문제: 이 Object의 원형은 무엇일까? 
      	}
      }
      ```

### 2.  Generics의 선언

------

- **Generics의 선언**

  - <u>Generic를 사용하기 위해서는 클래스 이름 옆에 `<T>`를 붙이고 위 코드 예의 Object를 모두 T로 바꾼다.</u>

    - *`<T>`는 임의의 참조형 타입을 말한다: T에는 임의의 참조형 타입을 기입한다*

      - T는 그냥 기호이다. 상황에 맞게 올바른 기호를 사용하면 된다.

    - 예: 위의 코드를 제너릭스로 표현

      ```java
      public class testGene<X> {
      	public static void main(String[] args) {
      		Generics<Integer> ge = new Generics<Integer>(50);
      		int a = ge.getItem();
      		System.out.println(a);
      	}
      }
      class Generics<X>{ //Generics<Integer>
      	private X item; //private Integer item
      	
      	public Generics(X item) {//public Generics(Integer item)
      		this.item = item;
      	}
      	public X getItem() { //public Generics getItem()
      		return this.item;
      	}
      }
      ```

- **Generics의 용어**

  - `class BOX<T>{}`
    - `T`: 타입 변수, 타입 매개변수
      - T는 타입 문자
      - T에 들어가는 참조 변수: 매개변수화된 타입(Parameterized Type)
    - `BOX`: 원시 타입
      - 원시 타입(Raw Type): 제네릭 이전 버전의 자바와 호환을 위해 임시적으로 허용되는 코드
        - 위의 예에서 Generics g = new Generics(3);이라고 작성하면 그게 원시 타입 
          - T는 Object로 간주된다.
          - 당연히 제너릭 클래스를 원시 타입으로 생성하면 경고를 내뿜는다.
    - `BOX<T>`: Generic Class

### 3.   Generics의 제한

------

- **Generics는 형변환이 불가능하다.**

  - 아래의 코드에서 `Generics<Object> g = new Generics<String>("aa");`는 제너릭스를 형변환 하려는 시도이지만, 오류난다

    -  따라서 Generics는 형변환 불가능에 따른 다형성 불가능 문제를 해결하기 위해 와일드 카드를 사용한다.

    ```java
    public class testGene<X> {
    	public static void main(String[] args) {
    		Generics<Integer> ge = new Generics<Integer>(50);
    		int a = ge.getItem();
    		System.out.println(a);
    		
    		//Casting
    		Object o = new String("aa"); //일반적인 형변환
    		Generics<Object> g = new Generics<String>("aa"); //Genetics는 형변환이 불가능하다.
    	}
    }
    class Generics<X>{
    	private X item;
    	
    	public Generics(X item) {
    		this.item = item;
    	}
    	public X getItem() {
    		return this.item;
    	}
    }
    
    class Generics2<T> extends Generics{
    	public Generics2(Object item) {
    		super(item);
    	}	
    }
    ```

    - 단, 두 제네릭 클래스가 상속관계이고 T에 대입된 타입이 같은 경우는 가능하다

      ```java
      Mammal<Cat> m = new Dog<Cat>(); //가능
      Mammal<Dog> m = new Dog<Cat>(); //불가능
      ```

    - T에 대입된 타입의 서브 클래스들은 들어올 수 있다.

      ```java
      
      public class testGene<X> {
      	public static void main(String[] args) {
      		Animal<Mammal> a = new Animal<Mammal>();
      		a.add(new Dog());
      		a.add(new Cat());
      		a.add(new Bird()); //Bird는 Mammal로부터 상속받지 않았으므로 오류
      	}
      }
      class Animal<T>{
      	private T animal;
      	public Animal(){
      	}
      	public void add(T animal) {
      		this.animal = animal;
      		System.out.println(this.animal.toString());
      	}
      	public T get() {		
      		return this.animal;
      	}
      }
      class Mammal{
      
      	@Override
      	public String toString() {
      		return "Mammal!!!!";
      	}
      	
      }
      class Dog extends Mammal{
      	@Override
      	public String toString() {
      		return "Dog!!!!";
      	}
      }
      class Cat extends Mammal{
      	@Override
      	public String toString() {
      		return "Cat!!!!";
      	}
      }
      class Bird{
      	@Override
      	public String toString() {
      		return "Bird!!!!";
      	}
      }
      ```

      

- Generics는 배열을 만들 수 없다.

  - 타입 변수 X(T)는 타입이 아니다.
  - 즉 X(T)는 선언은 할 수 있지만, 인스턴스로 만들 수 없다.
  - 반드시 제너릭스 배열을 만들고 싶다면 Reflection API의 newInstance()와 같이 동적으로 객체를 사용하는 메소드로 배열을 생성하거나 Object로 배열을 생성해서 복사한 다음 T[]로 형변환하는 방법을 사용한다.

  ```plsql
  class Generics<X>{
  	private X item;
  	private X[] array;
  	
  	public Generics(X item) {
  		this.item = item;
  		this.array = new X[3];
  	}
  	public X getItem() {
  		return this.item;
  	}
  }
  ```

- Generics의 타입 변수 T에 들어가는 타입은 참조형 이어야 한다.

  ```java
  public class testGene<X> {
  	public static void main(String[] args) {
  		int a = 98;
  		Generics<Integer> ge = new Generics<int>(a); //<int>가 아닌 <Integer>처럼 참조형 이어야 한다.
  	}
  }
  ```

- 추정이 가능한 경우 타입을 생략할 수 있다.

  ```java
  public class testGene<X> {
  	public static void main(String[] args) {
  		int a = 98;
  		Generics<Integer> ge = new Generics<>(30); //JDK 1.7부터 가능
  	}
  }
  ```

- static멤버에 타입 변수 T를 사용할 수 없다.

  - T는 인스턴스 변수로 간주되며, static멤버는 인스턴스 변수를 참조할 수 없다.
  - 타입 매개변수가 아니라 특정 타입을 기입한다.

### 4  제한된 제네릭 클래스

------

- 제너릭은 타입 매개변수 T에 들어갈 타입의 종류를 제한할 수 있다.

  - 아래의 코드에서 Animal의 T에 아무거나 대입에도 된다.

    ```java
    	public static void main(String[] args) {
    		Animal<Gun> a = new Animal<Gun>();
    		//a.add(new Dog());
    		a.add(new Gun());
    		//a.add(new Bird()); //Bird는 Mammal로부터 상속받지 않았으므로 불가
    	}
    }
    class Animal<T>{
        .
        .
        .
        .
        .   
    }
    ```

  - `<T extends SuperClass>` T에는 SuperClass의 서브클래스만 들어올 수 있다.

    - 아래의 코드에서 Animal의 T에는 오직 Mammal과 Mammal의 서브클래스만 들어올 수 있다.

      ```java
      public class testGene<X> {
      	public static void main(String[] args) {
      		//Animal<Gun> a = new Animal<Gun>(); T에는 오직 Mammal만 들어온다.
              Animal<Mammal> a = new Animal<Mammal>(); 
      		a.add(new Dog()); 
      		a.add(new Gun());
      		//a.add(new Bird()); //Bird는 Mammal로부터 상속받지 않았으므로 불가
      	}
      }
      class Animal<T extends Mammal>{
      	private T animal;
      	public Animal(){
      	}
      	public void add(T animal) {
      		this.animal = animal;
      		System.out.println(this.animal.toString());
      	}
      	public T get() {		
      		return this.animal;
      	}
      }
      ```

### 5  와일드 카드

------

- 와일드 카드

  - `?`로 표현

  - 와일드 카드의 예

    - 아래 코드:  static 멤버는 T를 사용할 수 없으므로 제너릭스를 사용하지 않던가 T가 아니라 특정 타입을 기입해주어야 한다. 

    - ?는 이를 

      ```java
      
      public class testGene<X> {
      	public static void main(String[] args) {
      		Meterial<Friut> m = new Meterial<Friut>(new Friut());
      		String a = Animal.makeJuice(m);
      		System.out.println("aa");
      		System.out.println(a);
      	}
      }
      class Animal{
      	public static String makeJuice(Meterial<Friut> m) { //static makeJuice()의 파라미터로 제네릭 클래스를 받는다. 그런데 static이므로 제너릭스를 사용하지 않거나 Meterial<T>가 아닌 Meterial<Friut>, Meterial<APPLE>처럼 일일히 특정 타입을 주어야 한다.
      		String a = m.toString();
      		return a;
      	}
      }
      class Meterial<T>{
      	public T m;
      	
      	public Meterial(T m) {
      		super();
      		this.m = m;
      	}
      
      	@Override
      	public String toString() {
      		return m.toString();
      	}
      }
      class Friut{
      
      	public String add() {
      		String a = "I'm Friut";
      		return a;
      	}
      
      	@Override
      	public String toString() {
      		return "Friut []";
      	}
      	
      }
      
      ```

      - 따라서 위의 코드를 와일드 카드를 사용해 고치면 다형성을 이용할 수 있다.

        ```java
        
        public class testGene<X> {
        	public static void main(String[] args) {
        		Meterial<Friut> m = new Meterial<Friut>(new Friut());
        		Meterial<Apple> m1 = new Meterial<Apple>(new Apple());
        		String a = Animal.makeJuice(m);
        		String a1 = Animal.makeJuice(m1);
        		System.out.println(a);
        		System.out.println(a1);
        	}
        }
        class Animal{
        	public static String makeJuice(Meterial<?> m) {
        		String a = m.toString();
        		return a;
        	}
        }
        class Meterial<T>{
        	public T m;
        	
        	public Meterial(T m) {
        		super();
        		this.m = m;
        	}
        
        	@Override
        	public String toString() {
        		return m.toString();
        	}
        }
        class Friut{
        
        	public String add() {
        		String a = "I'm Friut";
        		return a;
        	}
        
        	@Override
        	public String toString() {
        		return "Friut []";
        	}
        	
        }
        class Apple extends Friut{
        	public String add() {
        		String a = "I'm Apple";
        		return a;
        	}
        
        	@Override
        	public String toString() {
        		return "Apple []";
        	}
        }
        ```

  - 와일드 카드의 제한

    | <? extends T> | 와일드 카드와 상한 제한, T와 T의 서브클래스들만 가능  |
    | ------------- | ----------------------------------------------------- |
    | <? super T>   | 와일드 카드와 하한 제한, T와 T의 슈퍼 클래스들만 가능 |
    | <?>           | 제한 없음, 모든 타입이 가능 == <? extends Object>     |

    

    

    

    

    ```java
    static void print(List<? extends Number> list) { //ArrayList의 부모는 List //ArrayList<String>ArrayList<Double>ArrayList<Integer>를 파라메터로 받는데 <>는 일치해야 하므로 <object>가 아닌 와일드카드 <?>사용하고 받는다.
    		for(Object a :list){ //그런데 결국 Integer이든 double이든 String이든 전부 Object의 자식이므로 Object로 받는다.
    			System.out.print(a + ", ");
    		}
    		System.out.println();
    	}
    ```

    

   