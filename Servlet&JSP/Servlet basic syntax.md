Servlet
==========

> Servlet의 기초 문법
>
> web.xml
>
> Servlet의 기본 골격과 API 살펴보기
>
> Servlet의 Life Cycle

> Servlet을 이용한 4-tier MVC 구현
>

### 1. Servlet의 기초 문법

---------------

- Servlet의 기본적인 클래스이다.

  ```java
  import java.io.IOException;
  import java.io.PrintWriter;
  
  import javax.servlet.ServletException;
  import javax.servlet.http.HttpServlet;
  import javax.servlet.http.HttpServletRequest;
  import javax.servlet.http.HttpServletResponse;
  
  public class HelloServlet extends HttpServlet{
  	//모든 서블릿은 HttpServlet의 자식이어야한다.
  	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
  		//get방식으로 요청
  		//Servlet이 되려면 jar가 있어야 한다
  		//C:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar를 Add External jar 
  		
  		//res니까 나가는거
  		res.setContentType("text/html; charset=utf-8");
  		PrintWriter pw = res.getWriter();
  		//브라우저로 해당 태그를 사용
  		//즉 브라우저에서 클래스를 실행하기위한 것이 서블릿
  		//자바속에 HTML은 servlet
  		//HTML속에 자바는 JSP: 이게 더 편해서 이거 사용함
  		//쉽게말해 Servlet을 쉽게 만든게 JSP
  		//근데 이거 배워야하는 이유
  		//Spring의 MVC중 C가 Servlet
  		//web.xml 수정
  		/*
  		 
  		 * */
  		//meta 태그가 있어야 한글 나옴
  		//MIME TYPE: 다목적 인터넷 메일 익스텐션 
  		//auto/MP3
  		//HTML, CSS 전부 text/html, text/css, text/javascript
  		//res.setContentType("text/html");
  		pw.println("<html>");
  		pw.println("<head>");
  		pw.println("<meta charset='utf-8'>");
  		pw.println("</head>");
  		pw.println("<body>");
  		pw.println("<p style=\"font-size: 3em; color: red\">Hello Servlet 한글</p>");
  		pw.println("</body>");
  		pw.println("</html>");
  		pw.close();		
  	}
      public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
      	this.doGet(req, res);
      }
  }
  
  ```

  - 기본 구조

       - **모든 Servlet은 반드시 `HttpServlet`을 상속 받아야한다.**

            ```java
            public class HelloServlet extends HttpServlet
            ```

       -  **또한 `servlet-api.jar`를 import해야한다.**

            - 위치: C:\Program Files\Apache Software Foundation\Tomcat 9.0[CATALINA_HOME]\lib\servlet-api.jar

       - **`HttpServletRequest req, HttpServletResponse res`**

            - WAS가 클라이언트로부터 요청을 받으면 `HttpServletRequest req, HttpServletResponse res`두 객체를 생성해서 요청정보에 있는 path로 매핑된 servlet으로 전달한다.
                 - 즉 다음과 같은 과정을 거친다.
                      - 클라이언트가 요청할때 보낸 정보를 `HttpServletRequest`객체를 생성하여 저장
                      - 클라이언트에 응답을 보내기 위해서 `HttpServletResponse`객체를 생성
                      - 생성된  `HttpServletRequest req, HttpServletResponse res`를 servlet에 전달

       - **`doGet(HttpServletRequest req, HttpServletResponse res)`, `doPost(HttpServletRequest req, HttpServletResponse res)`**

            - <u>클라이언트는 Web Server에 `HTTP`/`HTTPS`를 통해 서버에 요청하게된다.</u> 이때 요청하는 방식이 2가지가 있는데 이게 **GET방식과 POST방식**이다.
                 - 일반적인 Requset Packet의 구조
                      - GET/POST
                      - 경로(/Day64/index.html)
                           - GET은 여기에 데이터가 넘어온다.
                      - HTTP버전(http/1.1)
                      - 필요한거 등등
                      - body
                           - POST는 여기에 데이터가 넘어온다.
            - **HTTP**: 웹상에서 클라이언트와 서버 간에 요청/응답으로 데이터를 주고 받을 수 있는 프로토콜
                 -  클라이언트가 HTTP 프로토콜을 통해 서버에게 요청을 보내면 서버는 요청에 맞는 응답을 클라이언트에게 전송한다.
            - **GET**:서버로부터 정보를 조회하기 위해 설계된 메소드
                 - GET은 요청을 전송할때 필요한 데이터를 Body에 담지 않고 쿼리 스트링을 통해 전송한다.
                 - 쿼리 스트링: URL의 끝에 `?`와 함께 이름과 값으로 쌍을 이루는 요청 파라미터다. 요청 파라미터가 여러 개이면 `&`로 연결
                 - <u>때문에 GET방식은 입력한 정보가 URL에 노출된다.</u> 
                      - `www.example-url.com/resources?name1=value1&name2=value2`
                           - ?뒤는 쿼리 스트링이고 name1은 parameter, value1는 parameter1의 값이다.
                           - `HttpServletRequest` 의 `getParameter(String parameter)`;을 통해서 이 parameter1의 값을 얻을 수 있다.
                 - 기타
                      - GET은 불필요한 요청을 제한하기 위해 요청이 캐시될 수 있다.
                           - 정적 컨텐츠를 요청하고 나면 브라우저에서는 요청을 캐시해두고, 동일한 요청이 발생할 때 서버로 요청을 보내지 않고 캐시된 데이터를 사용한다
            - **POST**:  리소스를 생성/변경하기 위해 설계
                 - <u>GET과 달리 전송해야될 데이터를 HTTP 메세지의 Body에 담아서 전송</u>
                      - 그래서`www.example-url.com/`와 같이 URL상에 나타나지 않는다.
                      - HTTP 메세지의 Body는 길이의 제한없이 데이터를 전송할 수 있다. 
                           - 그래서 POST 요청은 GET과 달리 대용량 데이터를 전송할 수 있다.
                      - 물론 개발자툴로 확인할 수 있어서 암호화는 필수
                      - *기본적으로 HTML은 GET이기 때문에 Content-Type에 POST라고 타입을 표시해야한다.*
            - **GET과 POST의 차이**
                 - GET은 Idempotent, POST는 Non-idempotent하게 설계
                      - 즉 GET은 서버에게 동일한 요청을 여러 번 전송하더라도 동일한 응답이 돌아와야한다.
                           - 이에 따라 GET은 설계원칙에 따라 서버의 데이터나 상태를 변경시키지 않아야 Idempotent하기 때문에 **주로 조회를 할 때에 사용**
                      - 하지만 POST는  Non-idempotent하기 때문에 **서버에게 동일한 요청을 여러 번 전송해도 응답은 항상 다를 수 있다**. 

       - **Servlet에서 GET과 POST**

            - *클라이언트가 GET으로 요청했다면 GET으로 받아야하고, POST로 요청했다면 POST로 받아야한다.* **이게 doGet()과 doPost의 역할이다.**
            - 반대로 받으면 405오류를 내뱉는다.

  - **`PrintWriter pw = res.getWriter();`**

       - `System.out.println();`: 에서 `System.out`이 표준 출력 장치 객체이고 `System.out.println();`이 콘솔로 데이터를 출력하기 위해 사용하므로 Web browser로 출력할 수 없다.
       -  `PrintWriter`는 이때 브라우저에 출력하기위해 사용된다.
            - `res.getWriter()`: 클라이언트에 character text를 보낼 수 있는 PrintWriter 객체를 반환
            - 이론 
                 - HTML은 text이다. 
                 - 바이너리 기반 스트림: InputStream, OutputStream
                 - 텍스트 기반 스트림: reader, Writer
                      - 바로 보내는게 아니라 Buffer로 전송
                           - Buffer: 데이터를 한 곳에서 다른 한 곳으로 전송하는 동안 일시적으로 그 데이터를 보관하는 메모리의 영역
                      - 그래서 flush해야 그때 buffer에서 나간다.
       - **`res.setContentType("text/html; charset=utf-8");`**: 브라우저는 html을 인식해야만 랜더링한다. 이 코드는 브라우저에게 이 문서가 html파일임을 명시함과 동ㅅ히에 characterset을 **utf-8로 설정해 한글을 표시하도록 한다.**


