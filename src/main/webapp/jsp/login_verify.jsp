<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%
String userID = request.getParameter("userID");
String userPassword = request.getParameter("userPassword");
Connection myConn = null;
Statement stmt = null;
String mySQL = null;
String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
String user = "c##jiyoo"; //���̵�
String passwd = "pwd2023"; // ��й�ȣ
String dbdriver = "oracle.jdbc.driver.OracleDriver";
Class.forName(dbdriver);
myConn = DriverManager.getConnection(dburl, user, passwd);
stmt = myConn.createStatement();
mySQL = "select s_id from student where s_id='" + userID + "' and s_pwd='" + userPassword + "'";
ResultSet myResultSet = stmt.executeQuery(mySQL);
if (myResultSet.next()) {
	session.setAttribute("user", userID);
	response.sendRedirect("main.jsp");
} else {
%>
<script>
	alert("����� ���̵� Ȥ�� ��ȣ�� Ʋ�Ƚ��ϴ�");
	location.href = "login.jsp";
</script>
<%
}
stmt.close();
myConn.close();
%>


