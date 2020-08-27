# literal & variable & *constant* 

------

## 1. literal

------

- ###### literal: 변수에 할당되지 않은 값이다. 변수에 할당되지 않고 리터럴은 그 자체로 값이다.

  - 따라서 리터럴은 메모리상에 저장된 값이 아닌 단지 Value이다.

    ```java
    System.out.println(-24+5);
    ```

    - 위 코드에서 -24 + 5는 변수에 저장되지 않은 리터럴이다.

  - 리터럴의 종류: 정수형, 실수형, 문자열, 문자열, boolean

## 2. Variable

------

### 	2.1 variable 개념

------

- Variable은 단 하나의 값을 저장할 수 있는 **공간**

- 변수는 <u>변수의 선언 -> 변수의 초기화</u> 과정을 거친다.

  ```java
  int a; //변수의 선언
  a = 5;//변수의 초기화
  double b = 3.14; //선언과 초기화를 동시에
  ```

  - 변수를 초기화 하는 이유는 기존 메모리에 남아있던 쓰레기값을 제거하기 위함이다.

  2.2 변수의 종류

  ------

  - 변수에는 **Primitive type**과 **Reference Type**이 있다. 기본형은 저장 가능한 범위가 있다.

    - Primitive type

      - 정수형: short, byte, **int**, long
      - 실수형: float, **double**
      - boolean형
      - 문자형: char

    - Reference type: 주소를 저장한다.

      - **String**, interface, Enum

      - String은 참조형이지만 특수한 취급으로 다음과 같이 일반적인 기본형 처럼 선언할 수 있지만

        ```java
        String s = "안녕하세요.";
        ```

      - 참조형처럼 생성자를 이용할 수 있다.

        ```java
        String s1 = new String("저도 안녕하세요");
        ```

        

  - 기본형의 저장 가능 범위: 기본형은 모두 저장 가능한 상/하한을 지닌다.

    - 이 기본형의 범위를 초과할 경우 컴파일 에러가 난다.

    ```java
    
    public class Test {
    
    	public static void main(String[] args) {
    		//Primitive type max/min
    //정수
    		//short
    		short maxShort = Short.MAX_VALUE;
    		short minShort = Short.MIN_VALUE;
    		//byte
    		byte maxByte = Byte.MAX_VALUE;
    		byte minByte = Byte.MIN_VALUE;
    		//int
    		int maxInt =Integer.MAX_VALUE;
    		int minInt =Integer.MIN_VALUE;
    		//long
    		long maxLong = Long.MAX_VALUE; 
    		long minLong = Long.MIN_VALUE; 
    //실수: 실수는 가질수 있는 범위보다 정밀도가 중요하다.
    		//float: 보통 7자리까지 정확도 보장
    		float maxFloat = Float.MAX_VALUE;
    		float minFloat = Float.MIN_VALUE;
    		//float는 f를 붙여야 한다.
    		float a = 1.1111111f;
    		float a1 = a + 1.111111f;
    		//double: 15자리까지 정확도 보장
    		double maxDouble = Double.MAX_VALUE;
    		double minDouble = Double.MIN_VALUE;
    		Double b = 1.11111111;
    		Double b1 = b + 1.11111111;
    //char: ~ ~ 65535 
    		int maxChar = (int)Character.MAX_VALUE;
    		int minChar = (int)Character.MIN_VALUE;
    //출력
    		System.out.println("short max is " + maxShort);
    		System.out.println("short min is " + minShort);
    		System.out.println();
    		System.out.println("byte max is " + maxByte);
    		System.out.println("byte max is " + minByte);
    		System.out.println();
    		System.out.println("int max is " + maxInt);
    		System.out.println("int max is " + minInt);
    		System.out.println();
    		System.out.println("long max is " + maxLong);
    		System.out.println("long max is " + minLong);
    		System.out.println();
    		System.out.println("float max is " + maxFloat);
    		System.out.println("float max is " + minFloat);
    		System.out.println();
    		System.out.println("double max is " + maxDouble);
    		System.out.println("double max is " + minDouble);
    		System.out.println();
    		System.out.println("char max is " + maxChar);
    		System.out.println("char max is " + minChar);
    
    	}
    }
    ```

    - 결과

      ```java
      short max is 32767
      short min is -32768
      
      byte max is 127
      byte min is -128
      
      int max is 2147483647
      int min is -2147483648
      
      long max is 9223372036854775807
      long min is -9223372036854775808
      
      float max is 3.4028235E38
      float min is 1.4E-45
      
      double max is 1.7976931348623157E308
      double min is 4.9E-324
      
      char max is 65535
      char min is 0
      
      ```

  - java 기본형의 바이트

    | 종류    | 바이트 |
    | ------- | ------ |
    | boolean | 1      |
    | char    | 2      |
    | byte    | 1      |
    | short   | 2      |
    | int     | 4      |
    | long    | 8      |
    | float   | 4      |
    | double  | 8      |

    - 추가
      - 자바는 기본적으로 숫자를 4바이트로 본다.
      - 즉 24는 0000......11000이다.
      - 하지만 11앞은 전부 0이므로 각 크기에 맞게 0을 자른다.
        - short의 경우 00000000000000011000
        - byte의 경우 00011000
      - 따라서 숫자를 바이트에 맞게 못자를 경우 범위가 넘어가므로 최대값 최소값이 중요하다.
  
  ### 2.2 변수의 범위
  
  ------
  - 변수는 범위를 가지며 자신의 범위를 넘어서면 변수는 소멸된다.
  
  - 변수의 범위
  
    - 지역변수
  
    - 멤버변수(= 인스턴스변수)
  
    - 클래스변수
  
      | 변수의 종류   | 선언위치                                        | 메모리 할당 시기            |
      | ------------- | ----------------------------------------------- | --------------------------- |
      | 지역변수      | 클래스 이외의 영역(메서드, 생성자, 초기화 블럭) | 클래스가 메모리에 올라갈 때 |
      | 인스턴스 변수 | 클래스 영역                                     | 인스턴스가 생성될 떼        |
      | 클래스 변수   | 클래스 영역                                     | 변수 선언문이 수행되었을 떼 |
  
      ```java
      public class afsdfweqrfcas {
      	public static void main(String[] args) {
      		//Local Variable
      		int a = 54;
      		System.out.println(a);
      		System.out.println(abc.c);
      		//class Variable Ex
      		abc aaa = new abc();
      		abc bbb = new abc();
      		aaa.c = aaa.c + 158615684; // aaa 인스턴스 변수를 수정하였다.
      		System.out.println(aaa.c);
      		System.out.println(bbb.c); //클래스 변수는 클래스의 모든 인스턴스 변수가 같은 값을 공유한다. 따라서 aaa 인스턴스의 c를 수정했지만 bbb의 인스턴스도 같이 수정된다.
      		
      	}
      }
      class abc{
      	//Memver Variable
      		int a = 10;
      		double b = 156.1;
      		//class Variable: static으로 선언
      		static int c = 185;
      }
      ------------------------------------------------------------------------------------------
      54
      185
      158615869
      158615869
      ```
  
      

