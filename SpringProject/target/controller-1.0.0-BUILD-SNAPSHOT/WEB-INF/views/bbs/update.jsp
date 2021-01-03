<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="../common/header.jsp"/>
<c:set var="bbs" value="${bbsInfo}" />
  <h1 class="text-center">게시판 글수정</h1>
  
  <div class="container">
    <div class="row">
      <form class="form-horizontal" action="/bbs/update" method="POST">
      	<input type="text" name="bno" hidden="hidden" id="txtTitle" value="${bbs.bno}"><!-- 여기가 문제였음, bno를 안받았거든, 어쨋든 이 부분은 강사님 꺼 확인 -->
        <div class="form-group">
          <label for="txtTitle" class="col-sm-2 control-label">글제목</label>
          <div class="col-sm-8">
            <input type="text" class="form-control" name="title" id="txtTitle" placeholder="글 제목을 입력합니다." required value="${bbs.title}">
          </div>
        </div>
        <div class="form-group">
          <label for="txtEmail" class="col-sm-2 control-label">이메일</label>
          <c:if test="${not empty bbs.email}">
          	<c:set var="emailArray" value="${fn:split(bbs.email, '@')}"/>
			
          </c:if>        
	          <div class="col-sm-2">
	            <input type="text" name="email" class="form-control" id="txtEmail" placeholder="이메일을 입력합니다." value="${emailArray[0]}">
	          </div>
	          <div class="input-group col-sm-3">
			        <span class="input-group-addon">@</span>
			        <select class="form-control" name="company" id="company">
					  <c:choose>
	        			<c:when test="${fn:trim(emailArray[1]) eq 'naver.com'}">
	        				<option value="naver.com" selected>네이버</option>
	        				<option value="hanmail.net">한메일</option>
	        				<option value="google.com">구글</option>
	        				<option value="nate.com">네이트</option>
	        				<option>직접입력</option>
	        			</c:when>
	        			<c:when test="${fn:trim(emailArray[1]) eq 'hanmail.net'}">
	        			    <option value="naver.com">네이버</option>
	        				<option value="hanmail.net" selected>한메일</option>
	        				<option value="google.com">구글</option>
	        				<option value="nate.com">네이트</option>
	        				<option>직접입력</option>
	        			</c:when>
	        			<c:when test="${fn:trim(emailArray[1]) eq 'google.com'}">
	        			    <option value="naver.com">네이버</option>
	        			    <option value="hanmail.net">한메일</option>
	        				<option value="google.com" selected>구글</option>
	        				<option value="nate.com">네이트</option>
	        				<option>직접입력</option>
	        			</c:when>
	        			<c:when test="${fn:trim(emailArray[1]) eq 'nate.com'}">
	        				<option value="naver.com">네이버</option>
	        			    <option value="hanmail.net">한메일</option>
	        			    <option value="google.com">구글</option>
	        				<option value="nate.com" selected>네이트</option>
	        				<option>직접입력</option>
	        			</c:when>
	        			<c:otherwise>
	        				<option value="naver.com">네이버</option>
	        			    <option value="hanmail.net">한메일</option>
	        			    <option value="google.com">구글</option>
	        				<option value="nate.com">네이트</option>
	        				<option selected>${emailArray[1]}</option>
	        			</c:otherwise>
	        		</c:choose>
					</select>
	      		</div>
      		
        </div>
        <div class="form-group">
          <label for="txtName" class="col-sm-2 control-label">글 내용</label>
          <div class="col-sm-8">
            <textarea class="form-control" name="content" rows="10" required="required">${bbs.content}</textarea>
          </div>
        </div>
        <div class="form-group">
          <div class="col-sm-offset-2 col-sm-8">
            <button type="submit" class="btn btn-success" id='btnSubmit'>수정</button>
            <button type="reset" class="btn btn-warning">취소</button>
            <button type="reset" id="btnUpdateBack"class="btn btn-info">돌아가기</button>
          </div>
        </div>
      </form>
    </div>
  </div>
  <script>
      CKEDITOR.replace('content');
  </script>
  <script>
	$('#company').on('change',function(){
		let com = document.getElementById("company");
		if(com.selectedIndex == 5){
			$(this).replaceWith("<input type=\"text\" name=\"email\" class=\"form-control\" id=\"txtEmail\" placeholder=\"이메일을 입력합니다.\">");
		}
		//alert(com.selectedindex);
	});

	$('#btnUpdateBack').on('click',function(){
		history.back();
	});
  </script>
<c:import url="../common/footer.jsp"/>