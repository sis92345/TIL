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

  

### 3. response

------



### 4. out


