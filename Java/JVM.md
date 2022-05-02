# JVM

# 1. 개요

옛날 프로그래밍 언어는 하드웨어에 종속된 경우가 많았습니다. Java를 개발한 제임스 고슬링이 Java에 녹인 여러 개발 철학 중 **WORA**( Write Once Run Anyware )의 개념이 반드시 나오는 이유도 바로 이 때문입니다. WORA은 JVM으로 구현되었습니다. 

이 JVM때문에 Java는 컴파일 언어와 인터프리터 언어의 성격을 둘 다 가지고 있습니다. 최초 프로그래머가 작성한 소스코드를 바이트 코드로 컴파일 한 후 컴파일된 클래스 파일은 JVM을 사용해서 실행합니다. 사실 이 구분은 요즈음에 들어서는 크게 의미는 없지만 한 번 짚고 넘어가는 것도 좋을 것 같습니다,

# 2. JVM 구조

![구조](https://user-images.githubusercontent.com/68282095/166248805-975d6db6-0729-476d-844a-9244fca93ea8.png)

JVM구조를 크게 요약하면 다음과 같습니다.

1. Class Loader : 클래스를 로드하는 중요한 기능을 담당합니다.
2. Runtime Data Areas : 실제 클래스 파일이 적재되는 영역입니다. JVM이 프로그램을 실행하기 위한 데이터와 명령어가 여기에 존재합니다. 쉽게 생각하면 메모리 영역입니다.
3. Execution Engine : Runtime Data Area(메모리)에 할당된 바이트 코드는 Exectuion Engine에 의해 실행합니다. 바이트 코드를 읽고 조각별로 실행합니다.

각 영역에는 아래의 서브 시스템이 존재합니다.

1. Class Loader
   1. Loading
      1. BootStrap ClassLoader
      2. Extension ClassLoader
      3. Application ClassLoader
   2. Linking
      1. Verify
      2. Prepare
      3. Resolve
   3. Intitaialization
2. Runtime Data Areas
   1. Method Area
   2. Heap Area
   3. Stack Area
   4. PC Register
   5. Native Method stack
3. Execution Engine
   1. Interpreter
   2. JIT Complier

# 3. ClassLoader

ClassLoader는 크게 Load, Linking, initialization까지 크게 3가지 일을 담당하게 됩니다.

우리가 작성한 소스코드는 IDE에 내장된 컴파일러를 통해 바이트 코드로 변환됩니다. ClassLoader는 각 디렉토리에 있는 ClassLoader와 `$JAVAHOME_`에 존재하는 가장 기본적인 라이브러리를 로드하는 역할을 담당합니다. 쉽게 말하면 **런타임에 클래스를 동적으로 JVM에 로드 하는 역할을 수행하는 역할은 하는것이 ClassLoader입니다.**

## 3-1. Loading

- **Bootstrap ClassLoader** 
  - <u>`$JAVA_HOME/jre/lib`에 존재하는 rt.jar및 기타 핵심 라이브러리를 로드합니다.</u>
    - rt.jar에는 String.class나 Object.class같은 Java의 핵심 클래스가 존재합니다.
  - 특히 모든 클래스는 `java.lang.ClassLoader`인스턴스에 의해 로드되는데 ClassLoader또한 클래스이므로 ClassLoader를 로드하는 최상위 로더가 Bootstrap ClassLoader입니다.
- **Extension ClassLoader**
  - Bootstrap ClassLoader의 자식이며 어플리케이션에 필요한 표준 코어 Java 클래스의 확장을 로드합니다.
  - 일반적으로 `$JAVA_HOME/lib/ext` 같은 클래스의 확장을 로드합니다. 대표적으로 zipFile 클래스가 여기에 존재합니다.
    - `java.ext.dirs` 환경변수에 설정된 디렉토리의 클래스 파일을 로드하며 이 값이 설정되지 않을 경우 `$JAVA_HOME/lib/ext`에서 로드합니다.
- **Application ClassLoader** ( == System ClassLoader )
  - 모든 응용프로그램 수준의 클래스는 System ClassLoader가 JVM으로 로드합니다.
  - *Classpath* 에 있는 클래스들을 탑재합니다.
  - 또한 -classpath또는 -cp 명령어에서 찾은 파일을 로드합니다.
- Custom ClassLoader 
  - Application ClassLoader의 자식으로 구현 가능한 클래스로더입니다.

JVM에서는 위 3개의 ClassLoader를 통해 클래스를 로드하며, 이 모든 클래스로더로 클래스르 찾을 수 없다면 ClassNotFoundException이 발생합니다.

실제 아래 3개의 클래스의 클래스 로더를 확인 할 수 있습니다.

1. `User.class` : 어플리케이션 클래스 -> Application ClassLoader

2. `CollationData_bg.class` : $JAVAHOME/lib/ext -> Extension ClassLoader

3. `Object.class` : Bootstrap ClassLoader -> 네이티브하게 짜여져 있기 때문에 null

   ```java
   import sun.text.resources.bg.CollationData_bg;
   
   import java.io.IOException;
   import java.util.zip.ZipFile;
   
   public class main {
   
       public static void main(String[] args) {
   
           CollationData_bg data = new CollationData_bg();
           System.out.println( "User ClassLoader : " + User.class.getClassLoader() );
           System.out.println( "ZipFile ClassLoader : " + data.getClass().getClassLoader() );
           System.out.println( "Object ClassLoader : " + Object.class.getClassLoader() );
       }
   }
   
   class User {
   
   }
   
   ```

   ```
   // 결과
   User ClassLoader : sun.misc.Launcher$AppClassLoader@18b4aac2
   ZipFile ClassLoader : sun.misc.Launcher$ExtClassLoader@74a14482
   Object ClassLoader : null
   
   ```

   

## 3-2. Linking

1. Verify - 바이트 코드 검증기는 생성된 바이트 코드가 올바른지 여부를 확인합니다. 확인에 실패하면 확인 오류가 발생합니다
2. Prepare - 모든 *static 변수*에 대해 메모리가 할당되고 기본값으로 할당됩니다.
3. Resolve - 모든 기호 메모리 참조가 메서드 영역의 원래 참조로 대체됩니다.

# 4. Runtime Data Area

런타임 데이터 영역(Runtime Data)은 실제 클래스 파일이 적재되는 곳 입니다. JVM이 OS로부터 자바 프로그램 실행을 위한 데이터와 명령어를 저장하기 위해 할당받는 메모리 공간입니다. 메소드, 힙, 스택 영역을 알아두어야 합니다.

## 4-1. Method Area ( = static area )

**인스턴스 생성을 위한 객체 구조, 생성자, 필드등이 저장**됩니다. *Runtime Constant Pool* 과 *static* 변수, 그리고 메소드 데이터와 같은 *Class* 데이터들도 이곳에서 관리가 됩니다. *즉 Method Area는 메타 데이터를 저장하는 공간*이라고 할 수 있으며 따라서 <u>모든 Thread는 하나의 Method Area를 공유</u>합니다. 

- **메서드 영역은 여러 스레드에 대한 메모리를 공유하므로 저장된 데이터는 스레드로부터 안전하지 않습니다.**

- Method Area는 JVM당 하나만 생성됩니다.
- static 키워드를 붙인 필드나 메소드도 여기에 올라갑니다. 그래서 static 변수는 어디서나 접근이 가능합니다.

*JVM* 의 다른 메모리 영역에서 해당 정보에 대한 요청이 오면, 실제 물리 메모리 주소로 변환해서 전달해줍니다. 기초 역할을 하므로 ***JVM* 구동 시작 시에 생성이 되며, 종료 시까지 유지되는 공통 영역**입니다.

아래는 Method Area에 저장되는 정보입니다.

1. `Type Information`
   - Type의 전체 이름 (패키지명 + 클래스명)
   - Type의 직계 하위 클래스 전체 이름
   - Type의 클래스 / 인터페이스 여부
   - Type의 modifier (public / abstract / final)
   - 연관된 인터페이스 이름 리스트
2. `Runtime Constant Pool`
   - Type, Field, Method로의 모든 Symbolic Reference 정보를 포함
   - Constant Pool의 Entry는 배열과 같이 인덱스 번호를 통해 접근
   - Object의 접근 등 모든 참조를 위한 핵심 요소
3. `Field Information`
   - Field Type
   - Field modifier (public / private / protected / static / final / volatile / transient)
4. `Constructor를 포함한 모든 Methods`
   - Method Name
   - Method Return Type
   - Method Parameter 수와 Type
   - Method modifier (public / private / protected / static / final / syncronized / native / abstract)
     Method 구현 부분이 있을 경우 ( abstract 또는 native 가 아닐 경우 )
   - Method의 byteCode
   - Method의 Stack Frame의 Operand Stack 및 Local variable section의 크기
   - Exception Table
5. `Class Variable`
   -  static 키워드로 선언된 변수
   - 이 변수는 인스턴스의 것이 아니라 클래스에 속하게 된다.



## 4-2. Heap

모든 객체(런타임 시 결정되는 참조 자료형)와 객체의 인스턴스 변수들이 저장되는 영역입니다. JVM당 하나의 힙 영역도 있습니다.

- **new 연산자로 생성된 객체의 인스턴스가 여기에 저장됩니다.**

- **영역은 여러 스레드에 대한 메모리를 공유하므로 저장된 데이터는 스레드로부터 안전하지 않습니다.**
- 객체가 더이상 쓰이지 않거나 명시적으로 null로 선언된다면 GC가 청소합니다.

## 4-3. Stack

*Stack은 Thread 별로 따로 할당되는 영역입니다*. Heap 메모리 영역보다는 빠르고 각 Thread 별로 데이터를 저장하기 때문에 동시성 문제에서 자유롭습니다.

각 Thread들은 메소드 호출 시 Frame이라는 단위를 추가합니다. 메소드가 마무리 된다면 해당 Frame은 Stack에서 pop됩니다. Frame은 메소드에 대한 정보를 가지고 있는 Local Variable, Operand Stack, Constant Pool Reference로 구성됩니다. 해당 구조는 JavaScript의 Call Stack 구조를 생각하면 이해하기가 빠릅니다.

- **기본형 타입 변수의 값은 stack 영역에 저장됩니다. 참조형 변수의 값은 참조값이 저장되며 참조값은 Heap Area에 있는 실제 인스턴스를 가르키는 역할을 합니다.**
- 모든 지역변수는 Stack 영역에 저장됩니다.
- 내부 Frame은 외부 Frame의 값을 참조할 수 있습니다. 단 메소드를 넘어서는 것은 별개의 스택 프레임이기 때문에 접근할 수 없습니다.

## 4-4. PC Register

*PC Register는 Thread 별로 따로 할당되는 영역입니다*. Thread가 어떠한 명령을 실행하게 될지에 대한 부분을 기록을 합니다.

## 4-5. Native Methods Area

바이트 코드가 아닌 기계어로 작성된 코드를 실행하는 공간으로 다른 언어(c/c++)로 작성된 코드를 수행하기 위해 존재합니다. Thread 별로 생성됩니다.

# 5. Execution Engine

**런타임 데이터 영역에** 할당된 바이트코드 는 실행 엔진에 의해 실행됩니다. 실행 엔진은 바이트 코드를 읽고 조각별로 실행합니다

1. **Interpreter**  - 인터프리터는 바이트 코드를 더 빠르게 해석하지만 실행은 느립니다. 인터프리터의 단점은 하나의 메소드가 여러 번 호출될 때마다 새로운 해석이 필요하다는 것입니다.
2. **JIT Compiler** - JIT Compiler는 인터프리터의 단점을 중화합니다. 실행 엔진은 바이트 코드를 변환할 때 인터프리터의 도움을 사용하지만 반복되는 코드를 찾으면 전체 바이트 코드를 컴파일하고 네이티브 코드로 변경하는 JIT 컴파일러를 사용합니다. 이 네이티브 코드는 반복되는 메서드 호출에 직접 사용되어 시스템 성능을 향상시킵니다.
   - **Intermediate Code Generator**
   - **Code Optimizer**
   - **Target Code Generator** 
   - **Profiler** 
3. **Garbage Collector** -  참조되지 않은 객체를 수집하고 제거합니다. 가비지 컬렉션은 호출하여 트리거할 수 있는 `System.gc()`있지만 실행은 보장되지 않습니다. JVM의 가비지 컬렉션은 생성된 객체를 수집합니다.
4. **JNI(Java Native Interface)** - JNI는 기본 메서드 라이브러리와 상호 작용하고 실행 엔진에 필요한 기본 라이브러리를 제공합니다.
5. **Native Method Libraries** - Execution Engine에 필요한 Native Libraries의 모음입니다.

# 99. 참고문서

1. ClassLoader : https://www.baeldung.com/java-classloaders
2. JVM : https://dzone.com/articles/jvm-architecture-explained
3. Heap vs Stack : https://yaboong.github.io/java/2018/05/26/java-memory-management/

