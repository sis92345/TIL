<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Welcome to www.example.com</title>
<link rel="stylesheet" href="/statics/css/bootstrap.css">
<script src="/statics/js/jquery-3.5.1.min.js"></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 현재 페이지 -->
<c:set var="currentPage" value="${currentPage}" />
<!-- 전체 페이지 -->
<c:set var="totalPage" value="${totalPage}" />
<!-- 시작 페이지 번호-->
<c:set var="startPage" value="${startPage}" />
<!-- 끝 페이지 번호 -->
<c:if test="${endPage > totalPage}">
		<c:set var="endPage" value="${totalPage}" />
</c:if>
<c:set var="endPage" value="${endPage}" />
<!-- 끝 페이지 번호 -->
<c:set var="bbsList" value="${bbsList}" />
</head>
<body>
	<!-- 게시판 -->
	<div class="container">
		<div class="row">
			<h1 class="text-center">게시판</h1>
			<table class="table table-borderless text-center"
				style="border: 0px solid white">
				<tr>
					<td class="text-left"><button type="button"
							class="btn btn-primary" id="btnWrite">글쓰기</button></td>
					<td class="text-right">(${currentPage}/${totalPage})</td>
				</tr>
			</table>
			<table class="table table-hover text-center">
				<thead>
					<tr class="success text-center">
						<th class="text-center" style="width: 5%;">글번호</th>
						<th class="text-center" style="width: 15%;">작성자</th>
						<th class="text-center" style="width: 50%;">글제목</th>
						<th class="text-center" style="width: 15%;">작성일</th>
						<th class="text-center" style="width: 5%;">조회수</th>
					</tr>
				</thead>
				<tbody>
					<!-- 글이 없다면 -->
					<c:if test="${qnaList.size() eq 0}">
						
						<tr>
							<td colspan="5" class="text-cencter danger">No Data</td>
						</tr>
					</c:if>
					<!-- 글이 있다면 -->
					<c:if test="${bbsList.size() > 0}">
						<c:forEach items="${bbsList}" var="row">
							<tr>
								<td class="text-center">${row.idx}</td>
								<td class="text-center">
									<c:if test="${empty row.email}">
										${row.writer}
									</c:if> 
									<c:if test="${not empty row.email}">
										<a href="mailto:${row.email}">${row.writer}</a>
									</c:if>
								</td>

								<td class="text-left">${row.title}</td>
								<td class="text-center">${row.writeday}</td>
								<td class="text-center">${row.readnum}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
			<hr>
			
			<!-- 페이징 처리 -->
			<div class="text-center">
				<c:if test="${currentPage ne 1}"> <!-- 현재 페이지가 1이 아니라면 이전 버튼은 이전 페이지로 -->
					<a href="/list?page=${currentPage - 1}" />[이전]&nbsp;&nbsp;&nbsp;</a>
				</c:if><!-- 현재 페이지가 1이라면 이전 버튼 누르면 1페이지로 -->
				<c:if test="${currentPage eq 1}">
					<a href="/list?page=1" />[이전]&nbsp;&nbsp;&nbsp;</a>
				</c:if>
			
				<c:forEach begin="${startPage}" end="${endPage}" var="i">
					<c:if test="${currentPage eq i}"> <!-- 현재 페이지 css 부여 -->
						<span style="color: red; font-size: 1.5em; font-weight: 900">${i}</span>&nbsp;&nbsp;&nbsp;
					</c:if>
					
					<c:if test="${currentPage ne i}"> <!-- 아니면 그냥 ㄱ -->
						<a href="/list?page=${i}">${i}</a>&nbsp;&nbsp;&nbsp;
					</c:if>
				</c:forEach>
				<c:if test="${currentPage ne totalPage}">
					<a href="/list?page=${currentPage + 1}" />[다음]&nbsp;&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentPage eq totalPage}">
					<a href="/list?page=${totalPage}" />[다음]&nbsp;&nbsp;&nbsp;</a>
				</c:if>
			</div>
		</div>
	</div>
	<script>
		$('#btnWrite').on('click', function() {
			location.href = "/qna/write";
		});
	</script>
</body>
