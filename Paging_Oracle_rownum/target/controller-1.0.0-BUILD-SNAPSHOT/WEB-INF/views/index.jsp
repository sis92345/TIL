<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="common/header.jsp"/>

  <div class="container">
    <div class="row">
      <div class="jumbotron">
      	<c:if test="${empty user.userid}">
        	<h1>Welcome to www.example.com</h1>
        </c:if>
        <c:if test="${not empty user.userid}"><%-- login 했다면 --%>
        	<c:if test="${user.flag eq 1}">
        		<h2 class="text-success">${user.name}(${user.age}세, ${user.userid})님! 환영합니다.</h2>
        	</c:if>
        	<c:if test="${user.flag eq 0}">  <%--관리자라면 --%>
        		<h2 class="text-danger">Welcome 관리자</h2>
        	</c:if>
        </c:if>
        <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolorum, vel ut. Fuga nemo dolores, voluptatibus et aliquam mollitia reiciendis quo qui vitae eum obcaecati! Mollitia dignissimos incidunt ipsum quis adipisci.
        Sit nesciunt modi maxime eius quisquam numquam voluptas odit similique sunt voluptatibus, autem magni quis ea vero quo alias debitis adipisci perspiciatis doloremque corrupti fuga animi unde quidem. Error, omnis.
        Fuga adipisci tempora eligendi amet ullam rem ut eveniet est! Quod voluptate laudantium fugit! Cum deserunt minima modi ab quia deleniti eaque ratione, magnam soluta totam ad tempora qui praesentium!
        Provident accusamus sapiente, doloribus quibusdam enim consequatur eum eius vel temporibus officiis natus nostrum excepturi qui illum facilis, voluptatibus nobis corporis perspiciatis fugit accusantium nisi! Cumque quidem enim iusto. Saepe?
        Doloribus ut beatae cupiditate expedita quam porro earum praesentium, tempore tempora eaque eligendi, delectus reprehenderit sed culpa. Quis deleniti veritatis consectetur distinctio quidem placeat quisquam. Libero qui nemo animi impedit.</p>
      </div>
    </div>
  </div>
<c:import url="common/footer.jsp"/>