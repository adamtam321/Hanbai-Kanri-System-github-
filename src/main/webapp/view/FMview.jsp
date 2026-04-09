<%@
	page
	import="java.util.*, java.sql.*, java.net.*, model.MyDBAccess,control.Shopinfo"
	language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>

<%
	request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean)session.getAttribute("adminFlg");
	if (login == null){
		pageContext.forward("/view/login.jsp");
	}

	List<Shopinfo> shopname = (List<Shopinfo>)request.getAttribute("shopdata" );

	//リストの長さ判定
	int size = shopname.size();
	
	String edit = (String)request.getAttribute("edit");
	String shp  = (String)request.getAttribute("shp"); // 追加
	String skey = (String)request.getAttribute("skey");// 追加

	// 表示用のテーブル
	String aa = "";
	String editView;
	String shopType = "　出店済み　";

	if(edit.equals("true") ){
		editView="未出店にする";
	} else {
		editView="出店済みにする";
	}
	String pre = (String)request.getAttribute("pre");

	String tableHTML = "<table border=1 align=center>";
	tableHTML += "<tr bgcolor=\"000080\"><td><font color=\"white\">店舗名</font></td>"
			+ "<td><font color=\"white\">出店日</font></td>"
			+ "<td><font color=\"white\">住所</font></td>"
			+ "<td><font color=\"white\">店舗状況</font></td></tr>";

	if(shp != "" || "1".equals(skey)){	//店舗名を入力したかの判断
		if(shopname.size() > 0){
			for(Shopinfo shop : shopname){
				// テーブル用HTMLを作成
				tableHTML += "<tr><td><a href='GScontrol?shop=" +  shop.uriShopName + "' target='_self'>"
						+ shop.shopName
						+ "</td><td>" + shop.openDate + "</td>"
						+ "<td align=\"left\"><a href='https://www.google.co.jp/maps/place/" +  shop.uriShopAdr + "' target='_blank'>" + shop.shopAdr
						+ "</a></td><td><input type='button' value='"
						+ editView +"' align='right' onclick=\"data('"+shop.shopid+"','"+ pre +"','"+edit+"');\"></td></tr>";
			}
		tableHTML += "</table>";

		} else {
			tableHTML = "<div class=\"font\">条件に合った店舗が存在しません。</div>";
		}

	} else {
		tableHTML = "<div class=\"font\">店舗名が入力されていません。</div>";
	}
%>

<!DOCTYPE HTML>
<html lang="ja">
<title>FamilyMart出店計画</title>
<head>
<meta charset="UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />

<script type="text/javascript">

	function data(shop,pre,edit) {
		var shp = parent.document.getElementById("seatxt").value;//検索に入れた値を取得
		var skey = document.getElementById("hidden1").value;//都道府県か検索かを取得
		location.href="Delete" + "?shop=" + encodeURI(shop)+"&pre="+ encodeURI(pre)+ "&edit="+ encodeURI(edit)+ "&shp="+ encodeURI(shp)+ "&skey="+ encodeURI(skey);
	}

</script>

</head>
<body>
<br>
<input type="hidden" id="hidden1" value="<%= request.getAttribute("skey") %>">
<%-- 8月 FMcontrolからかFMsearchからか判断するため --%>
<div class="center">

	<span class = "table">
		<!-- 検索結果表示 -->
		検索結果：<%= size %>件
		<%= tableHTML %>
	</span>

</div>

</body>
</html>