### 2. web.xml

------

- **web.xml**: Web Application 설정을 위한 Depolyment descriptor

  - 배포시 Servlet의 정보를 설정
  - 즉 Tomcat에게 배포할 Servlet이 무엇인지, 해당 Servlet을 어떤 URL로 접근해야하는지, Servlet 단독, 혹은 모두 사용할 수 있는 Application Variable을 설정할 수 있다.
  - `@WebServlet()`을 사용하지 않는다면 반드시 servlet에 대한 정보를 여기에 작성해야 한다.

- 예

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" id="WebApp_ID" version="4.0" metadata-complete='true'>
    <display-name>Welcome to Day64(1030)</display-name>
    <welcome-file-list>
      <welcome-file>index.html</welcome-file>
    </welcome-file-list>
  <!--<servlet>-->
    <servlet>
    	<servlet-name>include</servlet-name>
    	<servlet-class>com.example.libs.includeDemo</servlet-class>
    </servlet>
      <servlet>
    	<servlet-name>Now</servlet-name>
    	<servlet-class>com.example.libs.NowServlet</servlet-class>
    </servlet>
     <servlet>
    	<servlet-name>MyContext</servlet-name>
    	<servlet-class>com.example.libs.ContextDemoServlet</servlet-class>
    </servlet>
     <servlet>
    	<servlet-name>Mylocal</servlet-name>
    	<servlet-class>com.example.libs.lcoalDemoServlet</servlet-class>
    	<!-- init-param:<context-param>과 다르게 해당 Servlet만 사용가능 -->
    	<init-param>
    		<description>MySQL을 연결하기 위한 properties 파일 경로</description>
    		<param-name>mariadb.properties</param-name>
    		<param-value>C:\Temp\mariadb.properties</param-value>
    	</init-param>
    </servlet>
   <!--<servlet-mapping>--> 
     <servlet-mapping>
    	<servlet-name>include</servlet-name>
    	<url-pattern>/servlets/servlet/include</url-pattern>
    </servlet-mapping>
     <servlet-mapping>
    	<servlet-name>Now</servlet-name>
    	<url-pattern>/servlets/servlet/Now</url-pattern>
    </servlet-mapping>
     <servlet-mapping>
    	<servlet-name>MyContext</servlet-name>
    	<url-pattern>/servlets/servlet/ContextDemo</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
    	<servlet-name>Mylocal</servlet-name>
    	<url-pattern>/servlets/servlet/localDemo</url-pattern>
    </servlet-mapping>
    <!-- <context-param>:모든 Servlet 사용가능 -->
    <context-param>
    	<description>MySQL Driver</description>
    	<param-name>db.driver</param-name>
    	<param-value>com.mysql.jdbc.Driver</param-value>
    </context-param>
    <context-param>
    	<description>연결 URL</description>
    	<param-name>db.url</param-name>
    	<param-value>jdbc:mysql://localhost:3306/world</param-value>
    </context-param>
    <context-param>
    	<description>DB 유저이름</description>
    	<param-name>db.user</param-name>
    	<param-value>root</param-value>
    </context-param>
    <context-param>
    	<description>DB 유저 페스워드</description>
    	<param-name>db.password</param-name>
    	<param-value>javamysql</param-value>
    </context-param>
  </web-app>
  ```

- 주요 설정

  - **`<servlet></servlet>`**:  서블릿 이름과 실제 사용할 서블릿 클래스를 연결한다.

    - **`<servlet-name>Mylocal</servlet-name>`**: 임의의 이름을 설정한다.
      - 유저가 입력한 url에서 `<servlet-mapping>`의 `<url-pattern>/servlets/servlet/localDemo</url-pattern>`가 있다면 `<servlet-mapping>`의 `<servlet-name>`해당하는 이름과 같은 `<servlet>`의 `<servlet-name>Mylocal</servlet-name>`을 찾는다.
    -   **`<servlet-class>com.example.libs.lcoalDemoServlet</servlet-class>`**: `<servlet-name>`이 매핑되었다면 해당 클래스를 메모리에 로딩한다.

  - **`<servlet-mapping></servlet-mapping>`**: 서블릿 내부명과 URL 명과의 매핑 정보

    - **`<servlet-name>Mylocal</servlet-name>`**: 임의의 이름을 설정한다.
      - 유저가 입력한 url에서 `<servlet-mapping>`의 `<url-pattern>/servlets/servlet/localDemo</url-pattern>`가 있다면 `<servlet-mapping>`의 `<servlet-name>`해당하는 이름과 같은 `<servlet>`의 `<servlet-name>Mylocal</servlet-name>`을 찾는다.
    - `<url-pattern>/servlets/servlet/ContextDemo</url-pattern>`: `<servlet-class>`의 클래스를 매핑할 임의의 이름을 임력
      - **항상 `/`로 시작해야 한다.**
      - 쉽게 말해서 유저가 실제로 URL에 이 URL-Pattern을 입력하면 `<servlet-name>`을 통해서 `<servlet-class>`를 메모리에 로딩한다.

  - `<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" id="WebApp_ID" version="4.0" metadata-complete='true'>`의 **`metadata-complete='true'`**

    - **`@WebServlet()`사용**: **`metadata-complete='false'`**하고 web.xml은 더이상 건들이지 않는다.
    - **`@WebServlet()`사용** X: **`metadata-complete='true'`**하고 web.xml을 통해 servlet을 등록해야한다.

  - 초기화 파라미터: 웹 페이지가 실행될 때 필요한 데이터를 전달해 준다. 또한 서블릿 프로그램이 처음 실행될 때 클라이언트가 아닌 서버로부터 넘겨받는값이다.

    - **`<context-param>`**: 태그 안에 작성하지 않고 따로 작성, Application Variable라고 불라며 **모든 servlet에서 사용할 수 있다.**

    - **`<init-param>`**: `<servlet>`안에 작성하며 해당 servlet에서만 사용한다.

    - 공통 

      - ```xml
        <description>DB 유저이름</description><!--해당 파라미터의 설명-->
        <param-name>db.user</param-name><!--해당 파라미터의 이름, 즉 키-->
        <param-value>root</param-value><!--해당 파라미터의 값-->
        ```

    - 자세한 사용 방법은 메소드를 이용해야하니 아래를 참고하자

