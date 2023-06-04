<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.util.Calendar"%>

<%--과목코드와 분반을 분리해서 신청여부를 확인할 수 있도록 하기 위해 추가한 부분입니다--%>
<%!public class EnrolledCourse {
		private String c_id;
		private int c_id_no;

		public EnrolledCourse(String c_id, int c_id_no) {
			this.c_id = c_id;
			this.c_id_no = c_id_no;
		}

		public String getC_id() {
			return c_id;
		}

		public int getC_id_no() {
			return c_id_no;
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null || getClass() != obj.getClass())
				return false;

			EnrolledCourse that = (EnrolledCourse) obj;

			if (c_id_no != that.c_id_no)
				return false;
			return c_id != null ? c_id.equals(that.c_id) && c_id_no == that.c_id_no : that.c_id == null;
		}

		@Override
		public int hashCode() {
			int result = c_id != null ? c_id.hashCode() : 0;
			result = 31 * result + c_id_no;
			return result;
		}
	}%>
<%--과목코드와 분반을 분리해서 신청여부를 확인할 수 있도록 하기 위해 추가한 부분입니다--%>

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
			<th>최대인원</th>
			<th>신청인원</th>
			<th>학과</th>
			<th>대기인원</th>
			<th>신청</th>
			<th>즐겨찾기</th>
			<th>연도</th>
			<th>학기</th>
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

		ArrayList<EnrolledCourse> enrolledCourses = new ArrayList<>();
		String selectEnrolledCoursesSQL = "select c_id, c_id_no from enroll where s_id='" + session_id + "'";
		ResultSet enrolledCoursesResultSet = stmt.executeQuery(selectEnrolledCoursesSQL);
		while (enrolledCoursesResultSet.next()) {
			String enrolledCourseId = enrolledCoursesResultSet.getString("c_id");
			int enrolledCourseNo = enrolledCoursesResultSet.getInt("c_id_no");
			enrolledCourses.add(new EnrolledCourse(enrolledCourseId, enrolledCourseNo));
		}
		enrolledCoursesResultSet.close();

		ArrayList<EnrolledCourse> starCourses = new ArrayList<EnrolledCourse>(); // 과목의 ID와 분반번호 모두를 저장할 수 있도록 타입을 EnrolledCourse로 변경
		String selectStarCoursesSQL = "select c_id, c_id_no from star where s_id='" + session_id + "'"; // 분반번호를 불러옴
		ResultSet starCoursesResultSet = stmt.executeQuery(selectStarCoursesSQL);
		while (starCoursesResultSet.next()) {
			String starCoursesId = starCoursesResultSet.getString("c_id");
			int starCoursesNo = starCoursesResultSet.getInt("c_id_no"); // 분반번호를 가져옴
			starCourses.add(new EnrolledCourse(starCoursesId, starCoursesNo)); // 과목의 ID와 분반번호를 모두 저장
		}
		starCoursesResultSet.close();

		ArrayList<EnrolledCourse> waitCourses = new ArrayList<EnrolledCourse>();
		String selectWaitCoursesSQL = "select c_id, c_id_no from wait where s_id='" + session_id + "'";
		ResultSet waitCoursesResultSet = stmt.executeQuery(selectWaitCoursesSQL);
		while (waitCoursesResultSet.next()) {
			String waitCoursesId = waitCoursesResultSet.getString("c_id");
			int waitCoursesNo = waitCoursesResultSet.getInt("c_id_no");
			waitCourses.add(new EnrolledCourse(waitCoursesId, waitCoursesNo));
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

			int currentYear = Calendar.getInstance().get(Calendar.YEAR);
			int currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1; // Month is zero-based
			int currentSemester = (currentMonth >= 5 && currentMonth <= 10) ? 2 : 1;

			if (currentMonth >= 11) {
			currentYear += 1;
			currentSemester = 1;
			}

			mySQL = "select c_id,c_name,c_id_no,c_unit,c_max,c_app,c_major,c_wait,c_year,c_sem from course " + "where c_year="
					+ currentYear + " and c_sem=" + currentSemester
					+ (selectedMajor == null || selectedMajor.equals("") ? "" : " and c_major='" + selectedMajor + "'");
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
				int c_year = myResultSet.getInt("c_year");
				int c_sem = myResultSet.getInt("c_sem");

				boolean isEnrolled = enrolledCourses.contains(new EnrolledCourse(c_id, c_id_no));
				boolean isStarred = starCourses.contains(new EnrolledCourse(c_id, c_id_no)); // 과목의 ID와 분반번호를 모두 비교하여 즐겨찾기를 체크
				boolean isWaitlisted = waitCourses.contains(new EnrolledCourse(c_id, c_id_no));
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
					%> <a href="wait_cancel.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">대기취소</a>
					<%
					} else if (isFull) {
					%> <a href="wait_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">대기하기</a>
					<%
					} else {
					%> <a href="insert_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">신청</a>
					<%
					}
					%>
				</td>
				<td align="center">
					<%
					if (isStarred) {
					%> <!-- 과목의 ID와 분반번호를 모두 비교하여 즐겨찾기를 체크 -->
					즐겨찾기 <%
 } else {
 %> <a
					href="star_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">즐겨찾기</a>
					<!-- 분반번호를 함께 보냄 --> <%
 }
 %>
				</td>
				<td align="center"><%=c_year%></td>
				<td align="center"><%=c_sem%></td>
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
