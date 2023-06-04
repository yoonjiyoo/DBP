<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<head>
    <title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<%
String session_id = (String) session.getAttribute("user");
String log;
if (session_id == null)
	log = "<a href=login.jsp>로그인</a>";
else
	log = "<a href=logout.jsp>로그아웃</a>";
%>
<table width="75%" align="center" bgcolor="#FFFF99" border class="menu">

	<tr>
		<td align="center"><b><%=log%></b></td>
		<td align="center"><b><a href="update.jsp">사용자 정보 수정</b></td>
		<td align="center"><b><a href="insert.jsp">수강신청 입력</b></td>
		<td align="center"><b><a href="delete.jsp">수강신청 삭제</b></td>
		<td align="center"><b><a href="select.jsp">수강신청 조회</b></td>
		<td align="center"><b><a href="star.jsp">즐겨찾기 과목 조회</b></td>
	</tr>
</table>
