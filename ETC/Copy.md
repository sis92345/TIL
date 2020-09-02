Copy
==========
> 값복사와 주소복사의 개념

> 예제

### 1. 값복사와  주소복사의 개념
---------------
- **값복사**
  
    - 프로그램이 동작하는 동안 하나의 변수가 선언되면 컴퓨터는 해당 데이터 타입에 맞는 공간을 메모리에 할당한다. 변수에 값을 대입하는 것은 이 공간에 데이터를 기록한다는 의미이다.
    - 즉 값복사는 메모리간의 값을 서로 복제한다는 의미이다.
    - 따라서 값복사는 원본과 카피본이 구별되며 원본이 바뀐다고 해서 카피본이 바뀌지 않는다.
    - **Premitive type이고 카피본의 값이 안바뀌면 값 복사**이다.
    
- **주소복사**

    - 공간에 값이 아닌 주소를 복제하는 것이다. 따라서 데이터가 복제된 카피본은 데이터가 아닌 주소가 들어가는데 이때 원본과 카피본은 같은 메모리 위치를 가르키게 된다.
    - 즉 주소 복사는 주소 자체를 다른 변수에 저장된 주소에 덮어 쓰는 것이다.
    - 따라서 본래 들어가 있던 주소는 연결이 끊긴 *Garbage*가 된다.
    - 또한 같은 메모리 위치를 공유하므로 원본이 바뀌면 카피본도 영향을 받는다.
    - 그래서 **참조형이고 원본이 바뀌면 카피본도 바뀌면 주소 복사**이다.
    - <u>단 참조형 String은 주 참조형이지만 주소 복사가 불가능하다.</u>
        - String s = "가나다" --> 참조변수 s는 주소를 참조하지만 참조해서 나오는 "가나다"는 상수이다.
        - 즉 스트링은 상수로 위의 s = "abc"로 재정의 하는 것은 값이 바뀌는게 아니라 "가나다"의 연결을 끊고 "abc" 주소 번지로 바꾸는 것이다.

    ```java
    
    	public static void main(String[] args) {
            //값복사
    		System.out.println("값복사");
    		Student Kim = new Student();
    		Student Park = new Student();
    		Kim.original = 156813;
    		Park.original = Kim.original;
    		System.out.println("Kim was "+ Kim.original);
    		System.out.println("Park was " + Park.original);
    		Kim.original = 0;
    		System.out.println("Kim is " + Kim.original);
    		System.out.println("Park is "+ Park.original);
    		//주소복사
    		Park = Kim;
    		Kim.original = 100;
    		System.out.println("주소복사");
    		System.out.println("Kim is " + Kim.original);
    		System.out.println("Park Will be "+ Park.original);
    		//String
    		String a = "asdfas";
    		String b = "ㅁㄴㅇㄹㅈ";
    		System.out.println(a);
    		System.out.println(b);
    		a = "스트링은 참조형이에요. 이제 a를 재정의 할거에요";
    		System.out.println(a);
    		System.out.println(b);
    		
    	}
    }
    class Student{
    	int original, copy;
    	static int originalStatic;
    
    }
    -------------------------------------------------------------------------결과
    값복사
    Kim was 156813
    Park was 156813
    Kim is 0
    Park is 156813
    주소복사
    Kim is 100
    Park Will be 100
    asdfas
    ㅁㄴㅇㄹㅈ
    스트링은 참조형이에요. 이제 a를 재정의 할거에요
    ㅁㄴㅇㄹㅈ
    
    ```

    

### 2. 배열의 값복사, 주소복사

------

