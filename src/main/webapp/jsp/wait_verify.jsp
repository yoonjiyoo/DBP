<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>대기하기</title>
</head>
<body>
    <%@ include file="top.jsp"%>
    <%
    if (session_id == null)
        response.sendRedirect("login.jsp");
    %>
    <%
    String c_id = request.getParameter("c_id");
    int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));

    Connection myConn = null;
    CallableStatement stmt = null;
    String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "c##jiyoo";
    String passwd = "pwd2023";
    String dbdriver = "oracle.jdbc.driver.OracleDriver";
    try {
        Class.forName(dbdriver);
        myConn = DriverManager.getConnection(dburl, user, passwd);
        stmt = myConn.prepareCall("{ call wait_course(?, ?, ?) }");
        stmt.setString(1, session_id);
        stmt.setString(2, c_id);
        stmt.setInt(3, c_id_no);
        stmt.execute();
        stmt.close();
        myConn.close();
        response.sendRedirect("insert.jsp"); 
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    }
    %>
</body>
</html>