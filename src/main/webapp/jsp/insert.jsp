<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>������û �Է�</title>
</head>
<body>
	<%@ include file="top.jsp"%>
	<%
	if (session_id == null)
		response.sendRedirect("login.jsp");
	%>
	<table width="75%" align="center" border>
		<br>
		<tr>
			<th>�����ȣ</th>
			<th>�й�</th>
			<th>�����</th>
			<th>����</th>
			<th>�ִ�����ο�</th>
			<th>������û�ο�</th>
			<th>�а�</th>
			<th>��������ο�</th>
			<th>��û</th>
		</tr>
		<%
		Connection myConn = null;
		Statement stmt = null;
		ResultSet myResultSet = null;
		String mySQL = "";
		String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "c##jiyoo";
		String passwd = "pwd2023";
		String dbdriver = "oracle.jdbc.driver.OracleDriver";
		try {
			Class.forName(dbdriver);
			myConn = DriverManager.getConnection(dburl, user, passwd);
			stmt = myConn.createStatement();
		} catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}

		mySQL = "select c_id,c_name,c_id_no,c_unit,c_max,c_app,c_major,c_wait from course where c_id not in (select c_id from enroll where s_id='"
				+ session_id + "')";
		myResultSet = stmt.executeQuery(mySQL);
		if (myResultSet != null) {
			while (myResultSet.next()) {
				String c_id = myResultSet.getString("c_id");
				int c_id_no = myResultSet.getInt("c_id_no");
				String c_name = myResultSet.getString("c_name");
				int c_unit = myResultSet.getInt("c_unit");
				int c_max = myResultSet.getInt("c_max");
				int c_app = myResultSet.getInt("c_app");
				String c_major = myResultSet.getString("c_major");
				int c_wait = myResultSet.getInt("c_wait");
		%>

		<tr>
			<td align="center"><%=c_id%></td>
			<td align="center"><%=c_id_no%></td>
			<td align="center"><%=c_name%></td>
			<td align="center"><%=c_unit%></td>
			<td align="center"><%=c_max%></td>
			<td align="center"><%=c_app%></td>
			<td align="center"><%=c_major%></td>
			<td align="center"><%=c_wait%></td>
			<td align="center"><a
				href="insert_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">��û</a></td>
		</tr>
		<%
		}
		}
		stmt.close();
		myConn.close();
		%>
	</table>
</body>
</html>