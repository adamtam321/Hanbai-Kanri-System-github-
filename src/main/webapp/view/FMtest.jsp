<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import = "java.util.HashMap"%>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />
<title>都道府県別 店舗一覧 - FamilyMart</title>

<!-- ファビコンの設定 -->
<link rel="icon" href="img/familymart_square.png"/>

<script type="text/javascript">
<%
	request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean)session.getAttribute("adminFlg");
	if(login == null){
		pageContext.forward("/view/login.jsp");
	}
%>
	// 8月　このページで画面遷移を行わないように変更。画面遷移はインラインフレームで行う。
	// こちらはプルダウン選択を反映する。
	function send() {
		var idx = document.getElementById("pre").selectedIndex;
		var text = document.getElementById("pre").options[idx].text; // 表示テキスト

		// 8月　edit1の状態から判別
		radiobtn1 = document.getElementById("edit2");
		if(radiobtn1.checked) {
			edit = true;
		} else {
			edit = false;
		}

		// 8月　インラインフレームのページ遷移を行う。
		waku.location = "<%= request.getContextPath() %>\/FMcontrol?pre=" + encodeURI(text)
																		+ "&edit=" + encodeURI(edit);
	}

	// 8月　検索用の画面遷移をインラインフレームに渡す。上述のコードとだいたい同じ。
	function search(){
		var shp = document.getElementById("seatxt").value;

		// 8月　edit2の状態から判別
		radiobtn2 = document.getElementById("edit2");
		if(radiobtn2.checked) {
			edit = true;
		} else {
			edit = false;
		}

		waku.location = "<%= request.getContextPath() %>\/FMsearch?shp=" + encodeURI(shp)
																		+ "&edit=" + encodeURI(edit);
	}

	// ログアウト処理
	var flag = false;
	function logout() {
		if(confirm("ログアウトします。よろしいですか？")){
			flag = true;
			document.MyForm.action = "<%= request.getContextPath() %>/FMlogout"
			document.MyForm.submit();
		} else {
			return;
		}
	}

	function moveUserList(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/USgeneral.jsp"
		document.MyForm.submit();
	}

	function movePrefecture(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMtest.jsp"
		document.MyForm.submit();
	}

	function moveShopItem(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/SHtest.jsp"
		document.MyForm.submit();		//↑ここの文で違うページに遷移するという意味になる
	}

	function moveRank(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMrank1.jsp"
		document.MyForm.submit();
	}
	
	function moveUserManagementList(){
		document.MyForm.action = "<%= request.getContextPath() %>/USshow"
		document.MyForm.submit();
	}
	
	
	// 地方 → 都道府県
	const areaMap = {
		"北海道": ["北海道"],
		"東北": ["青森県","岩手県","宮城県","秋田県","山形県","福島県"],
		"関東": ["東京都","神奈川県","千葉県","埼玉県","茨城県","栃木県","群馬県"],
		"中部": ["新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県"],
		"近畿": ["大阪府","京都府","兵庫県","奈良県","滋賀県","和歌山県"],
		"中国": ["鳥取県","島根県","岡山県","広島県","山口県"],
		"四国": ["徳島県","香川県","愛媛県","高知県"],
		"九州・沖縄": ["福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
	};
	function Items(ischecked){
		if(ischecked == true){
			// チェックが入っていたら有効化
			document.getElementById("pre").disabled = false;
		    document.getElementById("area").disabled = false;
	        document.getElementById("seatxt").disabled = true;
		} else {
			// チェックが入っていなかったら無効化
	    	document.getElementById("area").disabled = true;
			document.getElementById("pre").disabled = true;
		}
		var area = document.getElementById("area").value;
		var pre = document.getElementById("pre");

		// reset
		pre.length = 0;
		pre.options[0] = new Option("都道府県を選択", "");

		if(areaMap[area]){
			areaMap[area].forEach(function(pref, i){
				pre.options[i+1] = new Option(pref, pref);
			});
		}
	}

	function Connecttext(ischecked ) {
		    let seatxt = document.getElementById("seatxt");
		    let area   = document.getElementById("area");
		    let pre    = document.getElementById("pre");

		    if(ischecked){
		        //  店舗名検索
		        seatxt.disabled = false;
		        area.disabled = true;
		        pre.disabled  = true;
		    } else {
		        seatxt.disabled = true;
		    }
		}

	function SearchGenreSelect(){
		radiobtn1 = document.getElementById("label1");
		radiobtn2 = document.getElementById("label2")
		if(radiobtn1.checked){
			send();
		}
		if(radiobtn2.checked){
			search();
		}
	}

	//入力後Enterを押したら検索結果表示
	document.addEventListener('DOMContentLoaded', pageLoad);

	function pageLoad(){
		var textbox = document.getElementById('seatxt');

		if(textbox){
			textbox.addEventListener('keydown', enterKeyPress);
		}
	}

	function enterKeyPress(event){
		if(event.key === 'Enter'){
			search();
			}
		}
</script>
</head>

<body>
<%@ include  file = "header.jsp"%>

<br>
<div class="center">

	<div class="end">
		<h1>都道府県別 店舗一覧</h1>
	</div>

	<br><br>
	<div class="select">
		<input id="edit1" name="edit" type="radio" checked/>
		<label for="edit1">出店予定店舗の表示</label><br />
		<input id="edit2" name="edit" type="radio" />
		<label for="edit2">出店済み店舗の表示</label><br />

		<br>
		<form name="f1" action="#" onsubmit="return false">
		<input id="label1" type="radio" name="radio1"
			onclick="Items(this.checked);seatxt.disabled=true;seatxt.value=null;seatxt.placeholder='入力できません'">				
		<label for="label1">都道府県検索</label>
		<input id="label2" type="radio" name="radio1"
			onclick="Connecttext(this.checked);seatxt.placeholder='店舗名で検索'">
		<label for="label2">店舗名検索</label><br>				
		<select id="area" onchange="Items(true)" disabled>		
			<option value="">地方を選択</option>
			<option value="北海道">北海道</option>
			<option value="東北">東北</option>
			<option value="関東">関東</option>
			<option value="中部">中部</option>
			<option value="近畿">近畿</option>
			<option value="中国">中国</option>
			<option value="四国">四国</option>
			<option value="九州・沖縄">九州・沖縄</option>
		</select>
			<select name="selectName" id="pre" disabled>
				<option value="">都道府県を選択</option>
			</select>
			<input type="search" id="seatxt" name="searchText" placeholder="入力できません" disabled>
		</form>

		<br>
		<input type="submit" class="button" id="" value="検索結果の表示" onClick="SearchGenreSelect()" >
		<br>
	</div>

	<br>
	<!-- 8月　インラインフレームでFMview.jspを表示する。最初は白紙。属性名wakuはsendとsearchで使用 -->
	<iframe src="<%= request.getContextPath() %>/FMcontrol?pre=&edit=false" name="waku" width="90%" height="500"></iframe>

</div>

<div id="dsparea"></div>

<%@ include  file = "footer.jsp"%>
</body>
</html>