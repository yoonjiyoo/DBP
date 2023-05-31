<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>수강신청 입력</title>
</head>
<body>
	<%
	String s_id = (String)session.getAttribute("user");
	String c_id = request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	%>
	<%
	Connection myConn = null;
	String result = null;
	Statement stmt = null;
	Statement stmt2 = null;
    ResultSet myResultSet = null;
	PreparedStatement pstmt = null;
	/*PreparedStatement pstmt2 = null;*/
	int courseUnit = 0;
	int studentUnit = 0;
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "c##yujin";
	String passwd = "DBP2023";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	try {
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
		stmt = myConn.createStatement();
		stmt2 = myConn.createStatement();
		
	} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	}
	
	String getCourseUnitSQL = "select c_unit from course where c_id='" + c_id + "' and c_id_no="+c_id_no;
    ResultSet getCourseUnitResultSet = stmt.executeQuery(getCourseUnitSQL);

    while (getCourseUnitResultSet.next()) {
        courseUnit = getCourseUnitResultSet.getInt("c_unit");
    }
    
    String getStudentUnitSQL = "select s_unit from student where s_id='" + s_id + "'";
    ResultSet getStudentUnitResultSet = stmt2.executeQuery(getStudentUnitSQL);

    while (getStudentUnitResultSet.next()) {
        studentUnit = getStudentUnitResultSet.getInt("s_unit");
    }
	
	String deleteEnrollSQL = "delete from enroll where s_id=? and c_id=? and c_id_no=?";
	pstmt = myConn.prepareStatement(deleteEnrollSQL);
	pstmt.setString(1, s_id);
	pstmt.setString(2, c_id);
	pstmt.setInt(3, c_id_no);
	
	/*String updateStudentUnitSQL = "update student set s_unit=? where s_id=?";
	pstmt2 = myConn.prepareStatement(updateStudentUnitSQL);
	pstmt2.setInt(1, studentUnit - courseUnit);
	pstmt2.setString(2, s_id);*/
	try {
		pstmt.executeUpdate();
		/*pstmt2.executeUpdate();*/
		result = "삭제가 완료되었습니다.";
    %>
	<script>
		alert("<%=result%>");
		location.href = "delete.jsp";
	</script>
	<%
	} catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	} finally {
	if (pstmt != null)
		try {
			myConn.commit();
			stmt.close();
			stmt2.close();
			pstmt.close();
			/*pstmt2.close();*/
			myConn.close();
		} catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
	}
	%>
	</form>
</body>
</html>