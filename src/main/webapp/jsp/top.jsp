<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<head>
    <title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
</head>

<%
String session_id = (String) session.getAttribute("user");
String log;
if (session_id == null)
	log = "<a href=\"login.jsp\" style=\"text-decoration: none;\">로그인</a>";
else
	log = "<a href=\"logout.jsp\" style=\"text-decoration: none;\">로그아웃</a>";
%><br>
<div class="container">
<div class="row justify-content-center">
<div class="col-10 mx-auto">
<table class="table table-primary mb-3 ">
	<tr>
		<td align="center"><b><%=log%></b></td>
		<td align="center"><b><a href="update.jsp" style="text-decoration: none;">사용자 정보 수정</b></td>
		<td align="center"><b><a href="insert.jsp" style="text-decoration: none;">수강신청 입력</b></td>
		<td align="center"><b><a href="delete.jsp" style="text-decoration: none;">수강신청 삭제</b></td>
		<td align="center"><b><a href="select.jsp" style="text-decoration: none;">수강신청 조회</b></td>
		<td align="center"><b><a href="star.jsp" style="text-decoration: none;">즐겨찾기 과목 조회</b></td>
		<td align="center"><b><a href="main.jsp" style="text-decoration: none;"> ◈ </b></td>
	</tr>
</table>
</div></div></div>
