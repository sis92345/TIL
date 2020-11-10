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


### 2. request

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

  

  

