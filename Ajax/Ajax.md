JSP Overview
==========

> Ajax란
>
> Ajax와 비동기 방식

> Ajax의 기본 문법
>
> XMLHttpRequest
>
> AJAX AND DB
>

### 1. Ajax란

---------------

- **Ajax(Asynchronous JavaScript and XML)**
  - **Ajax**는 JavaScript를 이용한 **비동기 통신**이다.	
    - 즉 클라이언트와 서버가 비동기적으로 데이터를 교환하기위한 방법이다.
    - *Ajax는 하나의 기술이 아니라 기존의 기술을 묶어서 데이터를 교환하고 조작하는 기법이다*. 다음이 Ajax를 이루는 기술이다.
      1. **XMLHttpRequest**: 브라우저와 서버 간에 메소드가 데이터를 전송하는 객체 폼의 API
        - docs: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest
      2. **JavaScript**: 사용자 조작에 대한 이벤트와 요청을 담당
      3. **DOM**
      4. **CSS**
  - Ajax는 JavaScript의 라이브러리 중 하나이다. **Ajax로** 데이터를 로드할 때 페이지 전체를 새로 고침하는 것이 아니라 **페이지의 일부만을 새로 고침할 수 있다.** 
- Ajax를 사용하는 이유
  - HTTP 프로토콜은 stateless이다. 즉 브라우저에서 Request를 보내고 Server에서 Response를 보내면 연결이 끊기게 되어있다.
  - 따라서 HTTP에서 화면의 데이터를 갱신하기 위해서 반드시 다시 Request를 보내고 Response를 받는 과정을 해야한다.
  - <u>즉 기존의 Http는 화면의 내용을 갱신하기 위해서 페이지 전체를 다시 로드해야한다.</u>
  - 하지만 Ajax는 XMLHttpRequest를 이용해서 페이지의 일부분만 갱신하도록 Reqeust한다.
  - <u>그리고 xml이나 Json, 심지어 텍스트 파일 형태의 데이터로 Response하고 이를 이용해서 페이지의 일부분만 갱신하도록한다.</u> 
  - 따라서 Ajax는 기존의 방법에 비해 속도가 빠르며 자원의 낭비를 막을 수 있다.
  - 예를 들어 다음과 같이 기존의 방식을 이용해서 jsp에서 로직을 처리하고 결과값을 받는다고 생각하자


### 2. Ajax의 기본 문법

------

