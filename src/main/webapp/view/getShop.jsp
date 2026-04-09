<%@ page import="java.sql.*, model.MyDBAccess,control.Shopfam,java.util.*,java.net.*,control.Shopfam2"
    language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean)session.getAttribute("adminFlg");
	if (login == null){
		pageContext.forward("/view/login.jsp");
	}

	// 取得した店舗データを格納する
	List<Shopfam> shopfamily = (List<Shopfam>)request.getAttribute("shopfam");
	List<Shopfam2> shopfamily2 = (List<Shopfam2>)request.getAttribute("shoppay");

	String shop = request.getParameter("shop");
	shop = new String(shop.getBytes("UTF-8"), "UTF-8"); // 文字コード変換

	// テーブル作成。従業員と給与は上段に表示する
	String tableHTML = "<table align=\"center\" cellpadding=\"3\">";
	tableHTML		+= "<tr bgcolor=\"000080\">"
					+  "<td><font color=\"white\">従業員</font></td>"
					+  "<td><font color=\"white\">給与</font></td></tr>";

	for(Shopfam family : shopfamily){
		tableHTML   += "<tr><td>" +family.employeeName + "</td>"
		            +  "<td>" + String.format("%,3d円", family.employeePay) + "</td></tr>";
	}

	// テーブル作成。売上、仕入れ、光熱費、テナント料、人件費、利益は下段に表示する
	String tableHTML2 = "<table align=\"center\" cellpadding=\"3\">";
	tableHTML2		+= "<tr bgcolor=\"000080\"><td><font color=\"white\">売上</font></td>"
					+  "<td><font color=\"white\">仕入れ</font></td> "
					+  "<td><font color=\"white\">光熱費</font></td> "
					+  "<td><font color=\"white\">テナント料</font></td> "
					+  "<td><font color=\"white\">人件費</font></td> "
					+  "<td><font color=\"white\">利益</font></td></tr>";

	// 各データを表示する。3桁ごとに","を挿入
	for(Shopfam2 family : shopfamily2){
		tableHTML2  += "<tr><td>" + String.format("%,3d円", family.shopSales) 	 + "</td>"
					+  "<td>" + String.format("%,3d円", family.shopPurchase) 	 + "</td>"
					+  "<td>" + String.format("%,3d円", family.shopUtilityCost)  + "</td>"
					+  "<td>" + String.format("%,3d円", family.shopRentCost) 	 + "</td>"
					+  "<td>" + String.format("%,3d円", family.shopPersonCost)   + "</td>"
					+  "<td>" + String.format("%,3d円", family.shopProfits) 	 + "</td></tr>";
	}
	tableHTML2 += "</table>";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />

	<title>ファミリーマート出店計画</title>

</head>
<body>

	<br>
	<div class ="center">
	    <h2><%= shop %>　詳細</h2>

		<br>
		<span class ="table2">
			<%= tableHTML %>
			<%= tableHTML2 %>
		</span>

		<br>
	    <input type="button" value="戻る" onclick="history.back(); return false;">
	</div>

</body>
</html>