EL(Expression Language)
==========

> EL 개요



> EL의 표현
>
> EL의 내장 객체
>
> Scope
>
> pageContext
>
> Param & ParamValues
>
> Header & Header Values
>
> Cookie
>
> initParam
>
> EL에서 배열과 컬렉션 사용

### 1. EL

---------------

- **EL(Expression Language)**

  - JSP 2.0에서 추가된 개념

  - *기존 JSP의 출력을 보완하는 개념으로 JSP에서 자바코드를 최소화하기 위한 방법이다.*

    - 아래는 코드에서 내장 객체를 이용한 방법과 EL과 비교해보자

      ```jsp
      <%@ page language="java" contentType="text/html; charset=UTF-8"
          pageEncoding="UTF-8"%>
      <%
      	out.println("-----------내장 객체 이용-----------<br>");
      	out.println("기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.<br>");
      	out.println("그래서 자바 코드와 HTML 코드가 섞인 모습입니다.");
      	String name = request.getParameter("name");
      %>
      <p>넘어온 값: <%=name %></p>
      <hr/>	
      ${"-----------EL 이용-----------"}
      <br/>
      ${"하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다."}
      <br/>
      ${"넘어온 값: "}${param.name}
      ```

- **EL의 특징**

  - <u>Null에 관대하다</u>

    ```jsp
    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
    <%
    	out.println("-----------내장 객체 이용-----------<br>");
    	out.println("기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.<br>");
    	out.println("그래서 자바 코드와 HTML 코드가 섞인 모습입니다.");
    	String name = request.getParameter("name");
    	if(name == null){
    		name = "Null!";
    	}
    %>
    <p>넘어온 값: <%=name %></p>
    <hr/>	
    ${"-----------EL 이용-----------"}
    <br/>
    ${"하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다."}
    <br/>
    ${"넘어온 값: "}${param.name}
    <!--
     결과
     -----------내장 객체 이용-----------
    기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.
    그래서 자바 코드와 HTML 코드가 섞인 모습입니다.
    넘어온 값: Null!
    
    -----------EL 이용-----------
    하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다.
    넘어온 값:
    -->
    ```

  - <u>자동 형변환이 가능하다.</u>

    - 넘어온 값은 String이다.

      - 내장 객체를 이용할 경우 넘어온 값을 int로 형변환 해서 계산해야하지만

      - EL은 자동으로 형변환을 한다.

        ```jsp
        <%@ page language="java" contentType="text/html; charset=UTF-8"
            pageEncoding="UTF-8"%>
        <%
        	out.println("-----------내장 객체 이용-----------<br>");
        	out.println("기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.<br>");
        	out.println("그래서 자바 코드와 HTML 코드가 섞인 모습입니다.");
        	String name1 = request.getParameter("name1");
        	String name2 = request.getParameter("name2");
        	if(name1 == null){
        		name1 = "Null!";
        	}
        	if(name2 == null){
        		name2 = "Null!";
        	}
        	String result = name1 + name2;
        %>
        <p>넘어온 값: <%=result %></p>
        <hr/>	
        ${"-----------EL 이용-----------"}
        <br/>
        ${"하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다."}
        <br/>
        ${"넘어온 값: "}${param.name1 + param.name2}
        <!--결과: 넘어온 값은 1과3
        -----------내장 객체 이용-----------
        기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.
        그래서 자바 코드와 HTML 코드가 섞인 모습입니다.
        넘어온 값: 13
        
        -----------EL 이용-----------
        하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다.
        넘어온 값: 4
        -->
        ```

  - page Directory의 `isELIgnored="true"`속성으로 EL 사용여부를 적용할 수 있다. 

    ```jsp
    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8" isELIgnored="true"%>
    ```

  - **EL에서 메소드를 사용할 수 있다.**

    - **단 get메소드와 그 외의 메소드 사용법은 다르다.**

      - get메소드: get을 빼고 소문자로 시작

        - Cookie는 Cookie class getName()과 getValue()를 이용한다.

          - EL에서 Cookie는 내장 객체 이므로 바로 cookie.name()과 cookie.value()를 사용한다.

            ```jsp
            <%@ page language="java" contentType="text/html; charset=UTF-8"
                pageEncoding="UTF-8" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
            <%
            	out.println("-----------내장 객체 이용-----------<br>");
            	out.println("기존 JSP에서는 OUT 내장 객체를 이용하여 출력합니다.<br>");
            	out.println("그래서 자바 코드와 HTML 코드가 섞인 모습입니다.");
            	String name1 = request.getParameter("name1");
            	String name2 = request.getParameter("name2");
            	if(name1 == null){
            		name1 = "Null!";
            	}
            	if(name2 == null){
            		name2 = "Null!";
            	}
            	String result = name1 + name2;
            	out.println("<br>Cookie<br>");
            	Cookie[] ck = request.getCookies();
            	Cookie c = ck[1];
            	out.println(c.getName() + " : " + c.getValue());
            %>
            <p>넘어온 값: <%=result %></p>
            <hr/>	
            ${"-----------EL 이용-----------"}
            <br/>
            ${"하지만 EL에서는 자바코드 없이 편하게 받을 수 있습니다."}
            <br/>
            ${"넘어온 값: "}${param.name1 + param.name2}
            <p>Cookie</p><br/>
            <p>Cookie</p><br/>
            ${cookie.username.name}:${cookie.username.value}
            
            
            ```

      - 그 외의 메소드

        - `<%@taglib %>`를 사용: JSTL 문서를 참고

        - 정적 메소드를 이용

        - `scriptlet`을 사용

        - bean을 이용

          ```jsp
          <%@ page language="java" contentType="text/html; charset=UTF-8"
              pageEncoding="UTF-8" import="com.example.libs.model.UserInfo"%>
          <h1>Java Bean과 EL</h1>
          <!-- scope는 나두면 page: 즉 page scope -->
          <jsp:useBean id="user" class="com.example.libs.model.UserInfo"></jsp:useBean>
          <jsp:setProperty property="name" name="user" value="한지민" />
          <jsp:setProperty property="gender" name="user" value="female" />
          <!-- setAge할 때 자동 형변환 -->
          <jsp:setProperty property="age" name="user" value="24" />
          <jsp:setProperty property="address" name="user" value="서울시 강남구 역삼동" />
          <%
          	pageContext.setAttribute("USERINFO", user);
          	UserInfo jimin = (UserInfo)pageContext.getAttribute("USERINFO");
          %>
          <ul>
          	<!-- 기존의 방법 -->
          	<li>이름 : <%=jimin.getName()%></li>
          	<li>나이 : <jsp:getProperty property="name" name = "user" /></li>
          	<!-- EL의 방법 -->
          	<!-- EL에서 메소드 쓸꺼면 get을 빼고 그 다음을 소문자로 하면 됨 -->
          	<li>성별 : ${user.gender}</li>
          	<li>주소 : ${user.address}</li>
          </ul>
          ```

          

