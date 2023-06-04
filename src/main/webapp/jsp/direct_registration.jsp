<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>빠른 수강신청</title>    
</head>
<body>

    <%
    String s_id = (String) session.getAttribute("user");
    String c_id = request.getParameter("c_id");
    int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
    %>

    <%
    Connection myConn = null;
    String result = null;
    String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "c##yjson";
    String passwd = "1234";
    String dbdriver = "oracle.jdbc.driver.OracleDriver";
    try {
        Class.forName(dbdriver);
        myConn = DriverManager.getConnection(dburl, user, passwd);
        myConn.setAutoCommit(false); // Disable auto-commit
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    } catch (ClassNotFoundException ex) {
        System.err.println("ClassNotFoundException: " + ex.getMessage());
    }

    CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");
    cstmt.setString(1, s_id);
    cstmt.setString(2, c_id);
    cstmt.setInt(3, c_id_no);
    cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
    try {
        // 대기인원 체크
        String selectCourseWaitSQL = "SELECT c_wait FROM course WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no;
        Statement stmt = myConn.createStatement();
        ResultSet courseWaitResultSet = stmt.executeQuery(selectCourseWaitSQL);
        int c_wait = 0;
        if (courseWaitResultSet.next()) {
            c_wait = courseWaitResultSet.getInt("c_wait");
        }
        courseWaitResultSet.close();
        stmt.close();

        // 대기인원이 존재하는 경우
        if (c_wait > 0) {
            response.sendRedirect("wait_verify.jsp?c_id=" + c_id + "&c_id_no=" + c_id_no);
        } else {
            // 수강신청 프로시저 호출
            cstmt.execute();
            result = cstmt.getString(4);
            %>
            <script>
                alert("신청이 완료되었습니다");
                location.href = "main.jsp";
            </script>
            <%
            myConn.commit(); // Explicitly commit the transaction
        }
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    } finally {
        if (cstmt != null) {
            try {
                cstmt.close();
                myConn.close();
            } catch (SQLException ex) {
                System.err.println("SQLException: " + ex.getMessage());
            }
        }
    }
    %>
</body>
</html>
