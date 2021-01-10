<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <c:if test="${result eq -1}">
	  <script>
	  $( function() {
		  $( "#dialog-message0" ).hide();
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
  </c:if>
</head>
<body>
 
<div id="dialog-message-1" title="ERROR">
  <p>
    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    존재하지 않는 아이디 입니다.
  </p>
  <p>
    확인 후 다시 입력해 주세요.
  </p>
</div>
<div id="dialog-message0" title="ERROR">
  <p>
    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    비밀번호가 일치하지 않습니다.
  </p>
  <p>
    확인 후 다시 입력해 주세요.
  </p>
</div>

<c:if test="${result eq 1}">
	login 성공시 session에 userid를 넣는다.
	<c:set var="userInfo" value="${userInfo}" scope="session"/>
	<c:redirect url="/" />
</c:if>