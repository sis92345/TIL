<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="static/css/bootstrap.css">
<link rel="stylesheet" href="static/css/bootstrap-theme.css">
<script src="static/js/jquery-3.5.1.js"></script>
</head>
<body>
	<h1 class="text-center">회원명단</h1>
	<br />
	<div class="container">
		<div class="row">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>일련번호</th><th>아이디</th><th>패스워드</th>
						<th>회원이름</th><th>나이</th><th>성별</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="sn" value="0" />
					<c:forEach items="${userlist}" var="user">
						<tr>
							<td><c:out value="${sn = sn + 1}" /></td><td>${user.userid}</td>
							<td>${user.passwd}</td><td>${user.name}</td>
							<td>${user.age}</td>
							<td>
								<c:if test="${user.gender eq '1'}">
								남성
								</c:if>
								<c:if test="${user.gender eq '2'}">
								여성
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>