DI(Dependency Injection)
==========

> DI의 개념



> DI의 종류
>
> XML을 이용한 DI
>
> Annotation Class를 이용한 DI
>
> Component-scan을 이용한 Autowired
>
> XML과 Annotation Class를 함께 사용하는 DI
>
> 외부 파일을 사용한 DI

### 1. DI의 개념

---------------

- **DI(Dependency Injection)가 무엇인가**

  - 객체 자체가 아니라 **Framework에 의해 객체의 의존성이 주입**되는 Design Pattrern이다.

  - DI를 통해서 기존의 *tight coupling를 해결하기 위한 방법*이다.

    - 예를 들어 아래 코드를 보자

      ```java
      public class SoundPlayer{
          private AnimalSound animal;
          public SoundPlayer(){
              this.animal = new Cats();
          }
          public void play() {
          	this.animal.sound();
          }
      }
      
      public class Cats implements AnimalSound {
      	@Override
      	public void sound() {
      		System.out.println("애용");
      	}
      }
      ```

      - 이 코드에서 SoundPlayer는 객체를 생성자에서 `new Cats();`를 통해 Cats클래스에 의존성을 가진다.
      - <u>따라서 `play()` 메소드에서 호출하는 Cats의 `sound()`메소드의 이름이나 코드가 바뀐다면 AnimalSound의 코드도 함께 바뀌어야한다.</u>  
        - 이게 바로 **강한 결합, Tight Coupling**이다.
      - 이 문제를 해결하기 위해서 객체 자체가 아닌 Spring Framework의 Container가 객체의 생성부터 의존성 주입까지 관리하기 위한 방법이 바로 DI다.

  - Spring에서는 IoC(Inversion of Control) Container를 통해서 객체의 생성 및 생명주기를 관리하고 종속적 주입을 실행한다.

- **IoC(Inversion of Control)**

  - 일반적으로 DI와 같은 의미로 사용된다. 정확한 의미는 **객체의 생성, 생명주기의 관리까지 모든 객체에 대한 제어권을 개발자가 아닌 Framework가 가져가는 것**이다.
    - 즉 객체의 생성, 설정은 Xml이나 Annotation class를 통해서 개발자가 수행하고
    - 해당 객체에 대한 처리는 Container가 알아서 담당한다.
  - 일반적인 Ioc의 분류는 다음과 같다.
    - DI(Dependency Injection)
      - Spring
      - Setter/Constructor/Method Injection
      - 각 Class간 의존관계를 Bean Definition 정보를 바탕으로 Container가 자동으로 연결하는 것
    - DL(Dependency Lookup)

- DI를 사용하기 위한 준비물

  - Bean Definition Information
    - xml, Annotation
    - 개발자는 해당 File에 의존 관계 정보를 추가하면 된다.

### 2.DI의 종류

- **DI는 다음과 같은 종류가 존재한다.**

  1. **Setter Injection**

     - <u>Setter Injection을 이용한 의존성 주입 방법</u>으로 의존성을 입력받는 Setter Injection을 만들고, 이를 통해 의존성을 주입한다.

     - DI를 사용하지 않는 기존의 방법에서 Setter Injection

       ```java
       public class SoundPlayer{
           private AnimalSound animal;
           public SoundPlayer(){}
           public void play() {
           	this.animal.sound();
           }
           //Non-DI: Setter를 이용한 Injection
           public void setAnimalSound(AnimalSound animal) {
           	this.animal = animal;
           }
       }
       
       public class main {
       	public static void main(String[] args) {
       		SoundPlayer s = new SoundPlayer();
       		s.setAnimalSound(new Cats()); //Non-DI: Setter를 이용한 Injection
       		s.play();
       	} 
       }
       
       ```

  2. **Constuctor Injection**

     - <u>생성자를 이용한 의존성 주입 방법</u>으로 필요한 의존성을 포함하는 Class의 생성자를 통해 의존성을 주입한다. 
     - DI를 사용하지 않는 기존의 방법에서 Setter Injection

     ```java
     public class SoundPlayer{
         private AnimalSound animal;
         public SoundPlayer(){
         	this.animal = new Cats();
         }
         public void play() {
         	this.animal.sound();
         }
     }
     
     public class main {
     	public static void main(String[] args) {
     		SoundPlayer s = new SoundPlayer();//Non-DI: Constructor를 이용한 Injection
     		s.play();
     	} 
     }
     
     ```

  3. Method Injection

     - 일반 Method를 이용한 의존성 주입으로 여기에서는 따로 다루지 않는다.

- DI의 의존 관계 정보를 저장하는 Bean Difinition File은 다음과 같은 형식을 이용할 수 있다.

  - **XML**
    - Setter 
    - Constructor
  - **Annotation Class**
    - Setter 
    - Constructor

- 또한 다음과 같은 추가적으로 DI를 다루는 방법에 대해서 다룬다.

  - XML과 Annotation을 둘 다 이용하는 DI
  - **Autowired**: 
  - **외부 파일을 이용한 DI**:Properties 파일에 작성한 값을 이용한 방법


### 3. [XML을 이용한 DI](https://github.com/sis92345/TIL/blob/master/Spring/DIXml.md)

### 4. [Annotation Class를 이용한 DI](https://github.com/sis92345/TIL/blob/master/Spring/DIAnno.md)

### 5. [Component-scan을 이용한 Autowired](https://github.com/sis92345/TIL/blob/master/Spring/DILast.md)

### 6. [XML과 Annotation Class를 함께 사용하는 DI](https://github.com/sis92345/TIL/blob/master/Spring/DILast.md)

### 7. [외부 파일을 사용한 DI](https://github.com/sis92345/TIL/blob/master/Spring/DILast.md)
