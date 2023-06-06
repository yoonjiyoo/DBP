<%@ page contentType="text/html; charset=EUC-KR"%>
<HTML>
<head>
<title>수강신청 시스템 로그인</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
</head>
<BODY>
	<br>
	<div class="container col-9">
	<div class="mb-3">
	<table class="table table-primary">
		<tr>
			<td><div align="center" style="font-weight:bold;">아이디와 패스워드를 입력하세요
	</table>
	</div></div>
	<div class="container col-9">
	<table class="table table-bordered">
		<FORM method="post" action="login_verify.jsp">
			<tr>
				<td><div align="center" style="font-weight:bold;">아이디</div></td>
				<td class="container row justify-content-center"><div class="col-5">
						<input class="form-control" type="text" name="userID">
					</div></td>
			</tr>
			<tr>
				<td><div align="center" style="font-weight:bold;">패스워드</div></td>
				<td class="container row justify-content-center"><div class="col-5">
						<input class="form-control" type="password" name="userPassword">
					</div></td>
			</tr>
			<tr>
				<td colspan=2><div align="center">
						<INPUT class="btn btn-primary" TYPE="SUBMIT" NAME="Submit" VALUE="로그인"> <INPUT class="btn btn-secondary" TYPE="RESET" VALUE="취소">
					</div></td>
			</tr>
	</table>
	</div>
	</FORM>
</BODY>
</HTML>
