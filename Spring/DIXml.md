DI(Dependency Injection): XML
==========

> XML을 이용한 의존성 주입



> 주요 XML 태그 정리
>
> Setter를 이용하는 방법
>
> Constructor를 이용하는 방법
>
> Namespace를 사용하여 의존성을 주입하는 방법
>
> Setter와 Constructor를 둘 다 이용하는 방법
>
> 여러개의 XML파일을 사용할 경우의 설정

### 1. XML을 이용한 의존성 주입

---------------

- **XML을 이용한 의존성 주입**

  - 말 그대로 <u>Xml File을 이용해서 의존성을 주입</u>하는 방법이다.
- 객체 생성 태그인 `<bean>`를 이용해서 객체를 생성하고 의존성을 주입한다.
  - 어떤 유형을 통해 의존성을 주입하느냐에 따라서 `<bean>`태그 안에서 사용하는 자식 태그가 달라진다.

- `<bean>` 

  - <u>객체 생성 태그</u>
  - **속성**
    - **id**
    - **class**
    - parent
    - 아래 DI를 `<bean>`태그의 속성으로 사용하도록 설정했다면 다음과 같은 속성을 사용할 수 있다.
      - `c:`: Constructor DI
      - `p:`Setter DI
      - 이에 대해서는 아래를 참고
  - 자식 태그
    - `<prorperty name="" value="">`:Setter DI
    - `<construcotr-args value="">`: Constructor DI

- **Xml을 이용한 의존성 주입의 유형**

  1. **Setter를 이용하는 방법**: Setter Method를 이용해서 의존성을 주입.	
     - tag: `<prorperty name="" value="">`
     - 장점
       1. Setter 이름을 통해 어떤 객체가 주입되는지 알 수 있다.
     - 단점
       1. Setter를 사용해서 필요한 의존 객체를 전달하지 않아도 Bean 객체가 생성되기 때문에 객체를 사용하는 시점에서  NullPointerException이 발행할 가능성이 있다.
  2. **Constructor를 이용하는 방법**: 생성자를 이용해서 의존성을 주입한다.
     - tag: `<construcotr-args value="">`
       - 속성
         - `value`: 값
         - `ref`: 객체
         - `type`:
         - `index`:
     - 장점
       1. Bean 객체를 생성하는 시점에 모든 의존 객체 주입
     - 단점
       1. 파라미터의 개수가 많을 경우 각 인자가 어떤 의존 객체를 설정하는지 알기 위해 생성자의 Code를 일일히 확인해야한다.

- Xml을 통해 의존성을 주입하는 방법

  - 자식태그를 이용하거나 태그의 속성을 이용하는 방법이 있다.

  - 태그의 속성을 사용

    ```java
    <bean id="hello" class="com.example.Hello">
    		<property name="name" value="Spring" />
    		<property name="fir" value="30" />
    		<property name="sec" value="40" />
    		<property name="aBCDE" ref="sPrinter" />
    </bean>
    ```

  - 자식 태그를 이용하는 방법

    - `<property>` 태그의 하위 태그를 이용한다

      - `<value>`: 단순 값 주입
      - `<ref bean=""/>`: bean 주입

    - 예

      ```java
      <bean id="hello" class="com.example.Hello">
      		<property name="name">
      			<value>Spring</value>
      		</property>
      		<property name="fir">
      			<value>30</value>
      		</property>
      		<property name="sec">
      			<value>40</value>	   <!-- 값 주입 -->
      		</property>
      		<property name="aBCDE">
      			<ref bean="sPrinter"/> <!-- bean 주입 -->
      		</property>
      		<property name="list">
      			<list>
      				<value>강남역</value>
      				<value>역삼역</value>
      				<value>송내역</value>
      			</list>
      		</property>
      </bean>
      ```

      

