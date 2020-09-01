Signed & UnSigned & 비트연산자
==========
> Signed & UnSigned의 개념
>
> 컴퓨터의 뺄샘
>
> https://ndb796.tistory.com/4

> 비트연산자 
>
> 

### 1. Signed & UnSigned의 개념
---------------
- Signed: 부호를 가지는 값으로  MSB(Most Significant Bit)로 두어서 MSB가 0이라면 양수임을, 1이라면 음수임을 표기한다.
  
    - int형은 4Byte이므로 만약 숫자가 음수라면 MSB는 1이고 MSB와 비트 사이에는 1로 채워진다.
    
    - 양수라면 MSB는 0이고 필요한 부분을 제외한 앞 부분을 잘라진다.
    
        ```java
        public class  Test{
        	public static void main(String[] args) {
        		int su = -3;
        		int result = ~su;
        		boolean flag = true;
        		boolean answar = !flag;
        		System.out.printf("result = %d, result =%s \n", su, Integer.toBinaryString(su)); 
        		su = 3;
        		System.out.printf("result = %d, result =%s \n", result, Integer.toBinaryString(su))	
        	}
        }
        ```
    
        ```java
        result = -3, result =11111111111111111111111111111101 //결과
        result = 2, result =11 
        ```
    
-  UnSigned: 부호를 가지지 않는 값으로 오직 양수만을 가진다.

    - Unsigned는 음수표현이 없기 때문에 그만큼의 양수의 범위를 두 배로 더 늘리는 역할 한다.
    - 예를 들어 C언어의 signed char는 음수 표현을 가지기에 -128 ~ 127의 범위를 가지지만
    - C언어의 Unsigned Cher는 음수표현이 없으므로 0 ~ 255의 범위를 가진다. 

- **자바에서는 Signed가 원칙이다.** 

    - Java8에서는 자바에서 Unsigned를 다루기 위한 메서드가 Integer와 Long에 추가되었다.

        ```java
        public class  Test{
        	public static void main(String[] args) {
        	System.out.println(Integer.MAX_VALUE); //int형의 MaxValue는 2147483647
        	int a = Integer.parseUnsignedInt("3000000000");//Integer.parseUnsignedInt는 Unsigned에서 2147483647로 넘는 값을 받을 경우
        	System.out.println(a);// -1294967296처럼 Signed값으로 전환
        	}
        }
        ```

        

- 컴퓨터의 정수 표현
  
    - 컴퓨터는 N개의 비트를 이용해서 2^N개의 정수만을 표현할 수 있다. 
    - 정수는 음수와 양수로 나누어지기 때문에 +, -부호 또한 전부 비트로 표현을 해 주어야 한다. 
    - 컴퓨너는 덧셈만 가능하기 때문에 특별한 방법으로 뺄샘을 해 주어야 한다. 
    
- **보수**

    - 보수란 `두 수의 합이 진법의 밑수(N)가 되게 하는 수`를 말한다.
    - 예를 들어 10진법 4의 보수는 6
    - 컴퓨터는 보수를 통해 음의 정수를 표현한다. 
    - 컴퓨터는 가산기만 사용하기 때문에 A - B를 A + (-B)로 계산 해 주어야 하는데 여기서 2의 보수가 사용된다.
    - 2의 보수는 비트를 반대로 바꾼 후 1을 더한 값이다.
        - 예: 10진수 8을 이진법으로 1010이고 이 수의 2의 보수는 0101 + 1 = 0110이다. 
    - 컴퓨터의 뺄샘
        - 컴퓨터는 덧셈만 가능하므로  A - B를 A + (-B)로 바꾸어 계산하다.
    - 예: 100(2) - 110(2) = 100(2) + 010(2) = 110(2)
    
    
    
    

### 2 비트연산자
---------------
- 비트연산자

  - 자바에서 비트에 대한 연산을 다루는 연산자
  - 종류: ~, |, &, ^, 이동연산자

- 이동 연산자(Shift Operator): <<, >>, >>>, <<<

  - `<<`:왼쪽으로 주어진 비트 수 만큼 이동: 뒤에 비어 있는 칸은 0으로 채운다.

    ```java
    	String a = Integer.toBinaryString(15<<2); //1111에서 왼쪽으로 2비트 이동하고 빈칸은 0 으로 채운다.
        System.out.println(a);
    	------------------------결과
    	111100
    ```

  - `>>`: 오른쪽으로 주어진 비트 수 만큼 이동: 앞에 비어 있는 빈칸은 부호 비트로 채운다.

    ```java
    String a = Integer.toBinaryString(15>>2); //1111에서 오른쪽으로 2비트 이동하고 빈칸은 부호 비트로 채운다. 양수이므로 MSB는 0이므로 앞은 전부 0
    System.out.println(a);
    ------------------------결과
    11
    ```

    ```java
    String a = Integer.toBinaryString(-8>>2); //1000에서 오른쪽으로 2비트 이동하고 빈칸은 부호 비트로 채운다. MSB가 1이므로 앞은 전부 1이다.
    System.out.println(a);
    ------------------------결과
    11111111111111111111111111111110
    ```

  - `>>>`: 오른쪽으로 주어진 비트수 만큼 이동시킨다. 단 빈칸은 0으로 채운다.

    ```java
    String a = Integer.toBinaryString(-8>>>2); //1111
    System.out.println(a);
    ------------------------결과
    111111111111111111111111111110v //빈자리 만큼을 0으로 채우기에 앞의 코드와 값이 다르다.
    ```

- 비트 NOT: ~

  - 0을 1로, 1을 0으로

- |: OR 연산자

  - 병렬: 두 값중 한쪽이라도 1이면 1(true)

- &: AND 연산자

  - 직렬: 두 연산자가 전부 1이어야 1(True)

- ^: XOR연산자

  - 피연산자가 다를때만 1을 반환