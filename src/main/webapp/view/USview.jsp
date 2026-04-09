<%@ page contentType="text/html; charset=UTF-8" import="java.util.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.sql.SQLException"%>

<%
String un = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>

<html lang="ja">
<head>

<meta charset="UTF-8" />
<link href="<%=request.getContextPath()%>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />
<title>ユーザ管理画面 - FamilyMart</title>

<!-- ファビコンの設定 -->
<link rel="icon" href="/familymart_202602/view/img/familymart_square.png"/>


<script type="text/javascript">
	function logout(){
		if(confirm("ログアウトします。よろしいですか？")){
			document.MyForm.action = "<%=request.getContextPath()%>/FMlogout"
			document.MyForm.submit();
		} else {
			return;
		}
	}

	function go_access(num){
		var len = num;
		var str = "";
		var flg = 0;
		var alertFlg = true;

		for(i = 0; i < len ; i++) {
			if(document.MyForm2.elements['chkBox'+i].checked ) {
				if(confirm("ユーザID[" + document.MyForm2.elements['chkBox'+i].value + "]のアクセス権を変更しますか？") ) {
					flg++;
					str += "<input type=\"hidden\" name=\"userId\" value=\"";
					str += document.MyForm2.elements['chkBox'+i].value + "\">";
				}
				alertFlg = false;				//ここで、上記のアラートがならないように設定
			}
		}

		if(flg > 0) {
			document.MyForm2.actionId.value = 'access';
			document.getElementById("user").innerHTML= str;
			document.MyForm2.action = "<%=request.getContextPath()%>/USaccessControl"
			document.MyForm2.submit();
		}

		if(alertFlg != false) {				//上記と同じ不具合発生のため追加
			alert("チェックボックスが未入力です");
			alertFlg = true;
		}
	}

	function user_Regist(){
		document.MyForm2.actionId.value = 'userRegist';
		document.MyForm2.action = "<%=request.getContextPath()%>/view/USregist.jsp"
		document.MyForm2.submit();
	}

	function move(Command){
		document.MyForm2.actionId.value = "update";
		var values = Command.split(','); // , 区切;
		document.MyForm2.userId.value = values[0];
		document.MyForm2.username.value = values[1];
		document.MyForm2.password.value = values[2];
		document.MyForm2.action = "<%=request.getContextPath()%>/view/USregist.jsp"
		document.MyForm2.submit();
	}

	function deletes(num){
		var len = num ;
		var str = "";
		var flg = 0;
		var alertFlg = true;

		for(i = 0; i < len ; i++) {
			if (document.MyForm2.elements['chkBox'+i].checked) { //チェックが入っている時の処理
				if (confirm("ユーザID[" + document.MyForm2.elements['chkBox'+i].value + "]を削除しますか？")){
					flg++;
					str += "<input type=\"hidden\" name=\"userId\" value=\"";
					str += document.MyForm2.elements['chkBox'+i].value + "\">";
				}
				alertFlg = false;				//ここで、上記のアラートが鳴ってしまうので鳴らないように設定
			}
		}

		if(flg > 0) {
			document.MyForm2.actionId.value = 'delete';
			document.getElementById("user").innerHTML= str;
			document.MyForm2.action = "<%=request.getContextPath()%>/USaccessControl"
			document.MyForm2.submit();
		}

		if(alertFlg != false) {						//上記と同じ不具合発生のため追加
			alert("チェックボックスが未入力です");
			alertFlg = true;
		}
	}

	function moveShopItem(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/SHtest.jsp"
		document.MyForm.submit();		//↑ここの文で違うページに遷移するという意味になる
	}

	function movePrefecture(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMtest.jsp"
		document.MyForm.submit();
	}

	function moveRank(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMrank1.jsp"
		document.MyForm.submit();
	}

	function moveUserList(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/USgeneral.jsp"
		document.MyForm.submit();
	}

	function moveUserManagementList(){
		document.MyForm.action = "<%= request.getContextPath() %>/USshow"
		document.MyForm.submit();
	}

	//jspへの直アクセスを防ぐ
	<%request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean) session.getAttribute("adminFlg");
	if (login == null || login == false) {
	pageContext.forward("/view/login.jsp");
	}%>

</script>
</head>

