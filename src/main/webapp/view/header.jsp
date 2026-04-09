<%@ page contentType="text/html; charset=UTF-8" %>

<header class="header">
	<span class="sub_header3">
		<a href="#" onclick="moveUserList();">
		<img width="125" height="50" src="<%=request.getContextPath()%>/view/img/familymart.png"></a>
		<small>FamilyMart</small>
	</span>
	<span class="sub_header1">
		<form name="MyForm" method="POST" action="#" onsubmit="return flag;">
			<span style="margin-right: 20px;">
				<% Boolean adminFlg = (Boolean)session.getAttribute("adminFlg"); %>
				<% if(adminFlg){ %>
				<input type="submit" class="button" value="ユーザ管理画面" onclick="moveUserManagementList();">
				<% } %>
				<input type="submit" value="ユーザ画面" onclick="moveUserList();"">
				<input type="submit" value="商品一覧" onclick="moveShopItem()">
				<input type="submit" value="売り上げランキング" onclick="moveRank();">
				<input type="submit" value="都道府県別 店舗一覧" onclick="movePrefecture()">
			</span>
			
			<span class="sub_header2">
				<% out.print("ユーザ名 : " + session.getAttribute("userName")); %>
				<a style="margin-left: 20px;" class="button" onClick="logout();">
				<img style="margin-top: 15px;" src="<%= request.getContextPath() %>/view/img/153.142.124.217 (2).gif"></a>
			</span>
		</form>
	</span>
</header>