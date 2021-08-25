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
<title>�ҷ�ǰ�� ������_login</title>
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
		<h2>��ȭ�� ��/�ҷ� ���� ���α׷�</h2>
	</div>

	<%
	try {
		String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
		String uid = "testuser";
		String pass = "testuser";
		String sql = "SELECT * FROM DEFECTIVE";

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		Class.forName("oracle.jdbc.driver.OracleDriver");
		System.out.println("����̹� �ε� ����");
		conn = DriverManager.getConnection(url, uid, pass);
		System.out.println("���� ����");
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);

		String num = null;
	%>
	<form action="defectiveDelete.jsp" name="frm"
		onsubmit="return checkboxCheck();">
		<div class="table-wrapper">
			<table id="table" class="list">
				<thead>
					<tr>
						<td colspan="5" id="desc"
							style="border: white; color: white; text-align: left">�� ������ �ҷ�ǰ ��� �Դϴ�. ����ų �ҷ�ǰ ����� �����ϼ���.</td>
					</tr>
					<tr>
						<th id="checkboxtbl">üũ</th>
						<th>ǰ��</th>
						<th>input �ð�</th>
						<th>output �ð�</th>
						<th>��ǰ ��ġ(L/R)</th>
					</tr>
				</thead>

				<tbody>
					<%
					while (rs.next()) {

						out.println("<tr style=\"background-color:white\">");
					%>
					<td><input type="checkbox" name="chk" id="chk"
						value="<%=rs.getString("PROD_NO")%>" /></td>
					<%
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
			<input type="submit" value="���" class="inbutton" onclick="hey();" />
			&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <input type="button" value="���� ȭ��"
				class="inbutton" onclick="location.href='dashboard.jsp'" />
		</div>
	</form>

	<script type="text/javascript">
		function checkboxCheck() {

			var count = 0;
			var table = document.getElementById("table");
			var totalrowcount = table.rows.length;
			var tbody = table.tBodies[0].rows.length;
			for (var i = 0; i < tbody; i++) {
				var test = table.tBodies[0].rows;
				var temp = test[i].getElementsByTagName("td");
				var temp2 = temp[0].getElementsByTagName("input");
				var last = temp2[0].checked;
				//var a = document.getElementById('chk').checked;
				if (last == false) {
					count++;
				}
			}
			if (count == tbody) {
				alert("���õ� ǰ���� �����ϴ�.");
				return false;
			}
			return true;
		}
	</script>

	<%
	} catch (Exception e) {
	e.printStackTrace();
	}
	%>
</body>
</html>