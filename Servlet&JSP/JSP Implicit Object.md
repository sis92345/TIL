JSP Implict Object
==========

> JSP 내장 객체
>
> JSP 속성

> request
>
> response
>
> out
>
> session
>
> application
>
> pageContext
>
> page
>
> config
>
> exception

### 1. JSP Implict Object

---------------

- JSP 페이지를 작성할 때 특별한 기능을 제공하는 JSP 컨테이너가 제공하는 특별한 겍체를 말한다.
- 집 컴퓨터와 합쳐야 함

### 2.JSP 속성(attribute)과 속성과 관련된 메소드

------

- **내장 객체의 속성(attribute)**

  - <u>JSP의 속성(attribute)은 공유되는 데이터이다</u>. 즉 변수라고 할 수 있다.
  - JSP의 내장 객체 중 속성(attribute)을 가지는 내장 객체는 다음과 같다
    - request
    - session
    - application
    - page(pageContext)
  - 속성은 Scope, LifeCycle과 관련이 높다.
    - scope는 속성을 공유할 수 있는 범위이다.
      - 즉 위의 `request`, `session`, `application`, `pageContext` 의 속성 유효 범위는 모두 다르다.

- <u>`request`, `session`, `application`, `pageContext` 내장 객체는 임의 속성 값(attribute)를 저장 하고 읽을 수 있는 메소드를 제공하고 있다.</u>

- 내장 객체의 속성(attribute)과 관련된 메소드는 다음과 같다.

  | 메소드                                  | 리턴 타입             | 설명                                                         |
  | --------------------------------------- | --------------------- | ------------------------------------------------------------ |
  | setAttribute(String, key, Object value) | void                  | 해당 내장 객체의 속성  값(attribute)을 설정하는 메소드로, 속성명에 해당하는 key 파라미터에, 속성 값에 해당하는 value 파라미터에 값을 저장한다. |
  | getAttribute(String, key)               | Object                | 해당 내장 객체의 key를 읽어오는 메소드, <u>key에 해당하는 value를 object로 가져온다.</u> |
  | getAttributeNames()                     | java.util.Enumeration | 해당 내장 객체의 모든 key를 읽어오는 메소드                  |
  | removeAttribute(String key)             | void                  | 해당 내장 객체의 속성을 제거하는 메소드                      |


### 3. request

------

- **request** 

  - Type

    - `javax.servlet.http.HttpServletRequest`
    - javax.servlet.http.HttpServletRequest이 상속받은 Interface ServletRequest도 같이봐야한다.

- **request의 역할**

  1. Client에 관련된 정보를 읽는다: 클라이언트의 OS, IP, Brower
  2. Server와 관련된 정보를 읽는다.
  3. Client가 전송한 파라미터를 읽는다.
  4. Client가 전송한 Header정보를 읽는다
  5. Client의 Cookie 정보를 읽는다.
  6. 속성에 관한 정보를 관리한다.

- **주요 메소드**

  | Method                                       | 설명                                                         | 비고                                                         |
  | -------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | String getMethod()                           | request 요청 방식을 가져온다: GET/POST                       | -                                                            |
  | String getRequestURI()                       | 웹 서버로 요청 시, 요청에 사용된 URL 로부터 URI 값을 리턴한다. | URI와 URL의 차이점: https://velog.io/@jch9537/URI-URL        |
  | String getRequestURL()                       | 요청에 사용된 URL 로부터 URL 값을 리턴한다.                  | http://www.example.com/Day66/requestDemo.jsp                 |
  | String getServerName()                       | 서버의 도메인 이름을 리턴한다.                               | -                                                            |
  | String ContextPath()                         | Context Path를 리턴한다.                                     | -                                                            |
  | **String getParameter(String name)**         | **name에 해당하는 파라미터 값을 리턴**                       | -                                                            |
  | **Stirng[] getParameterValues(String name)** | **name에 해당하는 파라미터 값들을 리턴**                     | name의 value가 여러 개 일 때 사용한다.                       |
  | Enumeration<String> getHeaderNames()         | Header의 Key name을 가져온다                                 | -                                                            |
  | String getHeader(String name)                | Header의 Value를 가져온다.                                   |                                                              |
  | **request.setCharacterEncoding(String env)** | 요청 페이지에 대한 인코딩 정보                               | **GET방식의 경우 요청 페이지의 Page Directive 의 charset으로 자동으로 인코딩, 디코딩한다**(단 쿼리 스트링 파라미터에 직접 입력할 겨우 해당 브라우저의 인코딩 방식을 따른다.). **하지만 POST의 디코딩은 반드시 이 메소드를 사용해야만 한글이 출력된다.** http://www.example.com/Day66/register.jsp를 참고하라(Tomcat 구동 필) |

  - Local 관련 정보: 보통 서버를 지칭

    | 메소드         | 설명      | 비고 |
    | -------------- | --------- | ---- |
    | getLocalName() | 서버 IP   |      |
    | getLocalPort() | 서버 PORT |      |
    | getLocalAddr() | 서버IP    |      |

    - `getServerPort()`, `getServerName()`도 있다.

  - Client관련 정보

    |                 |                         |      |
    | --------------- | ----------------------- | ---- |
    | 메소드          | 설명                    | 비고 |
    | getRemoteAddr() | 클라이언트 IP 값 반환   |      |
    | getRemotePort() | 클라이언트 port         |      |
    | getRemoteHost() | 클라이언트 HOST 값 반환 |      |

    

