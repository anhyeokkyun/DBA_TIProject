<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%
request.setCharacterEncoding("EUC-KR");
%>
<jsp:useBean id="itemBean" class="com.mission.javabeans.ItemBean" />
<jsp:setProperty property="*" name="itemBean" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>불량품목 페이지_prelog</title>
</head>

<style>
body {
	margin-top: 200px;
	text-align: center;
	margin: 0 auto;
	background-color: #515F6D;
}

h2 {
	font-size: 40px;
	color: white;
	margin-bottom: 50px;
	margin-top: 100px;
}

table {
	backgroud-color: white;
	margin: 0 auto;
	width: 100%;
}

td {
	color: black;
	backgroud-color: white;
}

.record {
	background-color: white;
	text-align: center;
}

th {
	color: black;
	background-color: #EAEAEA;
	margin-top: 50px;
}

.inbutton {
	margin-top: 50px;
	background-color: #3498DB;
	font-size: medium;
	color: white;
	font-weight: bold;
}

#checkboxtbl {
	width: 50px;
}

#desc {
	padding-bottom: 25px;
	font-size: 12px;
	font-weight: bold;
}

.table-wrapper {
	height: 450px;
	width: 60%;
	overflow: auto;
	margin: 0 auto;
	text-align: center;
}
</style>

<body>
	<div id="wrap" align="center">
		<h2>열화상 양/불량 판정 프로그램</h2>
	</div>

	<%
	try {
		String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
		String uid = "admin";
		String pass = "admin";
		String sql = "SELECT * FROM DEFECTIVE";

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Class.forName("oracle.jdbc.driver.OracleDriver");
		System.out.println("드라이버 로딩 성공");
		conn = DriverManager.getConnection(url, uid, pass);
		System.out.println("연결 성공");
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);

		String num = null;
	%>
	<form name="frm" action="passcheck.jsp">
		<div class="table-wrapper">
			<table id="table" class="list">
				<thead>
					<tr>
						<td colspan="5" id="desc"
							style="border: white; color: white; text-align: left">※ 감지된 불량품 목록 입니다. 폐기시킬 불량품 목록을 선택하세요.</td>
					</tr>
					<tr>
						<td colspan="5" id="desc"
							style="border: white; color: white; text-align: left">※ 삭제하기
							위해서는 관리자 비밀번호 인증이 필요합니다.</td>
					</tr>
					<tr>
						<th>품번</th>
						<th>input 시간</th>
						<th>output 시간</th>
						<th>제품 위치(L/R)</th>
					</tr>
				</thead>

				<tbody>
					<%
					while (rs.next()) {

						//num = rs.getString("PROD_NO");
						out.println("<tr style=\"background-color:white\">");
						out.println("<td>" + rs.getString("PROD_NO") + "</td>");
						out.println("<td>" + rs.getString("INP_TIME") + "</td>");
						out.println("<td>" + rs.getString("OUT_TIME") + "</td>");
						out.println("<td>" + rs.getString("LR_LABEL") + "</td>");
						out.println("</tr>");

					}

					String[] chbox = request.getParameterValues("chk");
					%>
				</tbody>
			</table>
		</div>
		<div style="width: 60%; text-align: right; margin: 0 auto;">
			<input type="submit" value="인증" class="inbutton" /> &nbsp; &nbsp;
			&nbsp; &nbsp; &nbsp; <input type="button" value="메인 화면"
				class="inbutton" onclick="location.href='dashboard.jsp'" />
		</div>
	</form>

	<%
	} catch (Exception e) {
	e.printStackTrace();
	}
	%>
</body>
</html>
