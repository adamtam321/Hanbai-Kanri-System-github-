<%@ page contentType="text/html; charset=UTF-8"%>
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

<title>ユーザ画面 - FamilyMart</title>

<link rel="icon"
	href="<%=request.getContextPath()%>/view/img/familymart_square.png" />
<link href="<%=request.getContextPath()%>/view/css/W0051.css"
	rel="stylesheet" type="text/css" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>


<script type="text/javascript">
// モーダルとカレンダーを操作するための変数を広域で宣言
var eventModal;
var calendar;

window.onload = function (){
    <%boolean firstlogin = (boolean) session.getAttribute("firstlogin");
boolean adminflg = (boolean) session.getAttribute("adminFlg");
if (firstlogin) {
	if (adminflg) {%>
            alert("管理者ユーザ" + "<%=un%>" + "でログインしています");
        <%} else {%>
            alert("一般ユーザ" + "<%=un%>" + "でログインしています");
        <%}
session.setAttribute("firstlogin", false);
}%>

    // Bootstrapモーダルの初期化
    eventModal = new bootstrap.Modal(document.getElementById('eventModal'));

    var currentYear = new Date().getFullYear();
    var startYear = currentYear - 1;
    var endYear = currentYear + 1;
    var calendarEl = document.getElementById('calendar');

    calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ja',
        fixedWeekCount: false,
        dayMaxEvents: true,
        displayEventEnd: true,
        eventTimeFormat: {
            hour: '2-digit',
            minute: '2-digit',
            meridiem: false
        },
        validRange: {
            start: startYear + '-01-01',
            end: (endYear + 1) + '-01-01'
        },
        selectable: true,

        // 複数のデータソースを統合
        eventSources: [
            // 1. 祝日APIのデータソース
            function(info, successCallback, failureCallback) {
                fetch('https://holidays-jp.github.io/api/v1/date.json')
                    .then(response => response.json())
                    .then(data => {
                        var holidays = Object.keys(data).map(function(dateStr) {
                            return {
                                title: data[dateStr],
                                start: dateStr,
                                color: '#ff0000',
                            };
                        });
                        // 独自記念日の追加
                        holidays.push({
                            title: 'ウイズ・ワン設立記念日',
                            start: currentYear + '-01-04',
                            color: '#00ff00'
                        });
                        successCallback(holidays);
                    })
                    .catch(error => {
                        console.error('祝日取得エラー:', error);
                        failureCallback(error);
                    });
            },
            
            // 2. 自作サーブレット（DB）からのデータソース
            {
                url: '<%=request.getContextPath()%>/CalendarEvent',
                method: 'GET',
                // ★重要：取得したデータを表示直前に加工する機能
                eventDataTransform: function(eventData) {
                    // DBに保存されている背景色(color)を元に文字色を計算してセット
                    eventData.textColor = getContrastColor(eventData.color)
// ★追加：背景が明るい（黒文字になる）場合のみ、ふちを「濃いグレー」にする
            // 背景が暗い場合は、ふちを背景色と同じにして目立たせない
            eventData.borderColor = (eventData.textColor === '#000000') ? '#adb5bd' : eventData.color;
                    return eventData;
                },
                failure: function() {
                    alert('予定の取得に失敗しました');
                }
            }
            
        ],

        dateClick: function(info) {
            document.getElementById('eventId').value = ""; // IDをクリア
            document.getElementById('selectedDate').value = info.dateStr;
            document.getElementById('eventTitle').value = "";
            document.getElementById('startTime').value = "";
            document.getElementById('endTime').value = "";
            document.getElementById('deleteEventBtn').style.display = "none"; // 削除ボタンを隠す
            document.getElementById('eventModalLabel').innerText = "予定の新規登録";
            eventModal.show();
        },
     // --- 2. eventClick (編集) の修正 ---
        eventClick: function(info) {
            if (!info.event.id) return; // 祝日は無視

            // 各値をモーダルにセット
            document.getElementById('eventId').value = info.event.id;
            document.getElementById('eventTitle').value = info.event.title;
            document.getElementById('eventColor').value = info.event.backgroundColor;

            // 時刻のセット
            if (info.event.start) {
                var start = info.event.start;
                var hh = ('0' + start.getHours()).slice(-2);
                var mm = ('0' + start.getMinutes()).slice(-2);
                document.getElementById('startTime').value = info.event.allDay ? "" : hh + ":" + mm;
            }
            if (info.event.end) {
                var end = info.event.end;
                document.getElementById('endTime').value = ('0' + end.getHours()).slice(-2) + ":" + ('0' + end.getMinutes()).slice(-2);
            } else {
                document.getElementById('endTime').value = "";
            }

            document.getElementById('selectedDate').value = info.event.startStr.split('T')[0];
            document.getElementById('deleteEventBtn').style.display = "block"; // 削除ボタンを表示
            document.getElementById('eventModalLabel').innerText = "予定の編集";
            eventModal.show();
        },
    });

    calendar.render();

    // フォーム制御のイベントリスナー
    var eventForm = document.getElementById('eventForm');
    eventForm.addEventListener('submit', function(e) {
        e.preventDefault();
    });

    document.getElementById('saveEventBtn').addEventListener('click', function() {
        saveEvent();
    });

    document.getElementById('eventTitle').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            saveEvent();
        }
    });
    document.getElementById('deleteEventBtn').addEventListener('click', function() {
        var id = document.getElementById('eventId').value;
        if (confirm("この予定を削除しますか？")) {
            fetch('<%=request.getContextPath()%>/CalendarEvent?id=' + id, { method: 'DELETE' })
            .then(response => {
                if (response.ok) {
                    calendar.refetchEvents();
                    eventModal.hide();
                }
            });
        }
    });
};

