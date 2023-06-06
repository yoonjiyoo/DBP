<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<html>
<head>
<title>수강신청 입력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">

</head>
<body>
    <%@ include file="top.jsp"%>
    <%
    if (session_id == null)
        response.sendRedirect("login.jsp");
    %>
    <div class="container col-9"  align="center">
    <table class = "table table-striped">
        <br>
        <thead align="center" class="table-dark">
        <tr>
            <th>과목번호</th>
            <th>분반</th>
            <th>과목명</th>
            <th>학점</th>
            <th>최대수강인원</th>
            <th>수강신청인원</th>
            <th>학과</th>
            <th>수강대기인원</th>
            <th>신청</th>
            <th>삭제</th>
        </tr>
        </thead>
        <%
        Connection myConn = null;
        Statement stmt = null;
        ResultSet myResultSet = null;
        String mySQL = "";
        String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
        String user = "c##yujin";
        String passwd = "DBP2023";
        String dbdriver = "oracle.jdbc.driver.OracleDriver";
        try {
            Class.forName(dbdriver);
            myConn = DriverManager.getConnection(dburl, user, passwd);
            stmt = myConn.createStatement();
        } catch (SQLException ex) {
            System.err.println("SQLException: " + ex.getMessage());
        }

        // 이전에 신청한 과목들을 저장하는 ArrayList 생성
        ArrayList<String> enrolledCourses = new ArrayList<String>();

        // 신청한 과목들을 조회하여 enrolledCourses에 저장
        String selectEnrolledCoursesSQL = "select c_id from enroll where s_id='" + session_id + "'";
        ResultSet enrolledCoursesResultSet = stmt.executeQuery(selectEnrolledCoursesSQL);
        while (enrolledCoursesResultSet.next()) {
            String enrolledCourseId = enrolledCoursesResultSet.getString("c_id");
            enrolledCourses.add(enrolledCourseId);
        }

        // 이전에 즐겨찾기한 과목들을 저장하는 ArrayList 생성
        ArrayList<String> starCourses = new ArrayList<String>();

        // 즐겨찾기한 과목들을 조회하여 starCourses에 저장
        String selectStarCoursesSQL = "select c_id from star where s_id='" + session_id + "'";
        ResultSet starCoursesResultSet = stmt.executeQuery(selectStarCoursesSQL);
        while (starCoursesResultSet.next()) {
            String starCourseId = starCoursesResultSet.getString("c_id");
            starCourses.add(starCourseId);
        }

        //즐겨찾기한 과목과 join--> 즐겨찾기된 과목만 조회됨
        mySQL = "select c_id,c_name,c_id_no,c_unit,c_max,c_app,c_major,c_wait from course " +
             "where c_id in (select c_id from star where s_id='" + session_id + "') " +
             "and c_id_no in (select c_id_no from star where s_id='" + session_id + "')";
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
            <td align="center">
                <% if (enrolledCourses.contains(c_id)) { %>
                    신청완료
                <% } else { %>
                    <a href="insert_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">신청</a>
                <% } %>
            </td>
            <td align="center">
            <a href="star_cancel.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">즐겨찾기취소</a>
            </td>
        </tr>
        <% 
        }
        }
        stmt.close();
        myConn.close();
        %>
    </table></div>
</body>
</html>
