<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<link href="<%=request.getContextPath()%>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />
<title>従業員用ログイン画面 - FamilyMart</title>

<!-- ファビコンの設定 -->
<link rel="icon" href="/familymart_202602/view/img/familymart_square.png"/>

<script type="text/javascript">
	window.onload = function() {
	adialog();
	}

	// ここから
	history.pushState(null, null, null);
	window.addEventListener("popstate", function() {	//7月　戻るボタンの使用を禁止（注：現在ここのプログラムがあるせいでログイン後に何回かページ遷移して
	    history.pushState(null, null, null);			//ログインページまでブラウザバックすると、エラーが出されます。理由はここのプログラムのせいだと考えています。
	});
	// ここまで

	// ログイン時の処理。エラーの条件分岐など
	function login(){
		var userId	 	= document.myForm.userId.value;
		var password	= document.myForm.password.value;

		if(userId == "" || password == ""){
			alert('ユーザID または パスワード が入力されていません');
		} else if(!userId.match(/^[0-9A-Za-z\u3041-\u3096\u30A1-\u30FA\u4E00-\u9FFF]+$/)) {
			alert('英数字または日本語で入力してください');
		} else { // 8月　上述のミスでもリクエストを送信し、二重にエラー文が表示されていたため、分岐の仕方を修正
			document.myForm.action = "<%=request.getContextPath()%>/FMlogin"
			document.myForm.submit();
		}
	}

	// 入力されたIDやパスワードに誤りがあった場合にアラートダイアログを表示する
	// 8月　現在、IDとパスワードどちらも誤った場合にエラーログが表示されない問題…未解決
	function adialog(){
		var disp = <%=request.getAttribute("disp_alert")%>;

		if(1===disp){
			alert('ユーザID または パスワード に誤りがあります');
			request.setAttribute("disp_alert", 0); // これ以降、エラーアラートが出ないように設定
		}
	}
</script>
</head>
<body>
	<div class="center">
		<h1>従業員用ログイン画面</h1>
		<a href="#" onclick=go_portal();><img
			src="<%=request.getContextPath()%>/view/img/familymart.png"></a>

		<div class="footer1">
			<form name="myForm" method="POST" action="#">
				<label for="email">ユーザID</label> <input type="text" maxlength="8"
					name="userId" placeholder="User ID" id ="userid"> <br>
				<label	for="password">　　　パスワード</label> <input type="password" minlength="2"
					maxlength="40" name="password" placeholder="Password" id ="password">
					<button type="button" id="view">表示　</button>
				<div class="footer1">
					<input type="button" class="button" title="Login" value="ログイン"
						onclick="login();">
				</div>

			</form>
		</div>

		<div class="footer2">FamilyMart</div>

	</div>
	
	<%@ include  file = "footer.jsp"%>

<script>
	const view = document.getElementById("view");
	view.addEventListener("click", function() {
		const hidden = password.type === "password"
		password.type = hidden ? "text" : "password";
		view.textContent = hidden ? "非表示" : "表示　";
	});

	const useridInput =document.getElementById("userid");
	const passwordInput =document.getElementById("password");

	useridInput.addEventListener("keydown", function(event){
		if(event.key === "Enter"){
			event.preventDefault();
			passwordInput.focus();
			}
	});

	passwordInput.addEventListener("keydown", function(event){
		if(event.key === "Enter"){
			event.preventDefault();
			login();
			}
	});
</script>
</body>
</html>