// 保存処理の共通化
function saveEvent() {
    var id = document.getElementById('eventId').value; // IDを取得
    var title = document.getElementById('eventTitle').value;
    var date = document.getElementById('selectedDate').value;
    var color = document.getElementById('eventColor').value;
    var startTime = document.getElementById('startTime').value;
    var endTime = document.getElementById('endTime').value;

    if (!title) {
        alert("タイトルを入力してください");
        return;
    }

    var isAllDay = !startTime;
    var startFull = isAllDay ? date : date + 'T' + startTime;
    var endFull = "";

    // バリデーション
    if (isAllDay && endTime) {
        alert("終日イベントに終了時刻は設定できません。終了時刻を削除するか、開始時刻を入力してください。");
        return;
    }
    if (!isAllDay && endTime) {
        if (endTime <= startTime) {
            alert("終了時刻は開始時刻より後にしてください。");
            return;
        }
        endFull = date + 'T' + endTime;
    }

    // サーブレットへ送るパラメータを構成
    var params = new URLSearchParams();
    if (id) params.append('id', id); // ★IDがある（編集）なら追加
    params.append('title', title);
    params.append('start', startFull);
    params.append('end', endFull);
    params.append('allDay', isAllDay);
    params.append('color', color);

    // POST送信
    fetch('<%=request.getContextPath()%>/CalendarEvent', {
        method: 'POST',
        body: params,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    })
    .then(response => {
        if (response.ok) {
            // 保存成功時にカレンダーのイベントを再取得（リロード）
            calendar.refetchEvents();
            eventModal.hide();
        } else {
            alert("保存に失敗しました");
        }
    })
    .catch(error => {
        console.error('通信エラー:', error);
        alert("サーバーとの通信に失敗しました");
    });
}

// 既存のナビゲーション関数
function logout(){
    if(confirm("ログアウトします。よろしいですか？")){
        document.MyForm.action = "<%=request.getContextPath()%>/FMlogout"
        document.MyForm.submit();
    }
}

