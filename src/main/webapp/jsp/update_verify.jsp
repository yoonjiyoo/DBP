<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>������û ����� ���� ����</title>
</head>
<body>
	<%
String s_id =request.getParameter("s_id");
String s_addr=new
String(request.getParameter("s_addr").getBytes("Cp1252"),"euckr");
String s_pwd=new String(request.getParameter("s_pwd"));
Connection myConn = null; Statement stmt = null; String mySQL =
null;
String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
String user=""; String passwd=""; // ��й�ȣ
String dbdriver = "oracle.jdbc.driver.OracleDriver";
try {
Class.forName(dbdriver);
myConn = DriverManager.getConnection (dburl, user, passwd);
stmt=myConn.createStatement();
} catch(SQLException ex) {
System.err.println("SQLException: " + ex.getMessage());
}
try {
mySQL ="update student set s_pwd='"+s_pwd+"' where s_id='"+s_id+"'";
stmt.execute(mySQL);
%>
	<script>
alert("�л������� ���� �Ǿ����ϴ�. ");
location.href="update.jsp";
</script>
	<%
} catch(SQLException ex) {
String sMessage;
if (ex.getErrorCode() == 20002) sMessage="��ȣ�� 4�ڸ� �̻��̾�� �մϴ�";
else if (ex.getErrorCode() == 20003) sMessage="��ȣ�� ������ �Էµ��� �ʽ��ϴ�.";
else sMessage="��� �� �ٽ� �õ��Ͻʽÿ�";
%>
	<script>
alert("<%=sMessage%>
		");
		location.href = "update.jsp";
	</script>
	<%
}
finally{
if(stmt!=null)try{stmt.close(); myConn.close();}
catch(SQLException ex) { }
}
%>
</body>
</html>
>