### 3. Servlet의 기본 골격과 API 살펴보기

------

- Servlets의 기본 골격

- ![]()

- interface Servlet: Servlet의 lifecycle에서 자세히 소개

  - void init(): servlet container에 의해 생성 
  - void service(): servlet container에 의해 servlet 요청과 응답을 다룹니다.
  - void destory(): servlet container에 의해 제거 
  - ServletConfig  getServletConfig(): Servlet이 시작할 때 필요한 정보가 담긴 ServletConfig를 반환합니다.
  - String getServletInfo(): 작성자, 버젼, 저작권과 같은 정보를 반환합니다.

- interface ServletConfig: 하나의 Servlet 초기화에 필요한 정보를 전달하기 위한 Config 객체입니다

  - getServletName()
  - getServletContext()
  - getInitParameter()
  - getInitParameterNames()

- GenericServlet

  - 위의 servletConfig와Servlet을 상속받으므로 해당 인터페이스의 메소드를 사용할 수 있다.
  - 위의 
  - GenericServlet에서 사용하는 method
    - GenericServlet()
    - getServletConfig()
    - log()
    - getServletName()

- HttpServlet

  - doGet()
  - doPost()
  - doHead()
  - doPut()
  - doDelete()
  - 기타 등등

- 공사중

  

  


