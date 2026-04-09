<%@ page import="java.sql.*, java.net.*, model.MyDBAccess"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import = "jakarta.servlet.http.HttpSession" %>

<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html >
<html lang="ja">
<head>
<meta charset="UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />
<title>ユーザ編集画面 - FamilyMart</title>

<!-- ファビコンの設定 -->
<link rel="icon" href="/familymart_202602/view/img/familymart_square.png"/>

<script type="text/javascript">

<% if((Boolean)session.getAttribute("isRegisteredUserId")){	//登録時同じIDを使っている人がいた場合のアラートのプログラム
	session.setAttribute("isRegisteredUserId", false);
%>
	alert("このIDは使われています。違うIDでお試しください。");
<% } %>

<%
	String adminuserId	= (String)session.getAttribute("userId");
	String updateFlg	= (String)request.getAttribute("updateFlg");
	String actionId		= request.getParameter("actionId");
	String[] kizou		= (String[])session.getAttribute("kizo");			//7月追加	既存のIDかどうかを判断する変数
%>

<%
	String user_id 	 = "";
	String user_name = "";
	String disabled  = "";												//7月追加 更新時書き込み不可に使う変数
	String passWord  = "";

	if(actionId.equals("update")){
		user_id = request.getParameter("userId");
		user_name = request.getParameter("username");
		session.setAttribute("updateId", user_id);
		disabled = "disabled";							 //7月新規 更新時書き込み不可に変更
	}

	String change = "";

	if(actionId.equals("update")) {
		change  = "更新";
    } else {
		change  = "登録";
	}
%>
	var change = "<%=change%>";
	var flag = false;

	function logout() {
		if(confirm("ログアウトします。よろしいですか？")){
			flag = true;
			document.MyForm.action = "<%= request.getContextPath() %>/FMlogout";
			document.MyForm.submit();
		} else {
			return;
		}
	}

	function Registration(actionId){
		// 8月　エラーメッセージが一番上のものしか表示されていなかったので、エラー項目をすべて表示するように修正
		var errorUserID 		= "";
		var errorUserName 		= "";
		var errorUserPass 		= "";
		var errorCheckPass		= "";
		var errorCase 			= 0;

		if(MyForm.userId.value == "") {
			errorUserID		= "[ユーザID] ";
			errorCase		= 1;
		}
		if(MyForm.username.value == "") {
			errorUserName	= "[ユーザ名] ";
			errorCase 		= 1;
		}
		if(MyForm.passWord[0].value == "") {
			errorUserPass 	= "[パスワード] ";
			errorCase 		= 1;
		}
		if(MyForm.conPassword[0].value == "") {
			errorCheckPass 	= "[確認パスワード]";
			errorCase 		= 1;
		}
		// 8月　上述のエラー項目を洗い出し、表示したらその時点で返す
		if(errorCase == 1){
			alert(errorUserID + errorUserName + errorUserPass + errorCheckPass + "が未入力です。");
			return;
		}

		//パスワードが一致していなかった場合
		if(document.MyForm.passWord[0].value != document.MyForm.conPassword[0].value){
			alert("パスワードが一致していません");
			return;
		}

		if(!MyForm.userId.value.match(/^[0-9A-Za-z\u3041-\u3096\u30A1-\u30FA\u4E00-\u9FFF]+$/)){
			alert('ユーザIDに全半角英数字以外の文字が含まれています');
			return;
			}
		
		if(!MyForm.username.value.match(/^[0-9A-Za-z\u3041-\u3096\u30A1-\u30FA\u4E00-\u9FFF]+$/)){
			alert('ユーザ名に全半角英数字以外の文字が含まれています');
			return;
			}
		
if (change ==="登録"){
	if(confirm("ユーザID[" +MyForm.userId.value + "]を作成します。よろしいですか？")){
		document.MyForm.actionId.value = actionId;
		document.MyForm.action = "<%= request.getContextPath() %>/USregist";
		document.MyForm.submit();
	} else {
		return;
	}
} else {
	if(confirm("ユーザID[" +MyForm.userId.value + "]を更新します。よろしいですか？")){
		document.MyForm.actionId.value = actionId;
		document.MyForm.action = "<%= request.getContextPath() %>/USregist";
		document.MyForm.submit();
	} else {
		return;
	}
}

	}

	function history_back(){
		document.MyForm.action = "<%= request.getContextPath()%>/USshow";
		document.MyForm.submit();
	}

