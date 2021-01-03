<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login Result Window</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <!-- -1: 로그인 실패 -->
  <c:if test="${result eq -1}">
  <script>
  $( function() {
	$( "#dialog-message0" ).hide(); //해당 메시지를 숨긴다.
    $( "#dialog-message-1" ).dialog({
      modal: true,
      buttons: {
        Ok: function() {
          $( this ).dialog( "close" );
          history.back();
        }
      }
    });
  } );
  </script>
  </c:if>
  <!-- 0: 비밀번호 틀리면 -->
  <c:if test="${result eq 0}">
  <script>
  $( function() {
	$( "#dialog-message-1" ).hide();
    $( "#dialog-message0" ).dialog({
      modal: true,
      buttons: {
        Ok: function() {
          $( this ).dialog( "close" );
          history.back();
        }
      }
    });
  } );
  </script>
  <!--  -->
  </c:if>
  <c:if test="${result eq 1}"><!-- 로그인 성공 -->
	<c:set var="userid" value="${userid}" scope="session" />
	<c:set var="userInfo" value="${userInfo}" scope="session" /> <!-- 한 유저 전체의 정보를 세션에 넣는다.-->
	<c:redirect url="/"/>
	<%-- <%
		session.setAttribute("userid", request.getAttribute("userid")); //JAVA이므로 이렇게
		System.out.println("asdasdasd" + session.getAttribute("userid"));
	%> --%>
  </c:if>
</head>
<body>

<div id="dialog-message-1" title="Error">
  <p>
    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    존재하지 않는 아이디 입니다. 
  </p>
  <p>
    확인 후 다시 입력해 주세요.
  </p>
</div>

<div id="dialog-message0" title="Error">
  <p>
    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    비밀번호가 일치하지 않습니다.
  </p>
  <p>
    확인 후 다시 입력해 주세요.
  </p>
</div>