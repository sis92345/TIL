<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지</title>
<link rel="stylesheet" href="statics/css/bootstrap.css">
<link rel="stylesheet" href="statics/css/bootstrap-theme.css">
<link rel="stylesheet" href="statics/css/style.css">
</head>
<body>
	<h1 class="text-center">회원명단</h1>
	<div class="container">
		<div class="row">
			<table class="table table-hover table-dark">
			<thead>
				<tr>
					<th>일련번호</th>
					<th>아이디</th>
					<th>비밀번호</th>
					<th>회원이름</th>
					<th>회원나이</th>
					<th>회원성별</th>
				</tr>
				<tbody>
					<c:set var="sn" value="0"/>
					<c:forEach items="${userList}" var="list">
						<tr>
							<td><c:out value="${sn = sn + 1}"/></td>
							<td>${list.userid}</td>
							<td>${list.passwd}</td>
							<td>${list.name}</td>
							<td>${list.age}</td>
							<td>
							<c:if test="${list.gender eq '1'}">
								<c:out value="남성"/>
							</c:if>
							<c:if test="${list.gender eq '2'}">
								<c:out value="여성"/>
							</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</thead>
			</table>
		</div>
	</div>
	
</body>
</html>