- Ajax 살펴보기

  - Jquery를 이용해서 보다 더 편하게 Ajax를 구현할 수 있지만 이 방법은 본래 방법을 설명한다.

    ```html
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script>
    	var xhr = null;
    	$('document').ready(function(){
    		//1. 객체 생성
    		xhr = new XMLHttpRequest();
    		$('#btnDeptno').on('click', function(){
    			//4이벤트 처리
    			xhr.onreadystatechange = envChange;
    			deptno = $('#setDeptno').val();
                //2OPEN
    			xhr.open('GET','test.jsp?deptno=' + deptno,true);
    			//3SEND
    			xhr.send(null);
    		});
    	});
    	function envChange(){
            //이벤트가 발생하면 처리
    		if(xhr.readyState == 4 && xhr.status == 200){
    			$('#result').html(xhr.responseText.trim());
    		}
    	}
    </script>
    </head>
    <body>
    	<div>
    		부서번호:<input type="text" id="setDeptno">
    		<input type="button" value="부서 인원 찾기" id="btnDeptno">
    		<span id='result'></span>
    	</div>
    </body>
    </html>
    ```

    - 이 코드는 `test.jsp`로 파라미터를 넘겨서 test.jsp에서 처리한 테이블을 ``<div>`태그 안에 넣는 Ajax 코드이다

- **Ajax 구현: XMLHttpRequest**

  1. **객체 생성**

     - `XMLHttpRequest` 객체를 생성한다.

  2. **OPEN**

     - `XMLHttpRequest open()`을 이용하여 HTTP 요구 방식과 URL과 비동기 수행 여부를 결정한다

  3. **SEND**

     - 만약 POST방식을 경우 `send()`를 이용해서 데이터를 보낼 수 있다. 자세한 차이점은 아래 POST와 GET 방식의 차이를 참고

  4. 예

     ```javascript
     <script>
     	var xhr = null;
     	$('document').ready(function(){
     		//1. 객체 생성
     		xhr = new XMLHttpRequest();
     		$('#btnDeptno').on('click', function(){
     			//4 이벤트 처리: 요청 상태 변화 이벤트가 발생하면 envChange()함수 실행
     			xhr.onreadystatechange = envChange;
     			deptno = $('#setDeptno').val();
                 //2 OPEN: GET방식, test.jsp로 요청
     			xhr.open('GET','test.jsp?deptno=' + deptno,true);
     			//3 SEND: GET 방식이므로 따로 send()를 이용하지않는다. null처리
     			xhr.send(null);
     		});
     	});
     </script>
     ```

- **GET과 POST**

  - GET과 POST중 어떤 방식을 사용하나에 따라서 기본적인 Ajax 구현 방법이 약간 다르다.

  - **GET**

    - <u>보낼 데이터(파라메터)를 open()함수의 url의 쿼리스트링에 작성한다</u>

      ```java
      deptno = $('#setDeptno').val(); //setDeptno 아이디를 가진 곳의 데이터를 deptno 변수에 저장
      xhr.open('GET','test.jsp?deptno=' + deptno,true);//GET 방식이므로 변수 deptno를 URL뒤 쿼리스트링에 이어붙인다.
      ```

  - **POST**

    - `setRequestHeader()`를 이용해서 MIME Type을 먼저 설정해야한다.

      ```javascript
      <script>
      	var xhr = null;
      	$('document').ready(function(){
      		//1. 객체 생성
      		xhr = new XMLHttpRequest();
      		$('#btnDeptno').on('click', function(){
      			//4 이벤트 처리: 요청 상태 변화 이벤트가 발생하면 envChange()함수 실행
      			xhr.onreadystatechange = envChange;
      			deptno = $('#setDeptno').val();
                  //2 OPEN: GET방식, test.jsp로 요청
      			xhr.open('GET','test.jsp?deptno=' + deptno,true);
                  //MIME Type을 설정
                  xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
      			//3 SEND: GET 방식이므로 따로 send()를 이용하지않는다. null처리
      			xhr.send(null);
      		});
      	});
      </script>
      ```

      - 추가 정보: MIME TYPE
        - 클라이언트에게 전송된 문서의 다양성을 알려주기 위한 메커니즘
          - MIME로 인코딩 한 파일은 Content-Type 정보를 파일 앞 부분에 담게 된다.
        - docs:https://developer.mozilla.org/ko/docs/Web/HTTP/Basics_of_HTTP/MIME_types
        - application/x-www-form-urlencoded: HTML Form 형태
        - charset=utf-8: 한글 처리용

  - JSON으로 보낼 경우

    - stringify(): Object를 String

    - parse(): String을 JSon

      ```javascript
      xhr = new XMLHttpRequest();
      xhr.onload = mycallback;
      var data = { //JSON 
      "username" : document.getElementById("username").value,
      "userage" : document.getElementById("userage").value,
      "userphone" : document.getElementById("userphone").value
      };
      xhr.open("POST", "getData.jsp");
      //반드시 POST 방식에서는 setRequestHeader()를 설정해야 한다.
      xhr.setRequestHeader("Content-Type", "application/json");
      //POST 방식에서는 반드시 send(data)를 넣을 것.
      xhr.send(JSON.stringify(data)); //stringify
      ```

  - FormDate 전달

    ```javascript
    var formData = new FormData();
    formData.append('username', '한지민');
    formData.append('userage', '24');
    formData.append('userphone', '010-1234-5678');
    ```

    

  

### 3. XMLHttpRequest

------

- **주요 Property**

  - **`XMLHttpRequest.readyState`**: Request의 상태를 unsigned short로 반환
    - 0
      - UNINITIALIZED  
      - 객체만 생성되고 아직 초기화되지 않는 상태(open () 가 호출되지 않음)  
    - 1
      - LOADING  
      - open() 호출되고 아직 send() 호출 전  
    - 2
      - LOADED
      - send() 호출 후, Server로부터 status 와 Header가 도착하지 않은 상태  
    - 3
      - INTERACTIVE  
      - Data의 일부를 받은 상태  
    - 4
      - COMPLETED  
      - Data의 전부를 받은 상태  
  - **`XMLHttpRequest.status`**
    - 서버 응답 상태
    - 주요 HTTP 상태 코드
      - 200
        - OK
        - 요청 성공
      - 403
        - Forbidden
        - 접근 거부
      - 404
        - Not Found
        - Page Not Found
      - 500
        - Internal Server Error
        - Server 오류
  - **`XMLHttpRequest.requestText`**
    - Server의 Response가 Text일 경우 해당 데이터를 반환
  - **`XMLHttpRequest.requestXML`**
    - Server의 Response가 XML일 경우 해당 데이터를 반환
  - `XMLHttpRequest.onreadyChange`
    - `readState` 속성이 변경될 때 호출되는 Event Handler

- 주요 메소드

  - `XMLHttpRequest.open(method, url[,async, user, password])`
    - Parameters
      - method: HTTP 방식
        - GET, POST, PUT, DELETE
      - url: 요청할 URL
      - async: 비동기 여부
        - true: 비동기 방식, 기본값
        - false: 동기방식
  - `XMLHttpRequest.send(body)`
    - Parameter
      - body: Request Packet의 body에 보낼 데이터
        - POST 방식일 경우 사용
        - GET같이 딱히 사용하지 않을 경우 null
    - 

  

### 4. jQuery를 이용한 Ajax 

------

- 

