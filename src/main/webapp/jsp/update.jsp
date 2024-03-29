<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>수강신청 사용자 정보 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">

</head>
<body>
	<%@ include file="top.jsp"%>
	<% if (session_id==null) response.sendRedirect("login.jsp"); %>
	<%
	Connection myConn = null; Statement stmt = null;
	ResultSet myResultSet = null; String mySQL = "";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user="c##yujin"; String passwd="DBP2023";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		myConn = DriverManager.getConnection(dburl,user,passwd );
		stmt = myConn.createStatement();
	} catch(SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	}
	mySQL = "select s_id, s_name, s_addr, s_pwd from student where s_id='" + session_id + "'";
	myResultSet = stmt.executeQuery(mySQL);
	if (myResultSet != null) {
		while (myResultSet.next()) {
			String s_id = myResultSet.getString("s_id");
			String s_name = myResultSet.getString("s_name");
			String s_addr = myResultSet.getString("s_addr");
			String s_pwd = myResultSet.getString("s_pwd");
	%>
	<form class="container col-7" align="center" method="post" action="update_verify.jsp">
		<input type="hidden" name="s_id" size="30" value="<%=session_id%>">
		<table class="table table-bordered">
			<tr>
				<th>학 번</th>
				<td><div class="col-5">
				<input class="form-control" type="text" name="s_id" size="10"
					value="<%=s_id%>"  style="background-color:#ebebeb" readonly ></div></td>
			</tr>
			<tr>
				<th>이 름</th>
				<td><div class="col-5">
				<input class="form-control" type="text" name="s_name" size="10"
					value="<%=s_name%>"  style="background-color:#ebebeb" readonly></div></td>
			</tr>
			<tr>
				<th>주 소</th>
				<td><div class="col-5">
				<input class="form-control" type="text" name="s_addr" size="50"
					value="<%=s_addr%>"></div></td>
			</tr>
			<tr>
				<th>패스워드</th>
				<td><div class="col-5">
				<input class="form-control" type="password" name="s_pwd" size="20"
					value="<%=s_pwd%>"></div></td>
			</tr>
			
			<%
	} }
	stmt.close(); myConn.close();
	%>
			<tr>
				<td colspan="2" align="center"><input class="btn btn-primary" type="submit" value="수정"></td>
			</tr>
		</table>
	</form>
</body>
</html>
