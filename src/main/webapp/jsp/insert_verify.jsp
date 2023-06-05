<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>수강신청 입력</title>
</head>
<body>
	<%
	String s_id = (String) session.getAttribute("user");
	String c_id = request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	String c_sem_str = request.getParameter("c_sem");
	String c_year_str = request.getParameter("c_year");


	int c_sem = 0;
	int c_year = 0;
	
	if(c_sem_str != null) {
	    c_sem = Integer.parseInt(c_sem_str);
	}

	if(c_year_str != null) {
	    c_year = Integer.parseInt(c_year_str);
	}
	%>
	<%
	Connection myConn = null;
	String result = null;
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "c##jiyoo";
	String passwd = "pwd2023";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	try {
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
	} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	}

	CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?,?,?)}");
	cstmt.setString(1, s_id);
	cstmt.setString(2, c_id);
	cstmt.setInt(3, c_id_no);
	cstmt.setInt(4, c_sem);
	cstmt.setInt(5, c_year);
	cstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
	try {
		cstmt.execute();
		result = cstmt.getString(6);
	%>
	<script>
alert("<%=result%>");
		location.href = "insert.jsp";
	</script>
	<%
	} catch (SQLException ex) {
	System.err.println("SQLException: " + ex.getMessage());
	} finally {
	if (cstmt != null)
		try {
			myConn.commit();
			cstmt.close();
			myConn.close();
		} catch (SQLException ex) {
		}
	}
	%>
	</form>
</body>
</html>