## 3. Constant

------

- 상수란 변수와 마찬가지로 값을 저장하는 공간이지만 값을 저장할 시 수정할 수 없다. 
- 상수의 선언: final
  - `final double PI = 3.14;`
- 나중에 더 추가할 것

## 4. 알아두면 좋은 것 들

------

- **오버플로우 문제**: 해당 타입이 표현할 수 있는 값의 범위를 넘어선 것

  - 타입의 최대값 다음은 해당 타입의 최소값이다.

  ```java
  int a = Integer.MAX_VALUE;
  int b = a + 1;
  System.out.println("int의 최대값은 " + a);
  System.out.println(b);
  ---------------------------------------------------------------------------
  int의 최대값은 2147483647
  -2147483648
    
  ```

  

- **unsigned, signed**: https://www.google.com/search?q=unsigned+signed&oq=unsigned+s&aqs=chrome.3.69i57j0l5&sourceid=chrome&ie=UTF-8

- **byte, short, char의 연산시 주의점**

  - 모든 이항 연산자는 연산을 수행하기 전 크기가 4바이트 이하인 자료형은 int로 변환한다.

  - 따라서 byte, short, char를 연산한 후 명시적으로 형변환을 해 주어야 한다.

    ```java
    byte a = 7;
    byte b = 8;
    byte c = a - b; //컴파일 오류: a-b를 int로 변환하므로 형식이 맞지 않는다.
    ```

    ```java
    char a = 'z';
    char b = '9';
    int c = a - b; //해당하는 코드의 아스키 코드값을 int로 변환한 후 연산하므로 컴파일이 된다.
    System.out.println(c);
    -----------------------------------------------------------------------
    65
    ```

    