- 예1: request 객체를 이용한 서버-클라이언트 정보 처리

  ```JSP
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <%--
  	request
  	1. Client에 관련된 정보를 읽는다: 클라이언트의 OS, IP, Brower
  	2. Server와 관련된 정보를 읽는다.
  	3. Client가 전송한 파라미터를 읽는다.
  	4. Client가 전송한 Header정보를 읽는다
  	5. Client의 Cookie 정보를 읽는다.
  	6. 속성에 관한 정보를 관리한다.
   --%>
  <!DOCTYPE html>
  <html>
  <head>
  <meta charset="UTF-8">
  <title>request 내장 객체 연습</title>
  </head>
  <body>
  	<ul>
  		<!-- scriptlet의 경우 ;를 사용해야한다. 자바코드이기 때문, 하지만 Expression의 경우 Servelt 변환 과정에서 자동으로 ; 붙여주기 때문에 ;를 붙이지 않는다. -->
  		<li>요청 메소드 : <%=request.getMethod() %></li>
  		<li>요청 URI : <%=request.getRequestURI() %></li>
  		<li>요청 URL : <%=request.getRequestURL() %></li>
  		<li>요청 ServerName :<%=request.getLocalName() %> </li>
  		<li>요청 ServerPort : <%=request.getLocalPort() %></li>
  		<li>요청 ContextPath : <%=request.getContextPath() %></li>
  		<li>Client IP : <%=request.getRemoteAddr() %></li>
  		<li>Client Machine : <%=request.getRemoteHost() %></li>
  		<li>Client User : <%=request.getRemoteUser() %></li>
  		<li>Client Port : <%=request.getRemotePort() %></li>	
  	</ul>	
  </body>
  </html>
  ```

