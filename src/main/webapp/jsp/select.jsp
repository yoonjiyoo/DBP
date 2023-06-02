<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<html>
<head>
<title>수강신청 입력</title>
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
         <th>과목번호</th>
         <th>분반</th>
         <th>과목명</th>
         <th>학점</th>
         <th>학과</th> 
         <th>수강정원</th>
         <th>신청인원</th>
         
      </tr>
      
      <%
      Connection myConn = null;
      Statement stmt = null;
      Statement stmt2 = null;
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

      ArrayList<String> enrolledCourseIds = new ArrayList<String>();
      ArrayList<Integer> enrolledCourseIdNumbers = new ArrayList<Integer>();
      
      // 신청한 과목들을 조회하여 enrolledCourses에 저장
      String selectEnrolledCoursesSQL = "select c.c_id, c.c_id_no, c.c_name, c.c_unit, c.c_max, c.c_app, c.c_major, c.c_wait from Course c, Enroll e where e.s_id='" + session_id + "' and e.c_id=c.c_id and e.c_id_no = c.c_id_no";
      myResultSet = stmt.executeQuery(selectEnrolledCoursesSQL);
      
      while (myResultSet.next()) {
    	  String c_id = myResultSet.getString("c_id");
          int c_id_no = myResultSet.getInt("c_id_no");
          String c_name = myResultSet.getString("c_name");
          int c_unit = myResultSet.getInt("c_unit");
          int c_max = myResultSet.getInt("c_max");
          int c_app = myResultSet.getInt("c_app");
          String c_major = myResultSet.getString("c_major");
          int c_wait = myResultSet.getInt("c_wait");%>
      <tr>   
        <td align="center"><%=c_id%></td>
       	<td align="center"><%=c_id_no%></td>
       	<td align="center"><%=c_name%></td>
       	<td align="center"><%=c_unit%></td>
       	<td align="center"><%=c_major%></td>
       	<td align="center"><%=c_max%></td>
       	<td align="center"><%=c_app%></td>
       	
      </tr>
      <%}
      
      CallableStatement cstmt = myConn.prepareCall("{call SelectEnroll (?,?,?)}");
      cstmt.setString(1, session_id);
  	  cstmt.registerOutParameter(2, java.sql.Types.INTEGER);
  	  cstmt.registerOutParameter(3, java.sql.Types.INTEGER);
  	  try {
  		  cstmt.execute();
  		  int s_unit = cstmt.getInt(2);
  		  int s_count = cstmt.getInt(3);
  		%>
  		<tr>
      		<th colspan="5">총 신청학점</th>
      		<td align="center" colspan="2"><%=s_unit%></td>
      	</tr>
      	<tr>
      		<th colspan="5">총 신청과목 수</th>
      		<td align="center" colspan="2"><%=s_count%></td>
      	</tr>
  	  <%} catch (SQLException ex) {
  			System.err.println("SQLException: " + ex.getMessage());
  	  } finally {
  		  if (cstmt != null)
  		try {
  			myConn.commit();
  			cstmt.close();
  			stmt.close();
  			stmt2.close();
  			myConn.close();
  		} catch (SQLException ex) {
  		}
  	}%>

   </table>
</body>
</html>
