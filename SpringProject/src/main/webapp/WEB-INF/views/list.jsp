<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Welcome to www.example.com</title>
<link rel="stylesheet" href="/statics/css/bootstrap.css">
<link rel="stylesheet" href="/statics/css/bootstrap-theme.css">
<script src="/statics/js/jquery-3.5.1.js"></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="currentPage" value="${currentPage}" />
<!-- 현재 페이지 -->
<c:set var="totalPage" value="${totalPage}" />
<!-- 전체 페이지 -->
<c:set var="pageSize" value="${pageSize}" />
<!-- 페이지 사이즈 -->
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
						<th class="text-center" style="width: 5%;">글그룹</th>
						<th class="text-center" style="width: 15%;">작성자</th>
						<th class="text-center" style="width: 50%;">글제목</th>
						<th class="text-center" style="width: 15%;">작성일</th>
						<th class="text-center" style="width: 5%;">조회수</th>
						<th class="text-center" style="width: 10%;">레벨</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${qnaList.size() eq 0}">
						<!-- 글이 없다면 -->
						<tr>
							<td colspan="6" class="text-cencter danger">No Data</td>
						</tr>
					</c:if>
					<c:if test="${qnaList.size() > 0}">
						<!-- pageSize 5 기준 1페이지는 0 ~ 4, 그 다음 페이지는 5 ~ 9 -->
						<c:set var="begin" value="${(currentPage - 1) * pageSize}" />
						<!-- 페이지시작값 공식-->
						<c:set var="end" value="${begin + pageSize - 1}" />
						<!-- 페이지끝값 공식-->
						<c:forEach items="${qnaList}" var="row" begin="${begin}"
							end="${end}">
							<tr>
								<td class="text-center"><c:if test="${row.lvl <= 0}">
									${qna.grp}
								</c:if> <c:if test="${row.lvl ne 0}">
										<c:out value="답글" />
									</c:if></td>
								<td class="text-center"><c:if test="${empty row.email}">
									${row.writer}
								</c:if> <c:if test="${not empty row.email}">
										<a href="mailto:${row.email}">${row.writer}</a>
									</c:if></td>

								<td class="text-left"><c:forEach begin="1"
										end="${row.lvl *3}" var="i">
									&nbsp;
								</c:forEach> <c:if test="${row.lvl >= 1}">
										<img src="/images/reply.jpg" />
									</c:if> <a href="/qna/read?bno=${row.bno}">${row.title}</a></td>
								<!-- 이거는 이해 -->
								<td class="text-center">${row.regdate}</td>
								<td class="text-center">${row.readnum}</td>
								<td class="text-center">${row.step}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
			<hr>
			<div class="text-center">
				<c:if test="${currentPage ne 1}">
					<a href="/?page=${currentPage - 1}" />[이전]&nbsp;&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentPage eq 1}">
					<a href="/?page=1" />[이전]&nbsp;&nbsp;&nbsp;</a>
				</c:if>

				<c:forEach begin="1" end="${totalPage}" var="i">
					<c:if test="${currentPage eq i}">
						<span style="color: red; font-size: 1.5em; font-weight: 900">${i}</span>&nbsp;&nbsp;&nbsp;
				</c:if>
					<c:if test="${currentPage ne i}">
						<a href="/?page=${i}">${i}</a>&nbsp;&nbsp;&nbsp;
				</c:if>
				</c:forEach>
				<c:if test="${currentPage ne totalPage}">
					<a href="/?page=${currentPage + 1}" />[다음]&nbsp;&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentPage eq totalPage}">
					<a href="/?page=${totalPage}" />[다음]&nbsp;&nbsp;&nbsp;</a>
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
</html>