- 예2: request를 이용한 클라이언트 전송 파라미터 읽기

  ```jsp
  <!--Register.html-->
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>www.example.com 회원 가입 페이지</title>
      <link rel="stylesheet" href="css/style.css">
  </head>
  <body>
  	<!-- servlet, Directive같은 서버사이드 언어가 있으므로 HTML이 아니라 JSP 파일을 사용한다. -->
      <h1>회원가입</h1>
      <form class="registerform"action="<%= request.getContextPath() %>/requestdemo1.jsp" method="GET">
      <ul class="register">
          <li>이름 : <input type="text" name="username"required></li>
          <li>성별 : 
              <input type="radio" name="gender" value="1" checked>남성&nbsp;&nbsp;
              <input type="radio" name="gender" value="2">여성
          </li>
          <li>나이 : <input type="number" name="userage"></li>
          <li>취미 :
              <input type="checkbox" name="hobby" value="게임" checked>게임&nbsp;&nbsp;
              <input type="checkbox" name="hobby" value="미니어처 제작">미니어처 제작&nbsp;&nbsp;
              <input type="checkbox" name="hobby" value="낚시">낚시&nbsp;&nbsp;
              <input type="checkbox" name="hobby" value="여행">여행&nbsp;&nbsp;
              <input type="checkbox" name="hobby" value="공부">공부&nbsp;&nbsp;
              <input type="checkbox" name="hobby" value="호캉스">호캉스
          </li>
          <li>
          	핸드폰 번호 : <select name="hp1">
          	<option value = "">--선택--</option>
          	<option value = "010">010</option>
          	<option value = "011">011</option>
          	<option value = "016">016</option>
          	<option value = "017">017</option>
          	<option value = "018">018</option>
          	</select>
          	-<input type="text" name="hp2">
          </li>
          <li>거주지 :
              <select name="city">
                  <option value="">--선택--</option>
                  <option value="서울">서울</option>
                  <option value="대전">대전</option>
                  <option value="대구">대구</option>
                  <option value="부산">부산</option>
                  <option value="울산">울산</option>
                  <option value="광주">광주</option>
                  <option value="인천">인천</option>
              </select>
          </li>
          <li>
              <button type="submit">가입하기</button> &nbsp;&nbsp;
              <button type="reset">취소하기</button>
          </li>
      </ul>
      </form>
  </body>
  </html>
  ```

  ```jsp
  <!--Register.html를 처리하는 메소드-->
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <%@ page import ="java.util.Enumeration"  %>
  <%
  	/* 
  	POST방식은 setContentType을 넣어야 한다: GET은 자동이지만 POST는 자동 아님 
  	request.setCharacterEncoding("utf-8");를 이용한다.
  	*/
  	/* request.setCharacterEncoding("utf-8"); */
  	Enumeration<String> names =  request.getParameterNames();
  %>
  <!DOCTYPE html>
  <html>
  <head>
  <meta charset="UTF-8">
  <title>회원가입 결과</title>
  <%if(request.getRemoteAddr().equals("0:0:0:0:0:0:0:1")){%>
  <link rel="stylesheet" href="css/style2.css">
  <%} else{%>
  <link rel="stylesheet" href="css/style.css">
  <%}%>
  </head>
  <body>
  	<ul>
  		<!-- 
  		POST방식은 setContentType을 넣어야 한다: GET은 자동이지만 POST는 자동 아님 
  		-->
  		
  		<%while(names.hasMoreElements()) {
  			String name = names.nextElement();
  			String hp="";
  			//hobby는 복수로 들어온다.
  			//나머지는 단수로 들어온다.
  			if(!name.equals("hobby")){
  				String value = request.getParameter(name);
  				if(!name.equals("gender")){
  					if(name.equals("hp1") && name.equals("hp2")){
  						hp += request.getParameter("name") + "-";
  					}
  					out.println("<li>" + name + " : " + value + "</li>");
  				}else{
  					if(value.equals("0")){
  						out.println("<li>" + name + " : " + "남성" + "</li>");
  					}else{
  						out.println("<li>" + name + " : " + "여성" + "</li>");
  					}
  				}
  				
  	
  			}else{
  				String[] values = request.getParameterValues(name);
  				String hobby = "";
  				if(values == null || values.length == 0){
  					hobby = "";
  				}else{
  					//user가 한개라도 선택했다면
  					for(int i = 0; i< values.length; i++){
  						hobby += values[i] + ",";
  					}
  					hobby = hobby.substring(0, hobby.length()-1);
  				}
  				out.println("<li>" + name + " : " + hobby + "</li>");		
  			}	
  		}
  		out.println("접속 IP: " + request.getRemoteAddr());
  		%>
  	</ul>
  </body>
  </html>
  ```

  

### 3. response

------

- **request** 

  - Type

    - `javax.servlet.http.HttpServletResponse`
    - javax.servlet.http.HttpServletResponse이 상속받은 Interface ServletResponse도 같이 봐야한다.

- **request의 역할**

  - JSP 페이지의 실행 결과를 클라이언트로 전송시 사용하는 객체

- **핵심 메소드**

  | 메소드                           | 설명                    | 비고                  |
  | -------------------------------- | ----------------------- | --------------------- |
  | **void sendRedirct(String url)** | **해당 url로 redirect** | forward가 아님을 유의 |
  | **void addCooke(Cookie cookie)** | 쿠키를 전송한다.        | 쿠키와 세션을 참고    |

  - sendRedirct(String url) 유의점

    - sendRedirct(String url)는 페이지를 작성 한 후 해당 URL로 Redirect한다,
    - 따라서 sendRedirct(String url)이외의 다른 코드가 존재한다면 해당 코드를 실행한 후 redirect한다.
    - <u>즉 sendRedirct(String url)는 return처럼 return 이후 코드를 실행하지 않는것이 아님을 유의하자.</u>
    - 또한 sendRedirect로는 파라미터를 넘기기 어렵다
      - 이 이유는 **Forward와 Redirct 비교를 참고**

  - 다양한 redirect

    - Javascript를 이용

      - location.href를 이용

        ```
        <script>
        		location.href = "./register.jsp?"; 
        </script>
        ```

      - sendRedirct(String url)를 이용

        ```jsp
        response.sendRedirect("https://jr.naver.com");
        ```

        

  - Local 관련 정보: 보통 서버를 

    | 메소드         | 설명      | 비고 |
    | -------------- | --------- | ---- |
    | getLocalName() | 서버 IP   |      |
    | getLocalPort() | 서버 PORT |      |
    | getLocalAddr() | 서버IP    |      |

    - `getServerPort()`, `getServerName()`도 있다.

