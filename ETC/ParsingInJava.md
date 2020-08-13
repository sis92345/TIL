String Parsing
==========
> 자바에서 문자열을 파싱하는 3가지 방법

> 파싱(parsing): 일련의 문자열을 의미있는 token으로 분해하는 과정

### 1. 자바에서 문자열을 파싱하는 3가지 방법
---------------
- 자바에서 사용하는 파싱은 3가지 클래스를 사용하여 파싱할 수 있다.
    + `String[] split(String regex)`
    + `java.util.StringTokenizer` 
    + `java.util.Scanner`

### 2. String[] split(String regex) 사용
---------------
- split 함수는 입력받은 정규표현식 또는 특정 문자를 기준으로 문자열을 나누어 배열에 저장한다.
- split 함수는 정규식만 잘 입력하면 배열의 길이를 신경 쓸 필요가 없다.
```java
String str = "2  422-5123  박은지  1084";
String[] array = str.trim().split("\\s+"); // \\s+: \s는 공백, \\s+는 공백이 하나 이상 나옴을 의미 
System.out.println(array.length);		
```
- 만약 배열의 길이를 제한하고 싶으면 'String[] split(String regex, int limit)'를 사용한다.
### 3. java.util.StringTokenizer 사용
---------------
- java.util.StringTokenizer는 파싱을 위해 사용한다. 
- 분리된 문자를 token이라고 한다
- 별도의 정규식은 필요 없지만 배열을 만들어 주지 않으므로 배열을 생성해야 한다.
-  java.util.StringTokenize constructor

|생성자|설명|
|------|------|
|StringTokenizer​(String str) |정규식을 받지 않는다:  \t\n\r\f로 파싱|
|StringTokenizer​(String str, String delim)|구획문자을 받는다|
|StringTokenizer​(String str, String delim, boolean returnDelims)|returnDelims이 true면 구획문자도 토큰|

- java.util.StringTokenizer의 주요 메소드

|메소드|설명|
|------|------|
|public int countTokens() |분리한 토큰의 개수를 반환|
|public boolean hasMoreTokens()|만약 토큰이 존재한다면 true반환|
|public String nextToken()|다음 토큰으로 넘어간다.|

- 예
    ```java
    	public static void main(String[] args) {
		String str = "2  422-5123  박은지  1084";
		StringTokenizer st = new StringTokenizer(str);
		//배열에 저장해야 한다.
		String[] array = new String[st.countTokens()];//존재하는 토큰 만큼 배열 생성
		int i = 0;
		while(st.hasMoreElements()) {//만약 다음 토큰이 남아있다면
			array[i] = st.nextToken();//다음 토큰으로 넘어감
			i++;
		}
		System.out.println(array[2]);
	}
    ```

### 4. java.util.Scanner
---------------
- Scanner로 문자열을 파싱한다. 
- Scanner에서 파싱을 위해 사용하는 메서드
- Scanner 파싱의 장점은 ,nextInt()나 next()로 데이터 타입을 사용할 수 있다.

|메소드|설명|
|------|------|
|public Scanner useDelimiter​(String pattern)|입력받은 Scanner를 구분자로 파싱|
|boolean hasNext() |다음 토큰의 유무를 리턴한다.|

- hasNext():는 다음 문자열 토큰이 존재하면 true를 반환한다.
    + hasNextInt(): 다음 정수 토큰이 존재하면 true를 반환한다.
    + hasNextDouble(): 다음 실수 토큰이 존재하면 true를 반환한다.
    + next()처럼 기본형을 지정할 수 있다.
        + 만약 hasNextInt()이고 데이터가 10 20 30.0이면 30.0에서 false를 반환한다.
- Scanner 파싱의 장점: 한 데이터를 다양한 형식으로 불러올 수 있다.

```java
public static void main(String[] args) throws Exception{
		File file = new File("C:/Temp/testData.txt");
		Scanner sc = new Scanner(file); 
		String[] array = new String[5];
		double[] array_d = new double[5];
		int i=0;
		String sum_S = "testData.txt:";
		double sum_D = 0.0;
		//input array
		while(sc.hasNext()) { //다음 문자열이 있으면 true 반환
			array[i] = sc.next(); //공백기준으로 인식해서 문자열을 반환한 후 배열에 저장
			i++;
		}
		sc.close(); //Scanner를 닫는다: 안닫으면 double 읽을때 데이터 끝인 50.5부터 읽어서 hasNext()가 false
		sc = new Scanner(file); 
		i=0;
		while(sc.hasNext()) { //다음 문자열이 있으면 true 반환
			array_d[i] = sc.nextDouble(); //데이터를 실수로 반환하여 배열에 저장
			i++;
		}
		//output_Cal
		for(int j=0;j<array_d.length;j++) {
			sum_S += array[j];
			sum_D += array_d[j];
		}
		System.out.println(sum_S);
		System.out.println(sum_D);
	}