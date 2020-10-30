Servlet
==========

> Servlet
>
> Servlet의 기본 구조

> Tomcat에 Context 업로드하는 방법
>
> 

### 1. Java Servlet

---------------

- **Java Servlet이란?**

  - 웹 기반 요청에 대한 동적인 처리가 가능한 하나의 클래스
  - Servlet은 Server side에서 돌아가는 Java Program으로 백엔드 개발자가 담당해야할 부분이다.
    - MVC로 예를 들면 JSP가 view에서 돌아간다면 이 view에 필요한 model에서 돌아가는게 servlet이다.
  
- **Java Servlet 메커니즘이해**

  - Servlet을 이해하기 위해서는 WAS를 통한 웹 서버의 구동에 대해서 이해해야한다.

    ![https://github.com/sis92345/TIL/blob/master/img/tomcat1.jpg]()

  - <u>클라이언트는 Web Container가 아닌 웹 서버에 요청한다</u>. 세부적인 메커니즘은 다음과 같다.

    ```
    1. User는 www.example.com/Day61/servlets/servlet/Hello.nhn으로 요청한다.
    2. 유저의 요청을 Apache(웹서버)가 수신할 때, 확장자 또는 URL경로상에 미리 약속한 JkMount가 발견되면 본인이 처리하기 않고 AJP13에게 forward한다.
    3. AJP13은 자기가 연결된 Tomcat에게 요청한다.
    4. 요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조하여 D:/WebHome/Day61/WEB-INF/web.xml로 넘겨준다.
    5. 해당 web.xml은 user가 요청한 url(/servlets/servlet/Hello.nhn)을 보고 <servlet-mapping>밑의 <url-pattern>과 일치되는 servlet-name을 찾는다.
    6. 일치되는 servlet-name인 HelloWorld를 찾아서 <servlet>밑의 해당 이름과 같은 servlet-class를 찾는다.
    7. 그래서 일치되는 servlet-class를 찾으면 해당 클래스를 메모리에 로딩하고 실행하여 그 결과를 Apache(웹 서버)에게 출력한다.
    8. Tomcat으로 전달받은 출력 문자열을 그대로 유저에게 response한다.
    9. 유저의 브라우저는 웹서버로 부터 받은 문자열을 DOM(Tree 구조)로 parsing하고, 그다음 유저의 메모리에 로딩하고 웹페이제 rendering한다. 
    ```

  - Servlet과 Tomcat을 통해 웹을 구동하기 위해서는 다음과 같은 파일이 필요하다

    - 위치는 집 데스크톱 기준
    - `Context`: 톰캣의 server.xml에 등록하여 구동되는 하나의 웹 어플리케이션
      - Context는 다음과 같은 구조를 반드시 지녀야 한다.
        - **Context folder**
          - WEB-INF(필수, 대소문자 구분)
            - classes: Java 클래스 파일 
            - libs
            - **web.xml**
          - 그외 src같은 필요한 파일
        - **web.xml**: 클라이언트가 URL을 요청하였을때 어떤 Servlet 파일을 실행할 것인지 매핑해놓은 파일
    - Tomcat server.xml: Context등록에 필요
      - 등록된 Context는 localhost:8080/manager/html에서 Context별로 관리할 수 있다.
      - CATALINA_HOME의 webapps(루트폴더)에서 추가하는 방법이 있으나 이는 별도의 폴더로 뺄 수 없으므로 그냥 구글링 ㄱㄱ

  - 정리

    1. <u>유저는 www.example.com:8080나 www.example.com로 요청한다.</u>

       - www.example.com:8080은 Tomcat으로 요청(Web Container)

       - www.example.com은 Apache로 요청(Web Server)

         - 유저는 일일히 8080을 입력하여 웹 컨테이너에 요청하지 않는다.
- 또한 보안을 위해서도 유저는 웹 서버를 통해서 요청을 해야한다. 
         - **즉 www.example.com으로 접속해서 웹 서버가정적 페이지를 처리한 후 어디선가 동적 페이지를 처리해야하는데 이것이 이 다음부터의 역할이다**.

    2. <u>따라서 유저는  www.example.com/Day61/servlets/servlet/Hello.nhn을 통해서 접속한다.</u>

       1. 하지만 이를 위해서는 Apache와 Tomcat을 연동해야한다: 이게 AJP13의 역할이며, 연동은 ETC의 `4.톰캣설치`를 참고

    3. <u>Apache가 유저의 요청을 수락했을 때, 확장자 또는 URL경로상에 미리  약속한 JkMount가 발견되면 Apache가 처리하지 않고 Tomcat이 처리하도록 ajp13에 넘긴다. 이를 Forward라고 한다.</u>

       1. JkMount 설정의 Apache_home의 conf/hffd.conf에서 설정한다

       2. 예

          ```
          LoadModule jk_module modules/mod_jk.so
          JkWorkersFile "C:/Program Files/Apache24/conf/workers.properties" //연동할 톰캣의 목록을 적은 workers.properties의 위치
          JkLogFile "C:/Program Files/Apache Software Foundation/Tomcat 9.0/logs/mod_jk.log"
          JkMount /*.jsp ajp13 # jsp로 끝나는 파일이 있다면 이를 ajp13으로 넘긴다.
          JkMount /*servlet/* ajp13 # 경로상에 servlet이라는 단어가 있다면 이를 ajp13으로 넘긴다.
          ```

          ```
          #workers.properties 
          worker.list=ajp13 #worker(톰캣)의 이름, 임의 지정, 여러개의 톰캣을 사용할 경우 여러개를 지정해야하며 이 경우 구글링 ㄱㄱ
          worker.ajp13.type=ajp13 # Apache Http 서버와 Tomcat 서버가 통신하는 protocol은 ajp 13
          worker.ajp13.host=localhost #host 속성은 Tomcat 작업자가 ajp13 요청을 수신하는 호스트를 설정
          worker.ajp13.port=8009 #tomcat으로 보내는 apache의 포트, 즉 Apache는 80번 포트로 유저의 요청을 받고 8009포트로 ajp13으로 tomcat과 연동
          ```

    4. **요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조**

       1. 설정: CATAILNA_HOME의 conf/server.xml
          - server.xml의 host 태그 밑에 다음의 코드를 추가
          - `<Context path="/Day61" docBase="D:\git_env\Webhome\Day61" />`
            - path: Context의 Context path를 나타낸다. 각 요청 URL의 시작 부분이 Context path와 같을 때 해당 Context가 그 요청을 수락한다. 논리적 경로
              - 위는 path="/Day61"이므로 www.example.com/Day61로 유저가 입력하면 해당 Context의 docBase를 참조한다.
            - docBase: Context에 대한 Document Base를 나타낸다. 물리적 경로
            - 이는 더 찾아보기
       2. `localhost:8080/manager/html`에서 Context가 추가되었는지 확인
       3. 요청을 받은 Tomcat의 server.xml은 요청경로의 Day61의 docBase를 참조하여 D:/WebHome/Day61/WEB-INF/web.xml로 넘겨준다.

    5. web.xml: 해당 web.xml은 user가 요청한 url(/servlets/servlet/Hello.nhn)을 보고 `<servlet-mapping>`밑의 `<url-pattern>`과 일치되는 servlet-name을 찾는다.

       1. 예: 유저가 URL에 http://www.example.com/Day61/servlets/servlet/Calculator라고 입력했다면..

    6. 일치되는 servlet-name인 HelloWorld를 찾아서 `<servlet>`밑의 해당 이름과 같은 servlet-class를 찾는다.

    7. 그래서 일치되는 servlet-class를 찾으면 해당 클래스를 메모리에 로딩하고 실행하여 그 결과를 Apache(웹 서버)에게 출력한다.

       - 예: 유저가 URL에 http://www.example.com/Day61/servlets/servlet/Calculator라고 입력했다면..

         ```
          <servlet>
           	<servlet-name>Calculator</servlet-name> //3. 여기 있으니까 
           	<servlet-class>CalculatorServlet</servlet-class> //4. 해당 클레스를 메모리에 로딩하고 그 결과를 APACHE로 출력
          </servlet>
           
         <servlet-mapping>
           	<servlet-name>Calculator</servlet-name>//2. Calculator와 일치하는 걸 찾는다.
           	<url-pattern>/servlets/servlet/Calculator</url-pattern> //1. 이 URL이 유저가 입력한 URL과 일치하므로
         </servlet-mapping>
         ```

       - `<url-pattern>`은 실제 경로를 숨기는 역할도 한다.

       - 이를 HTML과 연동할 수 있다.

         - 유저가 http://www.example.com/Day61/index.html로 접속
         - HTML의 form 태그의 속성 중 action은 서버로 보낼 때 해당 데이터가 도착할 URL을 명시한다.
           - 예: `<form action="/Day61/servlets/servlet/Calculator" method="POST">`
         - 이를 이벤트와 연동시켜서 구현한다.

    8. <u>Tomcat으로 전달받은 출력 문자열을 그대로 유저에게 response한다.</u>

    9. <u>유저의 브라우저는 웹서버로 부터 받은 문자열을 DOM(Tree 구조)로 parsing하고, 그다음 유저의 메모리에 로딩하고 웹페이지에 rendering한다.</u> 


### 2. Servlet으로  Tomcat에 올리는 2가지 방법 

------

- Servlet으로 작성한 Context를 Tomcat을 이용하여 Web에 올리기 위해서는 3가지 방법을 사용한다.

  - **FM: Tomcat의 `server.xml`에 `<context>`태그 를 등록한 후 해당 docBase에 Context구조를 갖춘 폴더를 준비하고 Web.xml에 url을 등록**
  - **`@WebServlet`이용 FM방법과 같이 `server.xml`에 `<context>`를 등록하는건 갖지만 해당 Context의 Web.xml의 `metadata-complete="true"`를 false로 바꾸고 로딩할 Servlet 파일의 클래스 명 위에 `@WebServlet("url-pattern")`등록**
  - WAR파일 이용: 이클립스를 이용하여 자동으로 만든 Context구조는 FM방식의 Context와 다르므로 WAR파일로 만들어 CATALINA_HOME의 WebApps에 WAR파일로 넣어야한다.
    - 이클립스를 이용하여 자동으로 Context구조를 갖출경우 WEB-INF가 WebContext아래에 있으므로 Context구조를 지니고 있지 않아서 Tomcat에 바로 등록이 불가능하다,

  1. **FM** 

     1. <u>CATALINA_HOME\conf\server.xml의 `<host>`밑에 올릴 Context 태그를 추가</u>

        1. `<Context *path*="/Day62" *docBase*="D:\git_env\Webhome\Day62" />`

           1. path: 논리적 경로
           2. docBase: 물리적 경로

        2. 해당 Context는 다음과 같은 구조를 지녀야 한다.

           ```
           Context folder1
           	- src: java source file
           	- WEB-INF: 필수
           		- classes: java classes file
           		- lib: java jar file
           		- web.xml: 필수
           ```

        3. Context의 자세한 내용은 다음 챕터를 참고

        4. Apache로 접속하려면 따로 설정해야한다. 이는 ETC의 톰캣 설치를 참고

     2. <u>web.xml</u>

        1. 주요 태그

           1. `<display-name>Welcome to 1027</display-name>`: tomcat manager app에 올릴 설명

           2. ```xml
              <servlet>
                	<servlet-name>HelloWorld</servlet-name>
                	<servlet-class>HelloServlet</servlet-class>
                </servlet>
              ```

              - `<servlet-name>Register</servlet-name>`: `<servlet-mapping>`의 `<servlet-name>`이 찾아올 이름
              - `<servlet-class>RegisterServlet</servlet-class>`: `<servlet-mapping>`의 `<servlet-name>`이 `<servlet>`의 `<servlet-name>`을 찾아왔다면 이 태그에 해당하는 클래스를 메모리에 로딩한다.

           3. ```xml
              <servlet-mapping>
                	<servlet-name>HelloWorld</servlet-name>
                	<url-pattern>/servlets/servlet/Hello.nhn</url-pattern>
                </servlet-mapping>
              ```

              - `<servlet-name>HelloWorld</servlet-name>`: `<servlet>`에서 해당하는 `<servlet-name>`을 찾는다.
              - `<url-pattern>/servlets/servlet/Hello.nhn</url-pattern>`: 유저가 `<url-pattern>`에 해당하는 url을 입력하면 `<servlet-name>`을 찾는다. 
                - `<url-pattern>`은 실제 경로를 감추는 역할을 한다.

           4. web.xml 전체 코드

              ```xml
              <?xml version="1.0" encoding="UTF-8"?>
              
              <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                                    http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
                version="4.0"
                metadata-complete="true">
              
                <display-name>Welcome to 1027</display-name>
                <servlet>
                	<servlet-name>HelloWorld</servlet-name>
                	<servlet-class>HelloServlet</servlet-class>
                </servlet>
                <servlet>
                	<servlet-name>Register</servlet-name>
                	<servlet-class>RegisterServlet</servlet-class>
                </servlet>
                <servlet>
                	<servlet-name>Calculator</servlet-name>
                	<servlet-class>CalculatorServlet</servlet-class>
                </servlet>
                
                <servlet-mapping>
                	<servlet-name>HelloWorld</servlet-name>
                	<url-pattern>/servlets/servlet/Hello.nhn</url-pattern>
                </servlet-mapping>
                <servlet-mapping>
                	<servlet-name>Register</servlet-name>
                	<url-pattern>/servlets/servlet/Register</url-pattern>
                </servlet-mapping>
                <servlet-mapping>
                	<servlet-name>Calculator</servlet-name>
                	<url-pattern>/servlets/servlet/Calculator</url-pattern>
                </servlet-mapping>
              </web-app>
              
              ```

     3. Web Container에서 돌아갈 파일 작성

        - 여기서는 java파일

        - 전체 코드

          ```java
          import java.io.IOException;
          import java.io.PrintWriter;
          
          import javax.servlet.ServletException;
          import javax.servlet.http.HttpServlet;
          import javax.servlet.http.HttpServletRequest;
          import javax.servlet.http.HttpServletResponse;
          
          public class HelloServlet extends HttpServlet {
          	@Override
          	public void doGet(HttpServletRequest req, HttpServletResponse res) 
          		throws IOException, ServletException{
          		PrintWriter out = res.getWriter();
          		out.println("<h1>Welcome Servlet</h1>");
          		out.println("<div style='color:red;font-size:2em;'>");
          		out.println("Hello, World</div>");
          		out.close();
          	}
          }
          
          ```

          - <u>Servlet파일은 항상 HttpServlet을 상속받아야한다.</u>
          - `doGet()`/`doPost()`: Apache의 Tomcat에 보낸 GET/POST에 따라 다른 메소드로 받아야한다.
            - Web Server에서 GET방식으로 전송했는데 doPost()로 받으면 오류
          - `PrintWriter out = res.getWriter();`: Web Server로  출력

  2. `@WebServlet("url-pattern")`**사용**

     1.  url-pattern: web.xml의 `<url-pattern>/servlets/servlet/Calculator</url-pattern>`과 동일

     2. 마찬가지로 server.xml에 context를 등록해야한다.

     3. web.xml 수정

        - `metadata-complete="ture"`를 `metadata-complete="false"`

        ```xml
        <?xml version="1.0" encoding="UTF-8"?>
        
        <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                              http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
          version="4.0"
          metadata-complete="false"> <!--metadata-complete="false", 여기가 달라진다.-->
        
        </web-app>
        
        ```

     4. Web Container에서 돌아갈 파일 작성

        - @WebServlet("url-pattern")를 클래스위에 붙인다.
        - 사용자는 "url-pattern"로 입력하면 해당 클래스가 메모리에 로딩된다.

        ```java
        
        package com.example.libs;
        
        import java.io.BufferedOutputStream;
        import java.io.FileNotFoundException;
        import java.io.FileOutputStream;
        import java.io.IOException;
        
        import javax.servlet.GenericServlet;
        import javax.servlet.ServletConfig;
        import javax.servlet.ServletException;
        import javax.servlet.ServletRequest;
        import javax.servlet.ServletResponse;
        import javax.servlet.annotation.WebServlet;
        
        /**
         * @author SIST4-10
         * @Date 2020. 10. 28.
         * @Object 서블릿의 라이프 사이클, 상속된거 주의
         * @Environment Windows 10 Pro, openJDK 14.0.2
         */
        @WebServlet("/servlets/servlet/Lifecycle")
        public class ServletLifeCycle extends GenericServlet{
        	private int initCount;
        	private int serviceCount;
        	private int destoryCount;
        	private BufferedOutputStream bos;
        	//FileOutputStream(File name, append boolean); append는 누적 여부를 의미
        	//Servlet interface 상속받으면 메소드 5개를 강제 재정의해야함, 따라서 자식인 GenericServlet을 상속받아서 원하는거 재정의
        	//서블릿의 Life Cycle: init() -> service() -> service() -> ... -> service() -> destory()
        	//재컴파일 후 저장하면 destory() -> init()
        	//브라우저에서 입력하면 console창에 나타남
        	//브라우저에서 F5계속 누르면 service()가 계속 실행된다.
        	//즉 새로고침을 누르면 변경된 내용을 볼 수 있다.
        	//FileoutputStream을 이용한 것
        	@Override
            public void init(ServletConfig config) throws ServletException{
        		//init()는 단 한번 메모리에 로딩됨을 유의
        		try {
        			this.bos = new BufferedOutputStream(new FileOutputStream("C:/temp/lifecycle.txt",true));
        			String str = "called init() :" + ++this.initCount + "\n";
        			this.bos.write(str.getBytes());
        			this.bos.flush(); //실제 파일보냄
        		} catch (IOException e) {
        			e.printStackTrace();
        		}
            }
        	
        	@Override
        	public void service(ServletRequest arg0, ServletResponse arg1) throws ServletException, IOException {
        		String str = "called service() :" + ++this.serviceCount + "\n";
        		this.bos.write(str.getBytes()); //buffer에 writer
        		this.bos.flush();//buffer를 사용하면 무조건 flush
        		
        	}
        	@Override
        	public void destroy() {
        		String str = "called destory() :" + ++this.destoryCount + "\n";
        		try {
        			this.bos.write(str.getBytes());
        			this.bos.flush();
        			this.bos.close();
        		} catch (IOException e) {
        			// TODO Auto-generated catch block
        			e.printStackTrace();
        		}
        	}
            
        }
        
        ```
        
     
  3. WAR파일 이용

     - 이클립스를 이용하여 자동으로 Context구조를 갖출경우 WEB-INF가 WebContext아래에 있으므로 Context구조를 지니고 있지 않아서 Tomcat에 바로 등록이 불가능하다.
     - 따라서 이클립스에서는 project를 EXPORT할 때 WAR파일로 만들 수 있다.

### 3. Tomcat Context

------

- Context: Tomcat에서 돌아가는 Web Application
- Context는 다음과 같은 구조를 지녀야한다.
- ![https://github.com/sis92345/TIL/blob/master/img/tomcat2.jpg](https://github.com/sis92345/TIL/blob/master/img/tomcat2.jpg)
  - WEB-INF: 필수
  - 나머지는 내가 필요해서 만든 파일
- ![https://github.com/sis92345/TIL/blob/master/img/tomcat2-1.jpg](https://github.com/sis92345/TIL/blob/master/img/tomcat2-1.jpg)
  - classes: `java.class`파일이 위치
  - libs: 자바에 필요한 `jar`파일이 위치
    - 예를 들어 DB연동에 필요한 Driver jar가 여기에 위치해야 Tomcat에서 연동할 수 있다.
- 이클립스에서 자동으로 생성할때 문제점과 대처법
  - Eclipse에서 Danymic Web Project로 프로젝트를 생성할때 다음과 같이 Context의 구조가 약간 다르다.
  - ![https://github.com/sis92345/TIL/blob/master/img/tomcat3.jpg](https://github.com/sis92345/TIL/blob/master/img/tomcat3.jpg)
    - Java Resources
      - Java, Servlet과 같은 동적 콘텐츠가 위치
    - WebContent
      - HTML, CSS, JavaScript와 같은 정적 콘텐츠가 위치
      - **build**: class파일이 위치한다. 본래 Context구조의 WEB-INF/classes의 역할
      - **WEB-INF**: 바로 위에 아무 폴더가 없던 WEB-INF가 WebContent가 여기에 위치한다.
        - web.xml
  - 따라서 본래의 방법으로 Tomcat에서는 이 Context를 인식할 수 없다. 그래서 앞에 설명한 WAR로 만들어서 webapps폴더에 넣어서 인식한다.


### 4. JavaScript의 변수

------



### 5. JavaScript의 연산자

------









