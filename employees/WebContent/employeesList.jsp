<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>employeesList</title>
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
	<!-- employees 테이블 목록 -->
	<h1>employees</h1>
	<%
		request.setCharacterEncoding("utf-8");
		int currentPage = 1;
		if(request.getParameter("currentPage")!=null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		int rowPerPage = 10;
		String searchGender = "선택안함";
		if(request.getParameter("searchGender")!=null){
			searchGender = request.getParameter("searchGender");
		}
		String searchFirstName = "";
		if(request.getParameter("searchFirstName")!=null){
			searchFirstName = request.getParameter("searchFirstName");
		}
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://aonaru.kro.kr:3306/employees", "root","5192cjjh");
		//동적쿼리
		String sql = "";
		PreparedStatement stmt = null;
		String sql2 = "";
		PreparedStatement stmt2 = null;
		//1. gender=x , first_name = x
		if(searchGender.equals("선택안함")&& searchFirstName.equals("")){
			sql = "select * from employees limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage-1)*rowPerPage);
			stmt.setInt(2, rowPerPage);
			sql2 = "select count(*) as cnt from employees";
			stmt2 = conn.prepareStatement(sql2);
			//2. gender=o, first_name = x
		}else if(!searchGender.equals("선택안함")&& searchFirstName.equals("")){
			sql = "select * from employees where gender = ? limit ?,? ";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1,searchGender);
			stmt.setInt(2, (currentPage-1)*rowPerPage);
			stmt.setInt(3, rowPerPage);
			sql2 = "select count(*) as cnt from employees where gender = ? ";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,searchGender);
			//3. gender=x, first_name = o or last_name= o
		}else if(searchGender.equals("선택안함")&& !searchFirstName.equals("")){
			sql = "select * from employees where first_name like ? or last_name like ? limit ?,?" ;
			stmt = conn.prepareStatement(sql);	
			stmt.setString(1,"%"+searchFirstName+"%");
			stmt.setString(2,"%"+searchFirstName+"%");
			stmt.setInt(3, (currentPage-1)*rowPerPage);
			stmt.setInt(4, rowPerPage);
			sql2 = "select count(*) as cnt from employees where first_name like ? or last_name like ? ";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,"%"+searchFirstName+"%");
			stmt2.setString(2,"%"+searchFirstName+"%");
			//4. gender=o,first_name = o or last_name= o
		}else{
			sql = "select * from employees where gender = ? and (first_name like ? or last_name like ? ) limit ?,? ";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1,searchGender);
			stmt.setString(2,"%"+searchFirstName+"%");
			stmt.setString(3,"%"+searchFirstName+"%");
			stmt.setInt(4, (currentPage-1)*rowPerPage);
			stmt.setInt(5, rowPerPage);
			sql2 = "select count(*) as cnt from employees where gender = ? and ( first_name like ? or last_name like ? )";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,searchGender);
			stmt2.setString(2,"%"+searchFirstName+"%");
			stmt2.setString(3,"%"+searchFirstName+"%");
		}
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
	<br>
	<form method="post" action="./employeesList.jsp">
		<div class="row">
			<div class="col-3" style="text-align:center; font-size:20px;">
				gender : 
				<select name="searchGender">
				<%
					if(searchGender.equals("선택안함")){
				%>
						<option value="선택안함" selected="selected">선택안함</option>
				<%		
					}else{
				%>
						<option value="선택안함">선택안함</option>
				<%	
					}
				
					if(searchGender.equals("M")){
				%>
						<option value="M" selected="selected">남</option>
				<%		
					}else{
				%>
						<option value="M">남</option>
				<%		
					}
					if(searchGender.equals("F")){
				%>
						<option value="F" selected="selected">여</option>
				<%
					}else{
				%>
						<option value="F">여</option>
				<%
					}
				%>
				</select>
			</div>
			<div class="col-7" style="font-size:20px;">
				name :
				<input class="form-control"style="width:87%; float:right;" type="text" name="searchFirstName" value=<%=searchFirstName %>>
			</div>
			<div class="col-2">
				<button class="btn btn-outline-success" type="submit">검색</button>
			</div>
		</div>
	</form>
	<table class="table">
		<thead>
			<tr>
				<th>emp_no</th>
				<th>birth_date</th>
				<th>first_name</th>
				<th>last_name</th>
				<th>gender</th>
				<th>hire_date</th>
			</tr>
		</thead>
		<tbody>
	<%
		while(rs.next()){
	%>
		<tr>
			<td><%=rs.getString("emp_no") %></td>
			<td><%=rs.getString("birth_date") %></td>
			<td><%=rs.getString("first_name") %></td>
			<td><%=rs.getString("last_name") %></td>
			<td><%=rs.getString("gender") %></td>
			<td><%=rs.getString("hire_date") %></td>
		</tr>
	<%		
		}
	%>		
		</tbody>
	</table>
	
	<%
	
		if(currentPage!=1){
		%>
			<a href="./employeesList.jsp?currentPage=1&searchGender=<%=searchGender %>&searchFirstName=<%=searchFirstName%>">처음으로</a>
		<%
			}
		if(currentPage > 1){
		%>
			<a href="./employeesList.jsp?currentPage=<%=currentPage-1 %>&searchGender=<%=searchGender %>&searchFirstName=<%=searchFirstName%>">이전</a>
		<%		
			}
		if(currentPage < lastPage){
		%>
			<a href="./employeesList.jsp?currentPage=<%=currentPage+1 %>&searchGender=<%=searchGender %>&searchFirstName=<%=searchFirstName%>">다음</a>
		<%		
			}
		%>
		<%
		if(currentPage != lastPage){
		%>
			<a href="./employeesList.jsp?currentPage=<%=lastPage %>&searchGender=<%=searchGender %>&searchFirstName=<%=searchFirstName%>">끝으로</a>
		<%
			}
		%>
</div>
</body>
</html>