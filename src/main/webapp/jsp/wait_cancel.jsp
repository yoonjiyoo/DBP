<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>대기취소</title>
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
        stmt = myConn.prepareCall("{ call cancel_wait(?, ?, ?) }"); // This procedure should delete a row from the wait table and decrease c_wait by 1
        stmt.setString(1, session_id);
        stmt.setString(2, c_id);
        stmt.setInt(3, c_id_no);
        stmt.execute();

        // Decrease c_wait by 1 in the HTML table
        String selectCourseWaitSQL = "SELECT c_wait FROM course WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
        ResultSet courseWaitResultSet = stmt.executeQuery(selectCourseWaitSQL);
        int c_wait = 0;
        if (courseWaitResultSet.next()) {
            c_wait = courseWaitResultSet.getInt("c_wait");
        }
        courseWaitResultSet.close();

        %>
        <table>
            <tr>
                <td align="center"><%= c_wait - 1 %></td>
            </tr>
        </table>
        <%
        stmt.close();
        myConn.close();
        response.sendRedirect("insert.jsp"); // Redirect back to the course page
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    }
    %>
</body>
</html>
