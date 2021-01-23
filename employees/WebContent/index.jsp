<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	  <div class="container-fluid">
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <div class="collapse navbar-collapse" id="navbarNav">
	      <ul class="navbar-nav">
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./index.jsp">Home</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./departmentList.jsp">departments</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./deptEmpList.jsp">dept_emp</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./deptManagerList.jsp">dept_manager</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./employeesList.jsp">employees</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./salariesList.jsp">salaries</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="./titlesList.jsp">titles</a>
	        </li>  
	      </ul>
	    </div>
	  </div>
	</nav>
	<!-- 홈페이지(메인) 내용 -->
	<br>
	<div>
		<h1>EMPLOYEES 미니프로젝트</h1>
		<br>
		<img src = "./image/index.JPG">
		<p>employees 데이터베이스를 사용해 데이터들을 보여주며</p>
		<p>네비바, 체크박스와 텍스트박스를 통한 검색기능, 페이징 기능을 구현</p>
		<p>부트스트랩으로 간단한 디자인을 해놓은 미니프로젝트 입니다.</p>
	</div> 
</div>
</body>
</html>