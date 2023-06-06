<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<html>
<head>
<title>수강신청 입력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">

</head>
<body>
   <%@ include file="top.jsp"%>
   <%
   int c_year=2023;
   int c_sem=2;
   if (request.getMethod().equalsIgnoreCase("post")) {
	   c_year = Integer.parseInt(request.getParameter("year"));
	   c_sem = Integer.parseInt(request.getParameter("semester"));
   }
   if (session_id == null)
      response.sendRedirect("login.jsp");
   %>
   <div class="container col-9" align="center">
   <table class = "table table-striped">
      <br>
      <thead align="center" class="table-dark">
      <tr>
         <th>과목번호</th>
         <th>분반</th>
         <th>과목명</th>
         <th>학점</th>
         <th>학과</th> 
         <th>수강정원</th>
         <th>신청인원</th>
         
      </tr>
      </thead>
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
      String selectEnrolledCoursesSQL = "select c.c_id, c.c_id_no, c.c_name, c.c_unit, c.c_max, c.c_app, c.c_major, c.c_wait from Course c, Enroll e where e.s_id='" + session_id + "' and e.c_id=c.c_id and e.c_id_no = c.c_id_no and c.c_year='"+c_year+"' and c.c_sem="+c_sem;
      
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
      
      CallableStatement cstmt = myConn.prepareCall("{call SelectEnroll (?,?,?,?,?)}");
      cstmt.setString(1, session_id);
      cstmt.setInt(2, c_year);
      cstmt.setInt(3, c_sem);
  	  cstmt.registerOutParameter(4, java.sql.Types.INTEGER);
  	  cstmt.registerOutParameter(5, java.sql.Types.INTEGER);
  	  try {
  		  cstmt.execute();
  		  int s_unit = cstmt.getInt(4);
  		  int s_count = cstmt.getInt(5);
  		%>
		<tbody class="table-group-divider">
  		<tr>
      		<th colspan="5">총 신청학점</th>
      		<td align="center" colspan="2"><%=s_unit%></td>
      	</tr>
      	<tr>
      		<th colspan="5">총 신청과목 수</th>
      		<td align="center" colspan="2"><%=s_count%></td>
      	</tr></tbody>
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
   </table></div>
   <br><br>
   <form class="container d-flex row justify-content-center mx-auto" action="" method="post" align="center">
   	<div class="input-group ">
   	<div class="d-flex mx-3">
   	<input class="form-control" type="text" id="year" name="year" value=<%=c_year %> required>
   	<label class="input-group-text" for="year">년도</label>
   	</div>
   	<div class="d-flex mx-3">
   	<input class="form-control" type="text" id="semester" name="semester" value=<%=c_sem %> required>
   	<label class="input-group-text" for="semester">학기</label>
   	</div>
   	<input  class="btn btn-primary" type="submit" value="조회">
   	</div>
   </form>
</body>
</html>
