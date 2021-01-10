<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="../common/header.jsp"/>
<!-- 게시판 -->
<div class="container">
	<div class="row">
		<h1 class="text-center">회원 게시판</h1>
		<table class="table table-borderless text-center" style="border:0px solid white">
			<tr>
				<td class="text-left"><button type="button" class="btn btn-primary" id="btnWrite">글쓰기</button></td>
				<td class="text-right">(${bbsList.size()})</td>
			</tr>
		</table>
		<table class="table table-hover text-center">
			<thead>
				<tr class="success text-center">
					<th class="text-center" style="width:5%;">글번호</th>
					<th class="text-center" style="width:15%;">작성자</th>
					<th class="text-center" style="width:50%;">글제목</th>
					<th class="text-center" style="width:15%;">작성일</th>
					<th class="text-center" style="width:5%;">조회수</th>
					<th class="text-center" style="width:10%;">아이디</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${bbsList.size() eq 0}">
					<!-- 글이 없다면 -->
					<tr>
						<td colspan="6" class="text-cencter danger">No Data</td>
					</tr>
				</c:if>
				<c:if test="${bbsList.size() > 0}">
					<!-- 글이 있다면 -->
					<c:forEach items="${bbsList}" var="bbs">
						<tr>
							<td class="text-center">${bbs.bno}</td>
							<td class="text-center">
								<c:if test="${empty bbs.email}">
									${bbs.writer}
								</c:if>
								<c:if test="${not empty bbs.email}">
									<a href="mailto:${bbs.email}">${bbs.writer}</a>
								</c:if>
							</td>
							
							<td class="text-center"><a href="/bbs/read?bno=${bbs.bno}">${bbs.title}</a></td>
							<td class="text-center">${bbs.regdate}</td>
							<td class="text-center">${bbs.readnum}</td>
							<td class="text-center">${bbs.userid}</td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
	</div>
</div>
<script>
	$('#btnWrite').on('click',function(){
		location.href = "/bbs/write";
	});
</script>

<c:import url="../common/footer.jsp"/>
