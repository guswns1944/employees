<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>titlesList</title>
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
	<br>
	<%
		int currentPage = 1;
		if(request.getParameter("currentPage")!=null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		int rowPerPage = 10;
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://aonaru.kro.kr:3306/employees", "root","5192cjjh");
		String sql = "select emp_no, title, from_date, to_date from titles order by emp_no limit ?,?";
		String sql2 = "select count(*) as cnt from titles";
		PreparedStatement stmt = conn.prepareStatement(sql);
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt.setInt(1, (currentPage-1)*rowPerPage);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
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
	<!-- titlesList 테이블 목록 -->
	<h1>titlesList</h1>
		<table class="table">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>title</th>
					<th>from_date</th>
					<th>to_date</th>
				</tr>
			</thead>
			<tbody>
		<%
				while(rs.next()){
		%>		
				<tr>
					<td><%=rs.getString("emp_no") %></td>
					<td><%=rs.getString("title") %></td>
					<td><%=rs.getString("from_date") %></td>
					<td><%=rs.getString("to_date") %></td>
				</tr>
		<%		
				}
		%>
				
			</tbody>
		</table>
		<%
		if(currentPage!=1){
		%>
			<a href="./titlesList.jsp?currentPage=1">처음으로</a>
		<%
			}
		if(currentPage > 1){
		%>
			<a href="./titlesList.jsp?currentPage=<%=currentPage-1 %>">이전</a>
		<%		
		} 
		if(currentPage < lastPage){
		%>
			<a href="./titlesList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
		<%		
			}
		%>
		<%
		if(currentPage != lastPage){
		%>
			<a href="./titlesList.jsp?currentPage=<%=lastPage %>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>