<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="user" value="${userInfo}" scope="session"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보보기 페이지</title>
<link rel="stylesheet" href="/static/css/bootstrap.css" />
<link rel="stylesheet" href="/static/css/bootstrap-theme.css" />
<style>
	.row{
		padding:10px 300px;
	}
</style>
<script src="/static/js/jquery-3.5.1.js"></script>
<script>
	$(function(){
		$('#btnHome').click(function(){
			location.replace('/');  //Home으로..
		});
		$('#btnUpdate').click(function(){
			if($(this).text() == '정보변경하기'){
				let age = $('#age').text();
				$('#age').replaceWith("<input id='txtAge' type='number' min='10' max='99' value='" + age + "' />");
				
				$('#btnUpdate').text('변경완료하기');
				$('#btnUpdate').removeClass();
				$('#btnUpdate').addClass("btn btn-danger");
			}else if($(this).text() == '변경완료하기'){
				let age = $('#txtAge').val();
				location.href = '/membership/update/' + age;   //  /update/24
			}
		});
		$('#btnDelete').click(function(){
			if(confirm("정말 탈퇴하시겠습니까 ? ")){
				location.replace("/membership/delete");
			}else{
				history.go(0);
			}
		});
	});
</script>
</head>
<body>
	<h1 class="text-success text-center"><c:out value="${user.name}"/>님의 정보</h1>
	<div class="container">
		<div class="row">
			<table class="table table-bordered">
				<tr>
					<th class="info" width="40%">아이디</th><td>${user.userid}</td>
				</tr>
				<tr>
					<th class="info">성별</th>
					<td>
						<c:if test="${user.gender eq '1'}">남성</c:if>
						<c:if test="${user.gender eq '2'}">여성</c:if>
					</td>
				</tr>
				<tr>
					<th class="info">나이</th>
					<td><span id="age">${user.age}</span></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="container">
		<div class="row">
			<div class="text-center">
				<button type="button" id="btnHome" class="btn btn-success">홈으로</button>
				<button type="button" id="btnUpdate" class="btn btn-info">정보변경하기</button>
				<button type="button" id="btnDelete" class="btn btn-warning">탈퇴하기</button>
			</div>
		</div>
	</div>
</body>
</html>