- **배열의 값복사**: `System.arraycopy(Object sec, int secPos, Object dest, int destPos, int length)`를 이용

  -  System.arraycopy() 설명

    ```
    Object sec: 복사하고자 하는 원본 배열
    int secPos: 원본 배열에서 복사를 시작하고자 하는 위치
    Object dest: 카피 배열
    int destPos: 카피 배열에서 카피를 시작하고자 하는 위치
    int length: 원본에서 복사본으로 데이터를 읽어서 쓸 데이터 길이
    ```

    - 예

      ```java
      import java.util.Scanner;
      public class asd{
      	public static void main(String[] args) {
      	String[] a = {"java", "python", "C++", "Node.js"};
      	String[] b = new String[6];
          // a배열의 a[0]부터 복사를 시작해서 3번째까지 c배열에 복사하되 c[1]부터 복사
      	System.arraycopy(a, 0, c, 1, 3);
      	}
      }
      ```

    - 결과

      ```java
      null
      java //a[0] 카피
      python //a[1] 카피
      C++ //a[2] 카피
      null
      null
      ```

- 배열의 주소복사: 카피 배열에 원 배열의 주소를 복사하면 된다.

  ```java
  import java.util.Scanner;
  public class asd{
  	public static void main(String[] args) {
          String[] a = {"java", "python", "C++", "Node.js"};
          String[] b;
          //주소복사
          b = a;
          for(int i=0;i<b.length;i++) {
              System.out.println(b[i]);
          }	
  	}
  }
  
  ```

  

  

### 3. 예제로 살펴보기

---------------


```java
import java.util.Collections;
import java.util.Scanner;
import java.util.Vector;

public class Test {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		Vector<Student> vec = new Vector(1,1);
		Vector<Integer> input = new Vector(1,1);
		while(true) {
			System.out.println("당신의 성적은?(-1 입력하면 종료)");
			int grade = sc.nextInt();	
			if(grade <= -1) break;
			vec.add(new Student(grade));
			input.add(grade);
			
		}
		//input = vec;값복사 --> 이렇게 작성하면 입력순서가 정렬된채로 나온다. 
        //input의 참조 주소가 정렬된 vec로 바뀌기 때문 
		input = (Vector<Integer>) vec.clone(); //값복사: clone() 메소드로 값복사를 행한다.
		Collections.sort(vec);
		int i=1;
		for(Student s: vec){ //정렬 출력
			System.out.print((i++) + " 등의 성적은");
			System.out.println(s);
		}
		System.out.println("================입력 순서==============");
		for(int i1=0;i1<input.size();i1++) { //입력값 출력
			System.out.println(input.elementAt(i1));
		}
	}
}
class Student implements Comparable<Student>{
	int grade;
	public Student(int grade) {
		this.grade = grade;
	}
	@Override
	public int compareTo(Student o) {
		if(this.grade < o.grade) return 1;
		else if(this.grade > o.grade) return -1;
		else return 0;
	}
	@Override
	public String toString() {
		return "[" + grade + "]";
	}
}
```

- 결과

  ```java
  당신의 성적은?(-1 입력하면 종료)
  54
  당신의 성적은?(-1 입력하면 종료)
  78
  당신의 성적은?(-1 입력하면 종료)
  96
  당신의 성적은?(-1 입력하면 종료)
  23
  당신의 성적은?(-1 입력하면 종료)
  0
  당신의 성적은?(-1 입력하면 종료)
  45
  당신의 성적은?(-1 입력하면 종료)
  10
  당신의 성적은?(-1 입력하면 종료)
  5
  당신의 성적은?(-1 입력하면 종료)
  87
  당신의 성적은?(-1 입력하면 종료)
  74
  당신의 성적은?(-1 입력하면 종료)
  65
  당신의 성적은?(-1 입력하면 종료)
  36
  당신의 성적은?(-1 입력하면 종료)
  69
  당신의 성적은?(-1 입력하면 종료)
  -1
  1 등의 성적은[96]
  2 등의 성적은[87]
  3 등의 성적은[78]
  4 등의 성적은[74]
  5 등의 성적은[69]
  6 등의 성적은[65]
  7 등의 성적은[54]
  8 등의 성적은[45]
  9 등의 성적은[36]
  10 등의 성적은[23]
  11 등의 성적은[10]
  12 등의 성적은[5]
  13 등의 성적은[0]
  ================입력 순서==============
  [54]
  [78]
  [96]
  [23]
  [0]
  [45]
  [10]
  [5]
  [87]
  [74]
  [65]
  [36]
  [69]
  ```

  