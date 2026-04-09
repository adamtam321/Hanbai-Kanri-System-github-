<%@ page import="java.util.*,java.net.*,java.sql.*, model.MyDBAccess,control.Itemfam"
	language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "jakarta.servlet.http.HttpSession" %>

<%
	request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean)session.getAttribute("adminFlg");

	if (login == null){
		pageContext.forward("/view/login.jsp");
	}

	
	// 取得した商品データを格納する
	List<Itemfam>itemdata = (List<Itemfam>)request.getAttribute("getitem");

	String gen  = (String)request.getAttribute("gen");
	String item = request.getParameter("item");
	item = new String(item.getBytes("UTF-8"), "UTF-8");

	// テーブル作成
	String itemHTML = "<table align=\"center\" cellpadding=\"3\">";

	// 商品名、販売会社は上段に配置する
	itemHTML		+= "<tr align=\"center\" bgcolor=\"008000\">"
					+  "<td><font color=\"white\">商品名</font></td>"
					+  "<td><font color=\"white\">販売会社</font></td></tr>";

	for(Itemfam data : itemdata){
		itemHTML	+= "<td>" + data.ItemName +"</td>"
					+  "<td>" + data.maker +"</td></tr>";
	}

	// ジャンル、販売日、価格は下段に配置する
	itemHTML	 += "<tr align=\"center\" bgcolor=\"008000\"><td><font color=\"white\">ジャンル</font></td>"
				 +  "<td><font color=\"white\">販売日</font></td>"
				 +  "<td><font color=\"white\">価格</font></td></tr>";

	for(Itemfam data : itemdata){
		String displayDay = (data.day != null) ? data.day.toString().replace("-", "/") : "";
		itemHTML += "<tr><td>" + data.genre + "</td>"
				 +  "<td>" + displayDay + "</td>"
				 +  "<td>" + String.format("%,3d", data.price) +" 円</td></tr>";
	}

	itemHTML+= "</table>";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />

<title>商品詳細表示</title>

</head>
<body>
<br>
<div class ="center">

	<h2>商品 詳細</h2>

	<!-- 8月　商品画像とPOP画像のレイアウト。CSS(W0051.css)による座標指定で画像を重ねて表示する -->
	<div class="relative">
		
			
		<% for(Itemfam data : itemdata){ %>
	<%
	// Naming Convention（命名規則）
	String img = data.genre + "_1.png";
	%>
	<img src="<%= request.getContextPath() + "/view/img/item/" + img %>" width="150" height="150">
	<% } %>

		<!-- 8月　新商品判定によって、新発売か発売予定のどちらを表示するかを選択する。-->
		<% for(Itemfam data : itemdata){%>
			<% if(data.newItemJudge == 0) { %>
				<img src="./view/img/new_image.png" width="120" height="90" class="absolute">
			<% } else if (data.newItemJudge == 1) {%>
				<img src="./view/img/coming_soon.png" width="120" height="90" class="absolute">
			<% } %>
		<% } %>
	</div>

	<span class ="table2">
		<%= itemHTML %>
	</span>

	<input type="button" value="戻る"onClick="history.back(); return false;">

</div>
</body>
</html>