<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="user" value="${userInfo}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Welcome to www.example.com</title>
<link rel="stylesheet" href="/statics/css/bootstrap.css">
<link rel="stylesheet" href="/statics/css/bootstrap-theme.css">
<script src="/statics/js/jquery-3.5.1.js"></script>
<script src="https://cdn.ckeditor.com/4.15.1/standard/ckeditor.js"></script>
<style>
body {
	background: linear-gradient(#e66465, #9198e5);
	background-repeat: no-repeat;
	height:1500px;
}


.trueResult {
	color: lightgreen;
	font-weight: 900;
	font-size: 1.5em;
}

.falseResult {
	color: lightcoral;
	font-weight: 900;
	font-size: 1.5em;
}
</style>
</head>
<body>
	<!-- Header니까 body를 닫지 않는다: Footer가 닫는다. -->
	<div class="container">
		<div class="row">
			<nav id="navBar"class="navbar navbar-default bg-info">
				<div class="container-fluid">
					<!-- Brand and toggle get grouped for better mobile display -->
					<div class="navbar-header">
						<button type="button" class="navbar-toggle collapsed"
							data-toggle="collapse"
							data-target="#bs-example-navbar-collapse-1">
							<span class="sr-only">Toggle navigation</span> <span
								class="icon-bar"></span> <span class="icon-bar"></span> <span
								class="icon-bar"></span>
						</button>
						<a class="navbar-brand" href="/"> <img alt="Brand"
							src="/images/logo.jpg" style="height: 25px; width: 30px;"></a>
					</div>

					<!-- Collect the nav links, forms, and other content for toggling -->
					<div class="collapse navbar-collapse"
						id="bs-example-navbar-collapse-1">
						<ul class="nav navbar-nav">
							<li class="active">
							<a href="/bbs/list">게시판<span class="sr-only">(current)</span></a>
							</li>
							<li><a href="#">Link</a></li>
							<li class="dropdown"><a href="#" class="dropdown-toggle"
								data-toggle="dropdown" role="button" aria-expanded="false">Dropdown
									<span class="caret"></span>
							</a>
								<ul class="dropdown-menu" role="menu">
									<li><a href="#">Action</a></li>
									<li><a href="#">Another action</a></li>
									<li><a href="#">Something else here</a></li>
									<li class="divider"></li>
									<li><a href="#">Separated link</a></li>
									<li class="divider"></li>
									<li><a href="#">One more separated link</a></li>
								</ul></li>
						</ul>
						<form class="navbar-form navbar-left" role="search">
							<div class="form-group">
								<input type="text" class="form-control" placeholder="Search">
							</div>
							<button type="submit" class="btn btn-default">Submit</button>
						</form>
						<c:if test="${empty user}">
							<p class="navbar-text text-success" style="font-size:1.1em;">로그인을 해주세요</p>
						</c:if>
						<c:if test="${not empty user}">
							<p class="navbar-text text-success" style="font-size:1.3em;">${user.name}(${user.userid})</p>
						</c:if>
						<ul class="nav navbar-nav navbar-right">
							<li style="padding: 10px 0px;"><c:if
									test="${empty user.userid}">
									<%--login 안했을 때 --%>
									<button id="btnRegister" class="btn btn-success ">회원가입</button>
									<button id="btnLogin" class="btn btn-info ">Log In</button>
								</c:if> <c:if test="${not empty user.userid}">
									<%--login 했을 때 --%>
									<button id="btnLogout" class="btn btn-warning ">Log
										Out</button>
									<c:if test="${user.flag eq 1}">
										<%--일반 유저라면 --%>
										<button id="btnMyservice" class="btn btn-info ">My
											Service</button>
										<button id="btnDelete" class="btn btn-danger ">회원탈퇴</button>
									</c:if>
									<c:if test="${user.flag eq 0}">
										<%--관리자라면 --%>
										<button id="btnAdmin" class="btn btn-primary ">관리자
											페이지로</button>
									</c:if>
								</c:if></li>
						</ul>
					</div>
					<!-- /.navbar-collapse -->
				</div>
				<!-- /.container-fluid -->
			</nav>
		</div>
	</div>
	<script>
	<!-- script를 제일 마지막에 -->
		$(function() {
			$("#btnRegister").click(function() {
				location.href = "/membership/register";	// jsp에서 작성한 Header이므로 HTML에서 사용하기 위해 다음과 같이 Controller로 넘긴다.
			});
			$('#btnLogin').on('click', function() {
				location.href = "/membership/login";
			});
			$('#btnLogout').on('click', function() {
				if (confirm("정말 로그아웃하시겠습니까 ? ")) {
					location.replace("/membership/logout");
				} else {
					history.go(0);
				}
			});
			$('#btnAdmin').on('click', function() {
				location.replace("/membership/admin");
			});
			$('#btnDelete').on('click', function() {
				if (confirm("정말 탈퇴하시겠습니까 ? ")) {
					location.replace("/membership/delete");
				} else {
					history.go(0);
				}
			});
			$('#btnMyservice').on('click', function() {
				location.replace('/membership/userinfo');
			});
		});
	</script>