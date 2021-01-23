<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentList</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<div class="container">
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	  <div class="container-fluid"></a>
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
	<br>
	<h1>departmentList</h1>
	<!-- departmentList 테이블 목록 -->
	<%
		String searchDeptName = "";
		if(request.getParameter("searchDeptName")!=null){
			searchDeptName = request.getParameter("searchDeptName");
		}
		System.out.println(searchDeptName);
		int currentPage = 1;
		if(request.getParameter("currentPage")!=null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		int rowPerPage = 10;
		//1 mariadb(sw)를 사용할 수 있게
		Class.forName("org.mariadb.jdbc.Driver");
		//2. mariadb 접속(주소+포트번호+db이름, db계정, db계정암호)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3307/employees", "root","java1004");
		//System.out.println(conn+"<-conn");
		
		//동적쿼리
		String sql = "";
		PreparedStatement stmt = null;
		String sql2 = "";
		PreparedStatement stmt2 = null;
		if(searchDeptName.equals("")){
			sql = "select dept_no, dept_name from departments order by dept_no limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) as cnt from departments";
			stmt2 = conn.prepareStatement(sql2);
		}else{
			sql = "select dept_no, dept_name from departments where dept_name like ? order by dept_no limit ?,? ";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchDeptName+"%");
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) as cnt from departments where dept_name like ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%"+searchDeptName+"%");
		}
		//4. 쿼리(실행)에 결과물을 가지고 온다 
		ResultSet rs = stmt.executeQuery();
		//System.out.println(rs+"<-rs");
		ResultSet rs2 = stmt2.executeQuery();
		//전체 게시글 수 구함
		int count = 0;
		if(rs2.next()){
			count=rs2.getInt("cnt");
		}
		//마지막 페이지 구하기
		int lastPage = count/rowPerPage;
		if(count%rowPerPage!=0){
			lastPage += 1;
		}	
	%>
	<!-- 출력 -->
	<form method="post" action="./departmentList.jsp">
		<div class="row">
			<div class="col-3"></div>
			<div style="text-align:right;"class="col-2">
				dept_name :
			</div>
			<div class="col-5">
				<input class="form-control"style="width:100%;" type="text" name="searchDeptName" value =<%=searchDeptName %>>
			</div>
			<div class="col-2">
				<button class="btn btn-outline-success" type="submit">검색</button>
			</div>
		</div>
	</form>
	<table class="table">
		<thead>
			<tr>
				<th>dept_no</th>
				<th>dept_name</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getString("dept_no") %></td>
				<td><%=rs.getString("dept_name") %></td>
			</tr>
		<%	
			}
		%>	
		</tbody>
	</table>
	<%
		if(currentPage!=1){
	%>
		<a href="./departmentList.jsp?currentPage=1">처음으로</a>
	<%
		}
		if(currentPage > 1){
	%>
		<a href="./departmentList.jsp?currentPage=<%=currentPage-1 %>">이전</a>
	<%		
		} 
	if(currentPage < lastPage){
	%>
		<a href="./departmentList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%		
		}
	%>
	<%
	if(currentPage != lastPage){
	%>
		<a href="./departmentList.jsp?currentPage=<%=lastPage %>">끝으로</a>
	<%
		}
	%>
	
</div>
</body>
</html>