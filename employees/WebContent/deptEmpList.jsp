<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptEmpList</title>
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
	<h1>deptEmpList</h1>
	<br>
	<!-- deptEmpList 목록 -->
	<%
		int currentPage = 1;
		if(request.getParameter("currentPage")!=null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		String ck = "no";
		if(request.getParameter("ck")!=null){
			ck = request.getParameter("ck");
		}
		String deptNo = "";
		if(request.getParameter("deptNo")!=null){
			deptNo = request.getParameter("deptNo");
		}
		System.out.println(deptNo);
		int rowPerPage = 10;
		int beginRow = (currentPage-1)*rowPerPage;
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://aonaru.kro.kr:3306/employees", "root","5192cjjh");
		String sql1 = "";
		String sql2 = "";
		PreparedStatement stmt1 = null;
		PreparedStatement stmt2 = null;
		//ck = no, deptNo = x
		if(ck.equals("no") &&(deptNo.equals(""))){
			sql1 = "select * from dept_emp limit ?,?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1,beginRow);
			stmt1.setInt(2,rowPerPage);
			sql2 = "select count(*) as cnt from dept_emp";
			stmt2 = conn.prepareStatement(sql2);
			//ck = yes, deptNo = x
		}else if(ck.equals("yes")&&(deptNo.equals(""))){
			sql1 = "select * from dept_emp where to_date='9999-01-01' limit ?,?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setInt(1,beginRow);
			stmt1.setInt(2,rowPerPage);
			sql2 = "select count(*) as cnt from dept_emp where to_date='9999-01-01'";
			stmt2 = conn.prepareStatement(sql2);
			//ck = no, deptNo = o
		}else if(ck.equals("no")&& (!deptNo.equals(""))){
			sql1 = "select * from dept_emp where dept_no = ? limit ?,?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1,deptNo);
			stmt1.setInt(2,beginRow);
			stmt1.setInt(3,rowPerPage);
			sql2 = "select count(*) as cnt from dept_emp where dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,deptNo);
			//ck = yes, deptNo = o
		}else{
			sql1 = "select * from dept_emp where to_date='9999-01-01' and dept_no = ? limit ?,?";
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1,deptNo);
			stmt1.setInt(2,beginRow);
			stmt1.setInt(3,rowPerPage);
			sql2 = "select count(*) as cnt from dept_emp where to_date='9999-01-01' and dept_no = ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1,deptNo);
		}
		ResultSet rs = stmt1.executeQuery();
		ResultSet rs2 = stmt2.executeQuery();
		//전체 게시글 수 구함
		int count = 0;
		if(rs2.next()){
			count=rs2.getInt("cnt");
		}
		//전체 페이지 구하기
		int allPage = count/rowPerPage;
		if(count%rowPerPage!=0){
			allPage += 1;
		}
		// 한번에 보여줄 페이지 수 1~10, 11~20
		int oneSection = 10;
		// 현재 섹션
		int currentSection = 1;
		if(request.getParameter("currentSection")!=null){
			currentSection =Integer.parseInt(request.getParameter("currentSection"));
		}
		// 전체 페이지 구하기
		int allSection = allPage/oneSection;
		if(allPage%oneSection!=0){
			allSection+=1;
		}
		//이전페이지
		int prePage = (currentSection-1)*oneSection;
		//다음페이지
		int nextPage = (currentSection+1)*oneSection-(oneSection-1);
		// 현재 섹션의 시작번호
		int firstSection = currentSection*oneSection -(oneSection-1);
		System.out.println(currentSection);
		String sql3 = "select dept_no from departments";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
	%>
	<form method="post" action="./deptEmpList.jsp">
		<div class="row">
			<div class="col-3" style="text-align:center; font-size:18px;">
			<%
				if(ck.equals("no")){
			%>
					<input style="zoom:1.2;" class="form-check-input" type="checkbox" name="ck" value="yes">재직자
			<%		
				}else{
			%>
					<input style="zoom:1.2;" class="form-check-input" type="checkbox" name="ck" value="yes" checked="checked" >재직자
			<%		
				}
			%>
			</div>
			<div class="col-7">
			<select class="form-control"name="deptNo">
				<option value="">선택안함</option>
				<%
					while(rs3.next()){
						if(deptNo.equals(rs3.getString("dept_no"))){
				%>
						<option value ="<%=rs3.getString("dept_no")%>" selected = "selected">
						<%=rs3.getString("dept_no")%></option>
				<%	
						}else{
				%>
						<option value ="<%=rs3.getString("dept_no")%>">
						<%=rs3.getString("dept_no")%></option>
				<%
						}
					}
				%>
			</select>
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
					<th>dept_no</th>
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
					<td><%=rs.getString("dept_no") %></td>
					<td><%=rs.getString("from_date") %></td>
					<td><%=rs.getString("to_date") %></td>
				</tr>
		<%		
			}
		%>		
			</tbody>	
		</table>
			
		<%
		
		if(currentSection!=1){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=prePage %>&currentSection=<%=currentSection-1 %>&ck=<%=ck %>&deptNo=<%=deptNo %>">이전</a>
		<%
			}
		for(int i=firstSection;i<firstSection+oneSection;i++){
			if(currentPage==i){
		%>
				<a href="./deptEmpList.jsp?currentPage=<%=currentPage %>&currentSection=<%=currentSection %>&ck=<%=ck %>&deptNo=<%=deptNo %>"></a><%=i %>
		<%	
			}else{
		%>
				<a href="./deptEmpList.jsp?currentPage=<%=i %>&currentSection=<%=currentSection %>&ck=<%=ck %>&deptNo=<%=deptNo %>"><%=i %></a>
		<%
			}
			
		}
		
		if(currentSection != allSection){
		%>
			<a href="./deptEmpList.jsp?currentPage=<%=nextPage %>&currentSection=<%=currentSection+1 %>&ck=<%=ck %>&deptNo=<%=deptNo %>">다음</a>
		<%
			}
		
		%>

</div>
</body>
</html>