function moveUserManagementList(){
    document.MyForm.action = "<%=request.getContextPath()%>/USshow"
    document.MyForm.submit();
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
/**
 * 背景色(HEX)から最適な文字色(#ffffff or #000000)を返す関数
 */
function getContrastColor(hexColor) {
    // #ffffff の形式からR, G, Bを抽出
var r = parseInt(hexColor.slice(1, 3), 16);
    var g = parseInt(hexColor.slice(3, 5), 16);
    var b = parseInt(hexColor.slice(5, 7), 16);

    // YIQ公式で明るさを計算
    var yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;

    // 128を境に白か黒を返す
    return (yiq >= 128) ? '#000000' : '#ffffff';
}

<%request.setCharacterEncoding("windows-31j");
Boolean login = (Boolean) session.getAttribute("adminFlg");
if (login == null) {
	pageContext.forward("/view/login.jsp");
}%>
</script>

<div class="modal fade" id="eventModal" tabindex="-1"
	aria-labelledby="eventModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="eventModalLabel">予定の新規登録</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
			<input type="hidden" id="eventId">
				<form id="eventForm">
					<div class="mb-3">
					<input type="hidden" id="selectedDate">
						<label for="eventTitle" class="form-label">予定タイトル</label>
						<div class="row">
							<div class="col-10">
								<input type="text" class="form-control" id="eventTitle"
									placeholder="例：会議、ランチなど" required>
							</div>
							<div class="col-2">
								<input type="color"
									class="form-control form-control-color w-100" id="eventColor"
									name="color" value="#3788d8" title="色を選択">
							</div>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-6">
							<label for="startTime" class="form-label">開始時刻</label> <input
								type="time" class="form-control" id="startTime">
						</div>
						<div class="col-6">
							<label for="endTime" class="form-label">終了時刻</label> <input
								type="time" class="form-control" id="endTime">
						</div>
					</div>
					<input type="hidden" id="selectedDate">
				</form>
			</div>
			<div class="modal-footer">
			<button type="button" class="btn btn-danger me-auto" id="deleteEventBtn" style="display: none;">削除する</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">キャンセル</button>
				<button type="button" class="btn btn-primary" id="saveEventBtn">保存する</button>
			</div>
		</div>
	</div>
</div>
</head>

<body>
	<%@ include file="header.jsp"%>

	<br>
	<div class="center">
		<%
		String manege = (String) session.getAttribute("manegement");
		boolean music = (boolean) session.getAttribute("music");

		if (music == true) {
		%>
		<audio
			src="<%=request.getContextPath()%>/view/mp3/ファミマ入店音square短調.mp3"
			autoplay></audio>
		<%
		session.setAttribute("manegement", "NORMAL");
		session.setAttribute("music", false);
		} else if (manege == "LOW") {
		%>
		<audio src="<%=request.getContextPath()%>/view/mp3/ファミマ入店音Low.mp3"
			autoplay></audio>
		<%
		session.setAttribute("manegement", "NORMAL");
		}
		%>

		<div class="container-fluid">
			<div class="end">
				<div class="row">
					<div class="col-2"></div>
					<div class="col-8">
						<div id="carouselExampleAutoplaying" class="carousel slide"
							data-bs-ride="carousel">
							<div class="carousel-inner">
								<div class="carousel-item active">
								<a href="https://www.family.co.jp/famipay.html">
									<img src="<%=request.getContextPath()%>/view/img/ファミマアプリ.png"
										class="d-block mx-auto img-fluid" alt="...">
								</a>
								</div>
								<div class="carousel-item">
								<a href="https://www.family.co.jp/campaign/spot/2603_45sakusen_cp_qSdJ1U7g.html">
									<img src="<%=request.getContextPath()%>/view/img/イベント.png"
										class="d-block mx-auto img-fluid" alt="...">
								</a>
								</div>
							</div>
							<button class="carousel-control-prev" type="button"
								data-bs-target="#carouselExampleAutoplaying"
								data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button"
								data-bs-target="#carouselExampleAutoplaying"
								data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
					<div class="col-2"></div>
					<div class="mt-3">
						<a href="https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/koyou/koyouhoken/index_00003.html">
						＊重要情報：雇用保険について</a>
					</div>
					<div class="col-2 mt-3">
						<div>
						<a href="https://www.meti.go.jp/policy/economy/chizai/chiteki/trade-secret.html">
						<img src="<%=request.getContextPath()%>/view/img/情報解禁日.png"
										class="d-block mx-auto img-fluid" alt="...">
						</a>
										</div>
					</div>
					<div class="col-8 mt-3"
						style="background-color: rgb(255, 255, 255); padding: 20px; border-radius: 8px;">
						<div id="calendar"></div>
					</div>
					<div class="col-2 mt-3">
						<div onclick="moveRank();">
						<img src="<%=request.getContextPath()%>/view/img/商品ランキング.png"
										class="d-block mx-auto img-fluid" alt="..."></div>
					</div>
				</div>
			</div>

			<form name="MyForm2" method="POST"
				action="<%=request.getContextPath()%>/FMlogout">
				<input type="hidden" name="actionId" value=""> <input
					type="hidden" name="userId" value=""> <input type="hidden"
					name="username" value=""> <input type="hidden"
					name="password" value="">
			</form>
		</div>
		<div class="footer1 mt-5">
		</div>
	</div>

	<%@ include file="footer.jsp"%>
</body>
</html>