- **Xml을 이용할 시 주의점**

  1. **기본적으로 자동 형변환을 지원한다.**

     - 앞의 코드를 보면 String으로 DI한 것 처럼 보이지만

       ```xml
       	<bean id="hello" class="com.example.Hello">
       		<property name="fir" value="30" />
       		<property name="sec" value="40" />
       	</bean>
       ```

     - 위 두 변수를 계산하는 메소드를 호출하여 계산해보면

       ```java
       public void calc() {
       		System.out.println(this.fir + this.sec);
       }
       
       @Test
       	public void test1() {
       		Hello h = (Hello)this.ctx.getBean("hello");
       		h.calc();
       }
       
       //결과
       //70
       
       ```

       - 정상적으로 자동형변환 됐음을 알 수 있다.

  2. **주입받는 것이 bean이라면 ref를 이용하고 단순 값이라면 value 속성을 이용한다.**

     - 이는 Setter이든 Constructor이든 마찬가지

  3. **Setter를 이용한다면 Setter 메소드가, Constructor가 있다면 해당하는 Constructor가 있어야한다.**

     

### 2.주요 XML 태그 정리

### 3. Setter를 이용하는 방법

- **Setter를 이용하는 방법**: Setter Method를 이용해서 의존성을 주입.	
  -  Setter를 이용하기 때문에 기본적으로 Setter Method가 있어야 한다.

- tag: `<prorperty name="" value="">`

  ```java
  <bean id="hello" class="com.example.Hello">
  		<property name="aBCDE" ref="sPrinter" /> <!--setABCED()를 aBCDE로 호출-->
  </bean>
  ```

  

- 속성

  - **`name`: 호출하고자하는 Setter 메소드 이름**

    - **Setter Method에서 set을 빼고 소문자 시작**

    - 예: printer Setter method

      - Hello.java

        ```java
        public void setABCDE(Printer printer) {
        		this.printer = printer;
        }
        ```

      - XML

        ```xml
        <bean id="hello" class="com.example.Hello">
        		<property name="aBCDE" ref="sPrinter" /> <!--setABCED()를 aBCDE로 호출-->
        </bean>
        ```

  - **`value`: 주입할 단순 값이나 단순 객체 **

  - **`ref`: 주입할 bean**

- **Collection의 Setter Injection**

  - Spring에서는 List, Set, Map, Properties와 같은 Collection을 XML로 작성해서 넣을 수 있다.

  - 주요 태그는 다음과 같다.

    - List: `<list>` `<value>`
    - set: `<set>` `<value>`
    - map: `<map>` `<entry>` + `<key>` `<value>`
    - properties: `<props>` `<prop>`

  - 예

    ```java
    	<bean id="hello" class="com.example.Hello">
    		<property name="list">	//Setter
    			<list>
    				<value>강남역</value>
    				<value>역삼역</value>
    				<value>송내역</value>
    			</list>
    		</property>
    	</bean>
    ```

    

### 4. Constructor를 이용하는 방법

- **Constructor를 이용하는 방법**: 생성자를 이용해서 의존성을 주입한다.

- tag: `<construcotr-args value="">`

  ```
  <bean id="hello" class="com.example.Hello">
  		<constructor-arg name="name" index="0" value="https://www.naver.com"></constructor-arg>
  		<constructor-arg name="name1"  index="1" value="https://www.google.com"></constructor-arg>
  </bean>
  ```

  - 위 코드는 다음과 같은 생성자에 의존성을 주입한다.
    - `public Hello(String name1, String name2){this.Name = name; this.Name1 = name1}`

- **속성**

  - **`name`: 해당 value가 적용되는 생성자의 파라미터의 이름**
    - Setter와 다르게 그냥 이름 쓰면 된다.
    - 단 name을 사용할 경우 해당 class를 컴파일 할 때 Debug flag을 활성화해야한다. 
      - 활성화시 .class 파일에 생성자 파라미터 이름이 유지된다.
      - 만약 Debug flag를 활성화하고 class를 컴파일 하고 싶지 않을 경우 다음의 Annotation을 사용한다
        - `@ConstructorProperties`
  - **`value`: 값**
  - **`ref`: 객체**
  - `type`: 생성자 파라미터의 형식을 명시적으로 지정하기위한 태그
    -  생성자의 어떤 데이터 타입인 인수에 값을 넘길 것인지 지정한다
    - value 속성으로 값
  - `index`: 생성자의 몇 번째 인수에 값을 넘길 것인가를 지정한다