<body>
<%@ include  file = "header.jsp"%>

	<div class="center">
		<%--ここから、曲を流すプログラム --%>
		<%
		boolean music = (boolean) session.getAttribute("music"); //7月新規
		String manege = (String) session.getAttribute("manegement");
		if (music == true) {
		%>
		<%-- ここのIF文でログイン後の1度きりという設定している --%>
		<audio
			src="<%=request.getContextPath()%>/view/mp3/ファミマ入店音square.mp3"
			autoplay></audio>
		<%-- 入店音を出す --%>
		<%
		session.setAttribute("music", false); //これ以降ここの音楽は流れないように設定
		session.setAttribute("manegement", "LOW");
		} else if (manege == "NORMAL") {
		%>
		<%--ここのIF文で一般画面から管理者画面に遷移したときに流す曲を設定している --%>
		<%--改善案 --%>
		<audio
			src="<%=request.getContextPath()%>/view/mp3/ファミマ入店音Normal.mp3"
			autoplay></audio>
		<%--同上 --%>
		<%
		session.setAttribute("manegement", "LOW"); //これで、次にユーザ管理画面に行かない限り音楽は流れない
		}
		%>
		<%--ここまで --%>
		
		<h2>&#8203;</h2>
		<br>
		<form name="MyForm2" method="POST"
			action="<%=request.getContextPath()%>/FMlogout">

			<div class="end">
				<a href="#" onclick=go_portal();><img
					src="<%=request.getContextPath()%>/view/img/familymart.png"></a>

				<h1>ユーザ管理画面</h1>
			</div>

			<br>
			<%-- テーブルの表示--%>
			<span class="table2">
				<table border="1" align="center">
					<tr>
						<th></th>
						<th>ユーザID</th>
						<th>ユーザ名</th>
						<th>権限</th>
					</tr>

					<%
					//ユーザ情報取得
					List<HashMap<String, String>> userList = (List<HashMap<String, String>>) request.getAttribute("userList");
					int num = 0;
					String kizo[] = new String[50]; //ここで、既存配列を作成している
					if (userList != null) {
						for (HashMap<String, String> userInfo : userList) {
							String user_name = userInfo.get("userName");
							String user_id = userInfo.get("userId");
							String password = userInfo.get("password");
							String user_admin = userInfo.get("userAdmin");

							kizo[num] = user_id; //IDを既存配列の中に代入している
					%>

					<%
					if (!(userInfo.get("userId").equals(session.getAttribute("userId")) || userInfo.get("userId").equals("admin"))) { //7月新規 ログインしている管理者ユーザ以外を表示する
					%>
					<td><input type="checkbox" name="chkBox<%=num%>"
						style="width: 17px; height: 17px;" value="<%=user_id%>"></td>
					<td><a href="#"
						onClick="move('<%=user_id%>,<%=user_name%>,<%=password%>');"><%=user_id%></a></td>

					<td><%=user_name%></td>

					<td>
						<%
						if (user_admin.equals("true")) {
							out.print("管理者");
						} else {
							out.print("一般");
						}
						%>
					</td>
					</tr>
					<!-- 8月　開始タグはないが、入れないとレイアウトが壊れる -->
					<%
					num++;

					} else { //7月　ログインしている管理者ユーザは、チェックボックスに入力させない（自身で削除不可、アドレス変更不可)
					//(注　ただし、チェックボックスが本当に押せないのか判別がしづらいとのご指摘を受けました。不可を白色ではなく灰色にできないのかなどの助言有)
					%>
					<td><input type="hidden" name="checkItem2" value="0">
						<input type="checkbox" name="chkBox<%=num%>"
						style="width: 17px; height: 17px;" disabled='disabled'
						value="<%=user_id%>"> <label for='checkoff'></label></td>

					<td><a href="#"
						onClick="move('<%=user_id%>,<%=user_name%>,<%=password%>');"><%=user_id%></a></td>
					<td><%=user_name%></td>

					<td>
						<%
						if (user_admin.equals("true")) {
							out.print("管理者");
						} else {
							out.print("一般");
						}
						%>
					</td>
					</tr>
					<!-- 8月　開始タグはないが、入れないとレイアウトが壊れる -->
					<%
					num++;
					}
					}
					session.setAttribute("kizo", kizo); //7月　ここで「既存」配列をセッション内に入れる
					}
					%>

				</table>
			</span>

			<table>

				<div class="footer1">
					<input type="button" value="ユーザ削除" onClick="deletes(<%=num%>);">
					<%--7月　現在削除ボタンや更新ボタンを押したあとにブラウザバックを押してまた同じ動作をすると --%>
					<input type="button" name="inq_btn" value="アクセス権変更"
						onClick="go_access(<%=num%>);"><br>
					<%--処理はしないが動作できてしまうバグ。IF文でアラートを出すように設定すればいけるかもしれない --%>
					<input type="button" value="ユーザ登録画面へ" onClick="user_Regist();">

					<br>
					<div id="user"></div>

					<input type="hidden" name="actionId" value=""> <input
						type="hidden" name="userId" value=""> <input type="hidden"
						name="username" value=""> <input type="hidden"
						name="password" value="">

				</div>
			</table>

		</form>
		<h2>&#8203;</h2>
	</div>

<%@ include  file = "footer.jsp"%>
</body>
</html>