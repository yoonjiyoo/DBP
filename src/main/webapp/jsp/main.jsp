<%@ page contentType="text/html; charset=EUC-KR"%>
<html>

<head>
<title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
 <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<%@ include file="top.jsp"%>
	<table width="75%" align="center" height="100%" class="content">

		<%
		if (session_id != null) {
		%>
		<tr>
			<td align="center"><%=session_id%>님 방문을 환영합니다.</td>
		</tr>
		
		<!-- 바로 수강신청 -->
		<tr>
    <td align="center">
        <form action="direct_registration.jsp" method="post">
            <label for="c_id">과목코드:</label>
            <input type="text" name="c_id" id="c_id" required>
            <label for="c_id_no">분반:</label>
            <input type="text" name="c_id_no" id="c_id_no" required>
            <input type="submit" value="빠른신청">
        </form>
    </td>
</tr>
		
		
		<%
		} else {
		%>
		<tr>
			<td align="center">로그인한 후 사용하세요.</td>
		</tr>
	
		<%
		}
		%>
	</table>
</body>
</html>
