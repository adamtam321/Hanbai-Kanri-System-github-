<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import = "jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<link href="<%= request.getContextPath() %>/view/css/W0051.css"
		rel="stylesheet" type="text/css" />
<title>商品一覧 - FamilyMart</title>

<!-- ファビコンの設定 -->
<link rel="icon" href="/familymart_202602/view/img/familymart_square.png"/>


<script>
<%
	request.setCharacterEncoding("windows-31j");
	Boolean login = (Boolean)session.getAttribute("adminFlg");
	if (login == null){
		pageContext.forward("/view/login.jsp");
	}
%>

	var currentSort = "";
	
	// 8月　SHviewへ飛ばすプログラムをインラインフレームでのページ遷移へ変更
	function senditem(){
		var index = document.getElementById("pre").selectedIndex;
		var text =document.getElementById("pre").options[index].text;

		// 8月　インラインフレームのページ遷移を行う。
		waku.location = "<%= request.getContextPath() %>\/SHcontrol?pre=" + encodeURI(text) + "&sort=" + currentSort
		;
	}

	// 8月 検索結果のページへ遷移する
	function searchWord(){
		var str = document.getElementById("sea").value;
		waku.location = "<%= request.getContextPath() %>\/SHsearch?str=" + encodeURI(str) + "&sort=" + currentSort
		;
	}

	// ログアウト処理
	var flag = false;
	function logout(){
		if(confirm("ログアウトします。よろしいですか？")){
			flag = true;
			document.MyForm.action = "<%= request.getContextPath() %>/FMlogout"
			document.MyForm.submit();
		} else {
			return;
		}
	}

	function movePrefecture(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMtest.jsp"
		document.MyForm.submit();
	}

	function moveUserList(){
		document.MyForm.action = "<%= request.getContextPath()%>/view/USgeneral.jsp"
		document.MyForm.submit();
	}

	function moveRank(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/FMrank1.jsp"
		document.MyForm.submit();
	}

	function moveShopItem(){
		document.MyForm.action = "<%= request.getContextPath() %>/view/SHtest.jsp"
		document.MyForm.submit();	
	}

	function moveUserManagementList(){
		document.MyForm.action = "<%= request.getContextPath() %>/USshow"
		document.MyForm.submit();
	}
	

	function Items(pre,ischecked){
		if(ischecked == true){
			// チェックが入っていたら有効化
			document.getElementById("pre").disabled = true;
		} else {
			// チェックが入っていなかったら無効化
			document.getElementById("pre").disabled = false;
		}
		document.f1.selectName.length=19;
		document.f1.selectName.options[0].text	="おにぎり";
		document.f1.selectName.options[1].text	="パン";
		document.f1.selectName.options[2].text	="そば";
		document.f1.selectName.options[3].text	="うどん";
		document.f1.selectName.options[4].text	="パスタ";
		document.f1.selectName.options[5].text	="サラダ";
		document.f1.selectName.options[6].text	="ホットスナック";
		document.f1.selectName.options[7].text	="お菓子";
		document.f1.selectName.options[8].text	="飲料";
		document.f1.selectName.options[9].text	="お酒";
		document.f1.selectName.options[10].text ="アイス";
		document.f1.selectName.options[11].text ="冷凍食品";
		document.f1.selectName.options[12].text ="日用品";
		document.f1.selectName.options[13].text ="お弁当";
		document.f1.selectName.options[14].text ="中華まん";
		document.f1.selectName.options[15].text ="おでん";
		document.f1.selectName.options[16].text ="ファミデリカ";
		document.f1.selectName.options[17].text ="新商品";
		document.f1.selectName.options[18].text ="発売予定";
	}

	function Connecttext( sea, ischecked ) {
		if( ischecked == true ) {
			// チェックが入っていたら有効化
			document.getElementById("sea").disabled = true;
		} else {
			// チェックが入っていなかったら無効化
			document.getElementById("sea").disabled = false;
		}
	}

	function SearchGenreSelect(){
		radiobtn1 = document.getElementById("label1");
		radiobtn2 = document.getElementById("label2")
		if(radiobtn1.checked){
			senditem();
		}
		if(radiobtn2.checked){
			searchWord();
		}
	}

	//入力後Enterを押したら検索結果表示
	document.addEventListener('DOMContentLoaded',pageLoad)
	
	function pageLoad(){
		var textbox =document.getElementById('sea');

		if(textbox){
		textbox.addEventListener('keydown',enterKeyPress);
		}
		var sortHeader = document.getElementById("sortHeader");

	    if(sortHeader){
	        sortHeader.addEventListener("click", function(){

	            var options = document.getElementById("sortOptions");
	            var arrow = document.getElementById("arrow");

	            if(options.style.display === "none" || options.style.display === ""){
	                options.style.display = "block";
	                arrow.innerText = "▲";
	            }else{
	                options.style.display = "none";
	                arrow.innerText = "▼";
	            }

	        });
	    }
			
		
		}

	function enterKeyPress(event){
		if(event.key === 'Enter'){
			searchWord();
			}
		}
	
	function setSort(sort){
		currentSort = sort;

		
	    var iframe = window.frames['waku'];
	    var currentSrc = iframe.location.href;

	    var url = new URL(currentSrc, window.location.origin);
	    url.searchParams.set("sort", sort);
	    iframe.location.href = url.toString();
	    var header = document.getElementById("sortHeader");

	    if(sort === "price_asc"){
	        header.innerHTML = "価格が安い順 <span id='arrow'>▼</span>";
	    }else if(sort === "price_desc"){
	        header.innerHTML = "価格が高い順 <span id='arrow'>▼</span>";
	    }

	    document.getElementById("sortOptions").style.display="none";
	    document.getElementById("arrow").innerText = "▼";
	}