- **모호한 생성자 파라미터의 처리**

  - 만약 생성자의 파라미터들의 값이 동일한 타입이라면 어떤 파라미터에 어떤 값을 넣을지 Spring Container는 알 수 없다.

  - 이 경우 다음과 같은 오류가 발생한다.

    - `org.springframework.beans.factory.UnsatisfiedDependencyException`

  - <u>이때 사용하는 속성이 `index`와 `type`이다.</u>

  - 예를 들어 다음과 같은 bean 설정이 있다고 하자

    ```java
    <bean id="hello" class="com.example.Hello">
    		<constructor-arg name="name" value="https://www.naver.com"></constructor-arg>
    		<constructor-arg name="name1"  value="https://www.google.com"></constructor-arg>
    </bean>
    ```

    - 여기서 해당 value가 생성자의 어느 인자에 들어가느냐에 대한 모호함이 존재한다.

    - 따라서 이때는 명시적으로 해당 파라미터의 타입이나 index는 명시함으로써 해결한다.

      - `index`

        - 만약 생성자 파라미터의 타입이 모두 같을 경우 사용

          ```java
          <bean id="hello" class="com.example.Hello">
          		<constructor-arg name="name" index="0" value="https://www.naver.com"></constructor-arg>
          		<constructor-arg name="name1"  index="1" value="https://www.google.com"></constructor-arg>
          </bean>
          ```

      - `type`: 만약 바로 윗윗 코드에서 타입이 다를 경우 이 방법도 사용할 수 있다.

        ```java
        <bean id="hello" class="com.example.Hello">
        		<constructor-arg name="name" type="String" value="https://www.naver.com"></constructor-arg>
        		<constructor-arg name="name1"  type="java.net.URL" value="https://www.google.com"></constructor-arg>
        </bean>
        ```

        

### 5. Namespace를 사용하여 의존성을 주입하는 방법

- Spring에서는 각각 bean 속성과 생성자 인자의 값을 지정할 수 있는 `c`와 `p` Namespace를 제공한다.

  - **`p`: `<property>`, 즉 Setter Injection**
  - **`c`:`<constructor-arg>`, 즉 Constructor Injection**

- **Namespace란**

  - XML 문서 내 유일한 엘리먼트 이름이나 속성 이름을 제공하기 위해 사용된다.

  - XML은 사용자가 자유롭게 엘리먼트를 정의할 수 있는 장점을 가지고 있지만 사용되는 엘리먼트가 XML 문서에서 중복될 수도 있다.

  - 이름이 같은 엘리먼트에 의해 발생할 수 있는 이름 충돌을 해결하기 위해 사용되는 것이 namespace이다.

  - **네임스페이스를 사용하기 위해 "xmlns"라는 속성을 사용한다.**

  - "xmlns" 속성값은 네임스페이스를 식별하기 위한 네임스페이스 이름이며, XML문서 내에서는 유일해야 한다.

  - 문법

    ```xml
    <엘리먼트이름 xmlns=”URI_Reference”>
    ```

- **Namespace를 사용하기 위한 간단히 방법**

  - STS4 기준

    1. 사용하는 xml을 선택

    2. xml 하단의 Namespaces 클릭

    3. `p`와`c`를 선택

    4. 그러면 해당 코드가 입력되며 c, p namespace를 사용할 수 있다.

       ```xml
       <beans xmlns="http://www.springframework.org/schema/beans"
       	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       	xmlns:c="http://www.springframework.org/schema/c"		//c Namespace 추가
       	xmlns:p="http://www.springframework.org/schema/p"		//p Namespace 추가
       	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
       ```

       

### 6. Setter와 Constructor를 둘 다 이용하는 방법

### 7. 여러개의 XML파일을 사용할 경우의 설정