- 이 외에는 해당 자료를 참고

### 4. out

------

- **out**

  - type

    - `javax.servlet.jsp.JspWriter`

  - <u>출력과 버퍼관리를 담당하는 메소드</u> 

    - buffer

      - JSP에서는 페이지 처리결과를 곧바로 클라이언트로 출력하지 않고, 이를 출력 버퍼에 모아두었다가 한꺼번에 응답한다.
      - 처리 과정
        1.  write: JSP에서 처리된 결과를 클라이언트로 바로 response하는 것이 아니라 <u>결과를 buffer로 이동</u>
        2. flush: <u>버퍼가 가득 차면 출력 후 버퍼를 flush한다</u>.
        3. 만약 버퍼 용량을 초과하는 내용이 있으면 flush한 후 다시 buffer를 채우고 flush 반복
      - JSP에서 buffer 다루는 다양한 방법
        - Page Directive
          - Page Directive의 autoFlush, buffer 속성으로 각각 flush 자동 여부와 buffer 용량을 정할 수 있다.
        - **out**
          - out 객체의 메소드를 이용하여 flush를 처리하거나 buffer를 닫거나, buffer 정보를 읽을 수 있다.

    - 주요 메소드

    - | 메소드                            | 설명                               | 비고 |
      | --------------------------------- | ---------------------------------- | ---- |
      | void flush()                      | flush                              |      |
      | void close()                      | flush를 한 후 buffer를 닫는다.     |      |
      | void clearBuffer()                | flush하지 않고buffer를 닫는다.     |      |
      | **String println(String string)** | buffer로 해당 String을 출력        |      |
      | abstract int getRemaining()       | 현재 남아있는 buffer 사이즈를 출력 |      |
      | int getBufferSize()               | 전체 buffer 사이즈 출력            |      |

      - `flush()`와 `close()`와 `clearBuffer()`의 비교
        - flush(): flush
        - close(): flush를 하고 buffer를 close
        - clearBuffer(): flush를 하지 않고 buffer를 close

    - 예

      ```jsp
      <%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8" buffer="4kb"%>
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="UTF-8">
      <title>Insert title here</title>
      </head>
      <body>
      	<ul>
      		<li>Buffer Size: <%=out.getBufferSize() %>KB></li>
      		<li>Remain Size: <%=out.getRemaining() %>KB></li>
      	</ul>
      </body>
      </html>
      <%
      	out.println("이 글자는 유저에게 전달되지 않을 겁니다");
      	//out.clear(); //이걸 제거하고 해보자
      	out.println("이 글자는 유저에게");
      	out.newLine();
      	out.clearBuffer(); //여기까지 buffer에 차지만 buffer를 내보내지 않고 전달되므로
      	out.println("전달될 겁니다"); //여기만 전송된다.
      	out.flush();
      %>
      ```

      

### 5. pageContext

------

- **pageContext**
  - type
      
- `javax.servlet.jsp.pageContext`
      
- pageContext의 용도
  
      1. 내장 객체를 가져온다.
         - Declaration에서는 내장 객체를 그냥 사용할 수 없고 pageContext의 메소드로 객체를 생성한다.
      2. 속성을 다룬다.
      3. **페이지의 흐름을 구한다.**
           1. include
           2. forward
    4. 커스텀 태그 생성
  