</script>
</head>

<body> <%--7月追加 --%>
<br>
<div class="center">
<form name="MyForm" method="POST" action="#" onsubmit="return false;" onkeyup="if(event.keyCode == 13){Registration('<%= actionId %>');}">
									<%--ここで、Enter keyを押した場合の処理を行っている。キャンセルすると送信されない。↑ --%>
	<div class="button-panel">
		<% out.print("ユーザ名 : " + session.getAttribute("userName"));%>
		<a style="margin-left: 20px" class="button" onClick="logout();">
		<img src="<%= request.getContextPath() %>/view/img/153.142.124.217 (2).gif"></a>
	</div>

	<div class="button1">
		<input type="submit" class="button" value="戻る" onclick="history_back();">
	</div>
	<%
		String userid = (String)request.getAttribute("userId");
		String userName = (String)request.getAttribute("userName");
	%>
	<div class="end">
		<img src="<%= request.getContextPath() %>/view/img/familymart.png">
		<h1 class="regist">ユーザ<%= change %>画面</h1>
	</div>

<br>
<div class="center">
	<table border="1" align="center" style="table-layout:fixed;">
		<tr>
			<td align="left">ユーザID：</td>
			<td><input pattern=^[0-9A-Za-z\u3041-\u3096\u30A1-\u30FA\u4E00-\u9FFF]+$ 
			title="英数字、ひらがな、カタカナ、漢字のみで入力してください" 
			oninvalid="this.setCustomValidity('英数字または日本語で入力してください')" type="text"  name="userId"
				style="ime-mode:disabled" size="40" maxlength="8" required  value="<%= user_id %>" <%= disabled %> />
			</td>
		</tr>

		<tr>
			<td align="left">ユーザ名：</td>
			<td><input pattern=^[0-9A-Za-z\u3041-\u3096\u30A1-\u30FA\u4E00-\u9FFF]+$ 
			title="英数字、ひらがな、カタカナ、漢字のみで入力してください" 
			oninvalid="this.setCustomValidity('英数字または日本語で入力してください')" type="text" id="username" name="username"
				style="ime-mode:disabled" size="40" maxlength="8"required value="<%= user_name %>">
			</td>
		</tr>

		<% if(actionId.equals("userRegist")){ %>
			<tr><td align="left">パスワード(半角文字)：</td>
				<td><input pattern=^([a-zA-Z0-9]{8,})$ type="password" name="passWord"
					style="ime-mode:disabled" size="40" maxlength="40" required ></td></tr>
			<tr><td align="left">確認用パスワード：</td>
				<td><input pattern=^([a-zA-Z0-9]{8,})$ type="password" name="conPassword"
					style="ime-mode:disabled" size="40" maxlength="40" required></td></tr>
		<% } %>
	</table>
</div>

	<div>
		<input type ="hidden" name ="actionId"	  value ="<%= actionId %>">
		<input type ="hidden" name ="passWord"	  value ="dummy">
		<input type ="hidden" name ="conPassword" value ="dummy">
		<input type ="hidden" name ="passWord"	  value ="dummy2">
		<input type ="hidden" name ="conPassword" value ="dummy2">
		<input type ="submit" onClick="Registration('<%= actionId %>')" value = "<%= change %>" title = "<%= change %>" autofocus>
	</div>
	</form>
	
	<h2>&#8203;</h2>
</div>

<%@ include  file = "footer.jsp"%>
</body>
</html>