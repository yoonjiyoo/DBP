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

    String c_sem = ""; // c_sem 변수 초기화
    String c_year = ""; // c_year 변수 초기화

    // 현재 날짜 가져오기
    java.util.Date currentDate = new java.util.Date();
    java.util.Calendar calendar = java.util.Calendar.getInstance();
    calendar.setTime(currentDate);
    int month = calendar.get(java.util.Calendar.MONTH) + 1; // 1월은 0으로 인덱싱되므로 +1

    // 학기와 연도 설정
    if (month >= 5 && month <= 10) { // 5월부터 10월까지는 2학기
        c_sem = "2";
        c_year = String.valueOf(calendar.get(java.util.Calendar.YEAR));
    } else { // 11월부터 4월까지는 1학기
        c_sem = "1";
        int year = calendar.get(java.util.Calendar.YEAR);
        if (month >= 11 || month <= 4) {
            c_year = String.valueOf(year + 1); // 11월, 12월의 경우 연도 +1
        } else {
            c_year = String.valueOf(year);
        }
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
        myConn.setAutoCommit(false); // Disable auto-commit
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    } catch (ClassNotFoundException ex) {
        System.err.println("ClassNotFoundException: " + ex.getMessage());
    }

    CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?,?,?)}");
    cstmt.setString(1, s_id);
    cstmt.setString(2, c_id);
    cstmt.setInt(3, c_id_no);
    cstmt.setInt(4, Integer.parseInt(c_sem)); // 수정: c_sem을 정수로 변환하여 전달
    cstmt.setInt(5, Integer.parseInt(c_year)); // 수정: c_year를 정수로 변환하여 전달
    cstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
    try {
        // 대기인원 체크
        String selectCourseWaitSQL = "SELECT c_wait FROM course WHERE c_id='" + c_id + "' AND c_id_no=" + c_id_no + " AND c_sem=" + c_sem + " AND c_year=" + c_year;
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
            response.sendRedirect("wait_verify.jsp?c_id=" + c_id + "&c_id_no=" + c_id_no + "&c_sem=" + c_sem + "&c_year=" + c_year);
        } else {
            // 수강신청 프로시저 호출
            cstmt.execute();
            result = cstmt.getString(6);
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