### 4. Servlet의 LifeCycle

------

- Servlet에는 Life Cycle이 있다.

- Interface Servlet을 통해서 확인할 수 있다.

  - void init(): servlet container에 의해 생성 
  - void service(): servlet container에 의해 servlet 요청과 응답을 다룹니다.
  - void destory(): servlet container에 의해 제거 
  - 그런데 Servlet을 구현하려면 총 5개의 메소드를 구현하기 때문에 GenericsServlet을 이용해 위 3개의 메소드를 처리한다.

- 즉 Servlet의 LifeCycle은 다음과 같다.

  1. init(): 최초 한번 실행
  2. service()
  3. 새로고침
  4. service()
  5. 새로고침
  6. service()
  7. ......
  8. destory()
     1. Tomcat이 끝나거나 재컴파일 후 저장하면 destory() -> init()
     2. 즉 새로고침하면 새로운 내용을 볼 수 있다.
        1. Servlet 객체를 생성하고 초기화하는 작업은 비용이 많은 작업이므로, 다음에 또 요청이 올 때를 대비하여 이미 생성된 **Servlet 객체는 메모리에 남겨둔다.**
        2.  **요청이 매 번 똑같은 로직을 거쳐서 똑같은 결과를 산출하는 작업은 딱 한 번만 수행 되도록 init() 에서 처리한다.**