</script>
</head>

<body>
<%@ include  file = "header.jsp"%>
	
<br>
<div class="center">

	<div class ="end">
		<h1>商品一覧</h1>
	</div>

	<br>
	<%--7月　ボタンや表示が小さいとの指摘有、大きくしたほうがよいと思います → 8月　しました--%>
	<div class="select">

		<!-- 応急処置 -->
		<div class="subh">
			--商品を表示する方法を選択してください--
		</div>

		<br>
		<form name="f1" action="#" onsubmit="return false">
			<input id="label1" type="radio" name="radio1" onclick="Items(pre,this.cheaked);sea.disabled=true;sea.value=null;sea.placeholder='入力できません'">
				<label for="label1">商品ジャンル検索</label>
			<input id="label2" type="radio" name="radio1" onclick="Connecttext(sea,this.cheaked);pre.disabled=true;sea.placeholder='商品名で検索'">
				<label for="label2">商品名検索</label><br>

			<select name="selectName" id="pre" disabled></select>
			<input type="search" id="sea" name="searchText" placeholder="入力できません" disabled>
		</form>

		<br>
		<input type="submit" class="button" id="" value="検索結果の表示" onClick="SearchGenreSelect()" >
		<br>
	</div>

	<br><br>
	<!-- 8月　インラインフレームでSHview.jspを表示する。最初は白紙。属性名wakuはsenditemとsearchWordで使用 -->
	<!-- Section 並び替え -->
<div class="sort-section">

    <div id="sortHeader">
        並び替え <span id="arrow">▼</span>
    </div>

    <div id="sortOptions">
        <button type="button" onclick="setSort('price_asc')">価格が安い順</button>
        <button type="button" onclick="setSort('price_desc')">価格が高い順</button>
    </div>

</div>

<div class="waku-container">
	<!-- 画面表示時に変更 -->
    <iframe src="<%= request.getContextPath() %>/SHcontrol?pre=" name="waku"></iframe>
</div>

<%@ include  file = "footer.jsp"%>
</body>
</html>