### 2.EL의 표현

------

- **EL은 `${expression}`를 이용해서 표현할 수 있다.**
- 이는`<%=expression %>`와 같다.
  - 만약 EL 표현식의 반환값이 속성을 가진 객체라면 두 방법을 통해 표현
    - **`${object["propertyName"]}`**
      - <u>속성에 영문자, 숫자, $, '-'가 아닌 다른 특수문자를 사용한다면 이 방법을 사용해야한다.</u>
    - **`${object.propertyName}`**
- **EL의 데이터 타입**
  - Boolean
  - Integer
  - Float
  - String 
  - Null


### 3. EL의 내장 객체

------

- EL에서도 JSP와 마찬가지로 내장 객체를 제공한다.

  ![el](https://user-images.githubusercontent.com/68282095/100518064-99504580-31d2-11eb-9c6e-b463da3d2dbb.jpg)

  

### 3. Scope

------

- JSP의 Scope와 일치한다.

  - pageScope
  - requestScope
  - sessionScope
  - applicationScope
  - scope의 자세한 내용은scope문서를 참고

- 예

  ```jsp
  ${"page:"}${pageScope.scope}<br/>
  ${"request:"}${requestScope.scope}<br/>
  ${"session:"}${sessionScope.scope}<br/>
  ${"application:"}${applicationScope.scope}<br/>
  ```

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <%
  	session.setAttribute("num1", new Integer(5));
  	session.setAttribute("num2", 6); //Auto Boxing: new Integer(6)
  %>
  <!-- 기존의 방법 -->
  <%-- num1 : <%=(Integer)session.getAttribute("num1")%> <br> --%>
  <!-- EL이용 -->
  num1 : ${sessionScope['num1']}
  num2 : ${sessionScope['num2']}
  <!-- \는 Escaping 문자: 문자로본다.--> 
  <h1>\${sessionScope.num1} + \${sessionScope.num2}의 5칙 연산</h1>
  ${sessionScope.num1 + sessionScope.num2} <br>
  ${sessionScope.num1 - sessionScope.num2} <br>
  ${sessionScope.num1 * sessionScope.num2} <br>
  ${sessionScope.num1 div sessionScope.num2} <br>
  ${sessionScope.num1 mod sessionScope.num2} <br>
  ${sessionScope.num1 eq sessionScope.num2} <br>
  ${sessionScope.num1 ne sessionScope.num2} <br>
  ${sessionScope.num1 lt sessionScope.num2}<br>
  ```

  

### 4. Param & ParamValues

------

- param

  - request 요청 파라미터를 참조하는 Map 객체

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <% request.setCharacterEncoding("utf-8");%>
  <h1>회원 정보</h1>
  <ul>
  	<li>이름 : ${param.name}</li>
  	<li>아이디 : ${param['id']}</li>
  	<li>패스워드 : ${param['password']}</li>
  	<li>성별 : ${param['gender']}</li>
  	<li>취미 : ${paramValues['hobby'][0]} ${paramValues['hobby'][1]} ${paramValues['hobby'][2]} 
  			  ${paramValues['hobby'][3]} ${paramValues['hobby'][4]} ${paramValues['hobby'][5]}</li>
  </ul>
  ```

- paramValues

  - param의 값이 여러개일 경우

  - 예

    - input.html

      ```html
       <form action="el_scriptlet.jsp" method="GET">
                      <fieldset class="form-group">
                          <legend>Form</legend>
      					<input type="text" name="name1" id="txtName" size="10"> &nbsp;&nbsp;&nbsp;
      					<input type="text" name="name2" id="txtName" size="10">
      					<input type="checkbox" name="hobby" value="축구">축구
      					<input type="checkbox" name="hobby" value="야구">야구
      					<input type="checkbox" name="hobby" value="농구">농구
      					<input type="checkbox" name="hobby" value="coding">coding
                          <button type="submit" id="btnSubmit" class="btn btn-success">전송하기</button>
                      </fieldset>
      		   </form>
      ```

    - paramValues.jsp

      - JSTL의 forEach를 사용하여 for문과 같이 받을 수 있다.

      ```jsp
      <%
      	//내장 객체 사용
      	String[] array = request.getParameterValues("hobby");
      	out.println("<br/>");
      	for(int i=0;i<array.length;i++){
      		
      		out.println(array[i]);
      	}	
      %>
      <h1>paramValue: EL 사용</h1>
      ${paramValues.hobby[0]}
      ${paramValues.hobby[1]}
      ${paramValues.hobby[2]}
      ${paramValues.hobby[3]}
      ```

      

### 4. Header & Header Values

------

- header

  - 헤더를 가져온다.
  - user-agent는 매우 중요한 헤더: 유저의 브라우저, OS를 읽어온다. 
- headerValue

  - 헤더의 값이 여러개일 경우

- Header와 HeaderValue의 예

```jsp
xxxxxxxxxx <%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8" import="java.util.Enumeration"%>
<%    Enumeration<String> list = request.getHeaderNames();%>
<h1>기존의 Header를 읽는 방법</h1><ul>    
   	<%while(list.hasMoreElements()){    
    	String name = list.nextElement();%>
    		<li><%=name%>   : <%=request.getHeader(name)%></li>
    <%}%>
</ul>
<!-- EL 이용: 코드는 간단해지만 복수로 들어오는 헤더 정보에는 약하다. -->
<hr>
<h1>EL을 이용하는 방법</h1>
<ul>    
    <li>Host : ${header['host']}</li>    
    <li>User-Agent : ${header['User-Agent']}</li>    
    <li>accept : ${headerValues['accept'][0]} ${headerValues['accept'][1]}</li>   
    <li>accept-language : ${headerValues['accept-language'][0]}</li>
</ul>
```

### 5. Cookie

------

- Cookie

  - 쿠키 객체
    - https://docs.oracle.com/javaee/7/api/javax/servlet/http/Cookie.html
  - 메소드는 get빼고 소문자로 시작하면됨
  - EL은 출력이기 때문에 Cookie를 세팅하기 위해서는 내장 객체를 사용해야 한다.

- 예1

  - input.html

    ```html
    <script>
    	document.cookie = "username=sis945;";
    </script>
    <!--이하 생략-->
    ```

  - cookie.jsp

    ```jsp
    <p>Cookie</p><br/>
    ${cookie.username.name}:${cookie.username.value}
    <!--이하생략-->
    ```

- 예2

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <%
  	Cookie c1 = new Cookie("username","한지민");
  	Cookie c2 = new Cookie("userage","24");
  	Cookie c3 = new Cookie("usergender","여성");
  	response.addCookie(c1);
  	response.addCookie(c2);
  	response.addCookie(c3);
  	response.sendRedirect("cookieget.jsp");
  %>
  ```

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <ul>
  	<li>이름 : ${cookie['username'].value}</li>
  	<li>나이 : ${cookie['userage'].value + 10}살</li>
  	<li>성별 : ${cookie['usergender'].value}</li>
  </ul> 
  ```

### 5. initParam

------

- initParam

  - application 객체의 initParam()
  - application의 initParam과 config의 initParam

- 예

  - web.xml의 `<context-param>`

    ```xml
    <context-param>
    		<description>Oracle 18g Expression Edition 설정 정보</description>
    		<param-name>oracle.properties</param-name>
    		<param-value>/WEB-INF/oracle.properties</param-value>
    </context-param>
    ```

  - initParam.jsp

    ```jsp
    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <%
    	String oracle = application.getInitParameter("oracle.properties");
    	String path = application.getRealPath(oracle);
    %>
    <ul>
    	<li>Parameter Name : <%=application.getInitParameter("oracle.properties") %></li>
    	<li>Parameter Value : ${initParam['oracle.properties']}</li>
    </ul>
    ```

### 6. pageContext

------

- pageContext

  - pageContext객체의 일을 한다.	

    - 내장 객체의 객체를 생성
    - 포워딩, 인클루딩
    - 커스텀 태그에서 사용

- 예

  ```html
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <!-- 기존의 방법 -->
  User Address : <%=request.getRemoteAddr()%> <br />
  <!-- EL을 이용 -->
  User Address : ${pageContext.request.remoteAddr} <br>
  Request URI : <%=request.getRequestURI()%> <br>
  Request URI : ${pageContext.request.requestURI}
  
  ```

### 7. EL에서 배열과 컬렉션 사용

------

- 컬렉션

  - list 계열: 인덱스로 접근
  - set 계열
    - get이 없으므로  EL에서 사용할 수 없다.
  - map 계열
    - key로 value를 가져온다.
  - 세팅은 EL에서는 하지 못한다.

- 예

  ```jsp
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8" import="java.util.ArrayList, java.util.Vector, java.util.HashMap"%>
  <h1>Collection & Array과 EL</h1>
  <%
  	//List 개열: Vector, ArrayList..의 경우 index를 사용
  	//세팅은 EL에서 못함
  	ArrayList<String> alist = new ArrayList<String>();
  	Vector<String> vec = new Vector<String>();
  	vec.addElement("사과");
  	vec.addElement("딸기");
  	vec.addElement("복숭아");
  	vec.addElement("수박");
  	alist.add("사과");
  	alist.add("딸기");
  	alist.add("복숭아");
  	alist.add("수박");
  	String[] array = {"사과", "딸기", "복숭아", "수박"};
  	pageContext.setAttribute("MYFRUITS", array); //돌려가면서 ㄱㄱ
  	//SET: EL에서 사용 불가(get이 없다)
  	//MAP: key value
  	HashMap<String, Object> map = new HashMap<String, Object>();
  	map.put("username","한지민");
  	map.put("userage",24);
  	map.put("useraddress","서울시 강남구 역삼동");
  	pageContext.setAttribute("YOURINFO", map);
  %>
  <ul>
  	<li>${MYFRUITS[0]}</li>
  	<li>${MYFRUITS[1]}</li>
  	<li>${MYFRUITS[2]}</li>
  	<li>${MYFRUITS[3]}</li>
  </ul>
  <hr>
  <ul>
  	<li>이름 : ${YOURINFO['username']}</li>
  	<li>나이 : ${YOURINFO['userage']}</li>
  	<li>주소 : ${YOURINFO['useraddress']}</li>
  </ul>
  ```

  