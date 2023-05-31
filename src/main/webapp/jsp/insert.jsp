<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<html>
<head>
<title>수강신청 입력</title>
<script type="text/javascript">
	function changeMajor() {
		var selectedMajor = document.getElementById("majorSelect").value;
		window.location.href = 'insert.jsp?selectedMajor='
				+ encodeURIComponent(selectedMajor);
	}
</script>
</head>
<body>
	<%@ include file="top.jsp"%>
	<%
	if (session_id == null)
		response.sendRedirect("login.jsp");
	%>
	<table width="80%" align="center" border>
		<br>
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
			<th>즐겨찾기</th>
		</tr>
		<%
		Connection myConn = null;
		Statement stmt = null;
		ResultSet myResultSet = null;
		String mySQL = "";
		String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "c##jiyoo";
		String passwd = "pwd2023";
		String dbdriver = "oracle.jdbc.driver.OracleDriver";
		try {
			Class.forName(dbdriver);
			myConn = DriverManager.getConnection(dburl, user, passwd);
			stmt = myConn.createStatement();
		} catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}

		ArrayList<String> enrolledCourses = new ArrayList<String>();
		String selectEnrolledCoursesSQL = "select c_id from enroll where s_id='" + session_id + "'";
		ResultSet enrolledCoursesResultSet = stmt.executeQuery(selectEnrolledCoursesSQL);
		while (enrolledCoursesResultSet.next()) {
			String enrolledCourseId = enrolledCoursesResultSet.getString("c_id");
			enrolledCourses.add(enrolledCourseId);
		}
		enrolledCoursesResultSet.close();

		ArrayList<String> starCourses = new ArrayList<String>();
		String selectStarCoursesSQL = "select c_id from star where s_id='" + session_id + "'";
		ResultSet starCoursesResultSet = stmt.executeQuery(selectStarCoursesSQL);
		while (starCoursesResultSet.next()) {
			String starCoursesId = starCoursesResultSet.getString("c_id");
			starCourses.add(starCoursesId);
		}
		starCoursesResultSet.close();

		
		ArrayList<String> waitCourses = new ArrayList<String>();
		String selectWaitCoursesSQL = "select c_id from wait where s_id='" + session_id + "'";
		ResultSet waitCoursesResultSet = stmt.executeQuery(selectWaitCoursesSQL);
		while (waitCoursesResultSet.next()) {
			String waitCoursesId = waitCoursesResultSet.getString("c_id");
			waitCourses.add(waitCoursesId);
		}
		waitCoursesResultSet.close();

		String selectedMajor = request.getParameter("selectedMajor");

		String majorSQL = "select distinct c_major from course";
		ResultSet majorResultSet = stmt.executeQuery(majorSQL);
		%>
		<select id="majorSelect" onchange="changeMajor()">
			<option value="">All</option>
			<%
			while (majorResultSet.next()) {
				String major = majorResultSet.getString("c_major");
			%>
			<option value="<%=major%>"
				<%=selectedMajor != null && selectedMajor.equals(major) ? "selected" : ""%>><%=major%></option>
			<%
			}
			majorResultSet.close();

			mySQL = "select c_id,c_name,c_id_no,c_unit,c_max,c_app,c_major,c_wait from course"
					+ (selectedMajor == null || selectedMajor.equals("") ? "" : " where c_major = '" + selectedMajor + "'");
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

				boolean isEnrolled = enrolledCourses.contains(c_id);
				boolean isStarred = starCourses.contains(c_id);
				boolean isWaitlisted = waitCourses.contains(c_id);
				boolean isFull = c_max == c_app;
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
					<%
					if (isEnrolled) {
					%> 신청완료 <%
					} else if (isWaitlisted) {
					%> <a
					href="wait_cancel.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">대기취소</a>
					<%
					} else if (isFull) {
					%> <a href="wait_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">대기하기</a>
					<%
					} else {
					%> <a
					href="insert_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">신청</a>
					<%
					}
					%>
				</td>
				<td align="center">
					<%
					if (isStarred) {
					%> 즐겨찾기 <%
					} else {
					%> <a href="star_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">즐겨찾기</a>
					<%
					}
					%>
				</td>
			</tr>
			<%
			}
			myResultSet.close();
			}
			stmt.close();
			myConn.close();
			%>
		
	</table>
</body>
</html>