- 주요 메소드
  
    - 내장 객체를 가져오는 메소드
  
        | 메소드                             | 설명                                | 비고 |
        | ---------------------------------- | ----------------------------------- | ---- |
        | ServletRequest getRequest()        | request 기본 객체를 반환합니다.     |      |
        | ServletResponse getResponse()      | response 기본 객체를 반환합니다.    |      |
        | HttpSession getSession()           | session 기본 객체를 반환합니다.     |      |
        | ServletContext getServletContext() | application 기본 객체를 반환합니다. |      |
        | ServletConfig getServletConfig()   | config 기본 객체를 반환합니다.      |      |
        | JspWriter getOut()                 | out 기본 객체를 반환합니다          |      |
        | Exception getException()           | exception 기본 객체를 반환합니다    |      |
        | Object getPage()                   | page 기본 객체를 반환합니다.        |      |
      - 예
  
          ```jsp
          <%@page import="java.io.IOException"%>
          <%@ page language="java" contentType="text/html; charset=UTF-8"
              pageEncoding="UTF-8"%>
          <!DOCTYPE html>
          <!-- 
          	pageContext
          	1. 기본객체(내장객체) 구하기
          	2. 속성 다루기(페이지 기본값)
          	3. 페이지의 흐름을 구한다(include, forward) : cf)RequestDispatcher interface
          -->
          <!-- 기본객체를 다뤄야하는 이유 -->
          <%!
          	//Declaration에서는 내장 객체를 인식하지 않는다.
          	//out.println("Hello, world"); 이거 안돌아감
          	//Declaration는 맴버 변수와 메소드를 만들기 위함
          	//즉 Declaration은 _jspService()의 밖이다.
          	public void printDemo(PageContext pc) throws IOException{
          		//pageContext를 이용하여 Declaration안에서 내장 객체의 객체를 생성한다.
          		JspWriter out = pc.getOut();
          		//request, response의 문제
          		// getRequest();/getResonse()는 HttpServletRequest/Response의 부모형인 SerlvetRequest/ServletResponse로 받는다.
          		//그걸 형변환하면 됨
          		ServletRequest parentRequest = pc.getRequest();
          		HttpServletRequest request = (HttpServletRequest)parentRequest;
          		out.println("Hello, world");
          		out.println("USER'S Address : " + request.getRemoteAddr());
          	}
          	
          %>
        ```
  
  - 흐름 제어 관련 메소드
  
      - | 메소드                               | 설명                                           | 비고 |
        | ------------------------------------ | ---------------------------------------------- | ---- |
        | void include(String relativeUrlPath) | 지정한 상대경로 페이지를 현재 페이지로 include |      |
      | void forward(String relativeUrlPath) | 지정한 상대경로 페이지로 forward               |      |
  
        - include를 하는 여러 방법
          1. `RequestDispatcher include(request, response)`: servlet에서만 사용
          2. pageContext의 `void include(String relativeUrlPath)`:  아래 2가지 방법을 많이 사용
          3. include directive: `<%@ include file="header.jsp" %>`
          4. action tag: `<jsp:include page="header.jsp"/>`: 추천
        5. 자세한 내용은 action tag를 참고
  
- pageContext의 예: forward

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <%
  	String username = request.getParameter("username");
  	String userage = request.getParameter("userage");
  	if(username==null && userage==null){
  		//첫페이지라면
  		out.println("<h1>This page is first page</h1>");
  		out.println("<h1>if you enter a age</h1>");
  		out.println("<h1>this page will redirect a Appropriate page</h1>");
  		username="";
  		userage="0";
  	}
  	int age = Integer.parseInt(userage);
  	if(age<10 && age>0){
  		//response.sendRedirect("https://jr.naver.com");
  		pageContext.forward("/a.jsp"); //이름을 넘길 수 있다.
  	}else if(age>10&&age<65){
  		pageContext.forward("/register.jsp");
  	%>
  	
  	<!-- <script>
  		location.href = "./register.jsp?"; /*Redirect의 경우 유저이름을 넘기기가 어렵다.*/
  	</script> -->
  <%
  } else if(age>=65){
  	response.sendRedirect("/../Day65/gugudan.jsp"); //forward면 위로 못올라감 --> 무조건 /로 시작★★★★
  }
  %>
  
  <link rel="stylesheet" href="css/style.css">
  <form action="">
  	Name : <input type="text" name="username"><br>
  	Age : <input type="number" name="userage"><br>
  	<button type="submit">전송하기</button>
  	<p>response.sendRedirect()는 상대경로, 절대경로, 다른 도메인 모두 redirect할 수 있다</p>
  	<p>하지만 forword는 자신의 도메인에서 상대경로만으로 한정된다. 반드시 /로 시작해야한다.</p>
  	<p>forward는 url과 내용이 다르다. 즉 10살 이하로 입력하면 a페이지로 넘어가지만 url은 그대로</p>
  	<p>forward는 값을 Parameter로 넘길 수 있다.</p>
  	<p>GET 방식은 URL에서 한글을 지원한다.</p>
  	<p>Redirect: JavaScript를 이용하거나 response.sendRedirect()를 이용</p>
  </form>
  ```

  