- 정리

  ```
  1. 요청이 오면, Servlet 클래스가 로딩되어 요청에 대한 Servlet 객체가 생성됩니다.
  2. 서버는 init() 메소드를 호출해서 Servlet을  초기화 합니다.
  3. service() 메소드를 호출해서 Servlet이 브라우저의 요청을 처리하도록 합니다.
  4. service() 메소드는 특정 HTTP 요청(GET, POST 등)을 처리하는 메서드 (doGet(), doPost() 등)를 호출합니다.
  5. 서버는 destroy() 메소드를 호출하여 Servlet을 제거합니다.
  ```

- 예

  ```java
  import java.io.BufferedOutputStream;
  import java.io.File;
  import java.io.FileNotFoundException;
  import java.io.FileOutputStream;
  import java.io.IOException;
  
  import javax.servlet.ServletException;
  import javax.servlet.ServletRequest;
  import javax.servlet.ServletResponse;
  import javax.servlet.annotation.WebServlet;
  import javax.servlet.http.HttpServlet;
  import javax.servlet.http.HttpServletRequest;
  import javax.servlet.http.HttpServletResponse;
  
  /**
   * 
   */
  
  /**
   * @author Administrator
   * @date 2020. 10. 31.
   * @Object Servlet의 개념
   * @Environment Windows 10 EE, openJDK 14.0.2
   */
  @WebServlet("/servlet/servlet/ServletDemo")
  public class ServletDemo extends HttpServlet {
  	private int serviceCount;
  	private FileOutputStream fos;
  	@Override
  	public void init() throws ServletException {
  		File f = new File("C:/Temp/Count.txt");
  		try {
  			fos = new FileOutputStream(f);
  			String start = "Now, Start a Text\n";
  			String start1 = "-------------------------\n";
  			byte[] b = start.getBytes();
  			byte[] b1 = start1.getBytes();
  			byte[] info = getServletInfo().getBytes();
  			System.out.println(getServletInfo() + "aaa");
  			fos.write(info);
  			fos.write(b);
  			fos.write(b1);
  			fos.flush();
  		} catch (FileNotFoundException e) {
  			e.printStackTrace();
  		} catch (IOException e) {	
  			e.printStackTrace();
  		}
  		System.out.println("START");
  	}
  	
  	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
  		
  		String service = serviceCount++ + " : ";
  		byte[] br = "\n".getBytes();
  		byte[] b = service.getBytes();
  		System.out.println("Web is Writing a Text");
  		fos.write(b);
  		fos.write(br);
  		fos.flush();
  		System.out.println("SERVICE");
  	}
  	
  	@Override
  	public void destroy() {
  		String end = "-------------------------\n";
  		String end1 = "Now, End a Text\n";
  		byte[] b = end.getBytes();
  		byte[] b1 = end1.getBytes();
  		byte[] b2 = "CopyRiget®".getBytes();
  		try {
  			System.out.println("Web ended a Text ");
  			fos.write(b);
  			fos.write(b1);
  			fos.write(b2);
  			fos.flush();
  			fos.close();
  		} catch (IOException e) {
  		
  			e.printStackTrace();
  		}
  		System.out.println("END");
  		
  	}
  }
  
  ```

  

### 5. JavaScript의 연산자



------









