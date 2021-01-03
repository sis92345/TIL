<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="bbs" value="${bbsInfo}" />
<c:set var="user" value="${userInfo}" />
<c:set var="session_user_id" value="${userInfo.userid}" />
<c:import url="../common/header.jsp" />
<div class="container">
	<div class="row">
		<h1 style="text-align: center">게시글 읽기</h1>
		<table width="600" style="margin: auto" cellspacing="0"
			cellpadding="2">
			<tr>
				<td height="22">&nbsp;</td>
			</tr>
			<tr>
				<td height="1" bgcolor="#1F4F8F"></td>
			</tr>
			<tr bgcolor="#DFEDFF">
				<td bgcolor="#DFEDFF">
					<div>
						<strong id="title">${bbs.title}</strong>
					</div>
				</td>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td bgcolor="#F4F4F4">
					<table width="100%" border="0" cellpadding="0" cellspacing="4"
						height="1">
						<tr bgcolor="#F4F4F4">
							<td width="13%" height="7"></td>
							<td width="51%" height="7">글쓴이 : <span id="username">${bbs.writer}</span>
								(<span id="email">${bbs.email}</span>)
							</td>

							<td width="25%" height="7">글번호 : </td>
							<td width="11%" height="7">${bbs.bno}</td>
						</tr>
						<tr bgcolor="#F4F4F4">
							<td width="13%"></td>
							<td width="51%">작성일 : <span id='writeday'>${bbs.regdate}</span></td>
							<td width="25%">조회수 : <span id='readnum'>${bbs.readnum}</span></td>
							<td width="11%"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr align="center">
				<td bgcolor="#1F4F8F" height="1"></td>
			</tr>
			<tr>
				<td style="padding: 20 0 20 0"><br /> <span
					style="color: #333333" id='contents'></span>
					${bbs.content}	
				</td>
			</tr>
			<tr align="center">
				<td class="button" height="1"></td>
			</tr>
			<tr align="center">
				<td bgcolor="#1F4F8F" height="1"></td>
			</tr>
		</table>
		<table width="600" style="margin:auto" border="0" cellpadding="0" cellspacing="5">
        <tr> 
        	<td align="right" width="450"><a href="/bbs/list"><img src="/images/list.jpg"></a></td>
        	<c:if test="${bbs.userid eq session_user_id}"> <!-- 해당 글의 유저와 로그인한 유저가 같다면 -->
        		<td width="70" align="right"><a href="/bbs/update?bno=${bbs.bno}"><img src="/images/edit.jpg" id="updateBtn"></a></td>
            	<td width="70" align="right"><a href="/bbs/delete?bno=${bbs.bno}"><img src="/images/del.jpg" id="delBtn"></a></td>
        	</c:if>
        	<c:if test="${bbs.userid ne session_user_id}">
        		<td width="70" align="right"><a href="#"><img src="/images/edit.jpg" id="updateBtn"></a></td>
            	<td width="70" align="right"><a href="#"><img src="/images/del.jpg" id="delBtn"></a></td>
        	</c:if>
            
            
        </tr>
    </table>
	</div>
</div>
<script>
	$('#delBtn').on('click',function(){
		if(comfirm("정말 삭제하겠습니까?")){
			location.href="/bbs/update?" + ${bbs.bno};
		}else{
		
		}
	});
</script>
<c:import url="../common/footer.jsp" />