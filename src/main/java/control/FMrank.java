package control;

import java.io.IOException;
import java.sql.Date;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.MyDBAccess;

/*
 * Servlet implementation class FMrank
 */
@WebServlet("/FMrank")
public class FMrank extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public FMrank() {
		super();
	}

	Date today = Date.valueOf(LocalDate.now());
	Date newProductsPeriod = Date.valueOf(LocalDate.now().minusDays(30));
	
	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		//ログインチェック
		Boolean login = (Boolean)request.getSession().getAttribute("adminFlg");
		if(login == null){
		    response.sendRedirect(request.getContextPath() + "/view/login.jsp");
		    return;
		}


		String pre = request.getParameter("pre"); //ジャンル情報取得
		String edit = request.getParameter("edit"); //trueなら都道府県、falseなら商品

		if(pre == null || pre.trim().equals("")){
		    pre = "総合"; //初期状態は総合ランキング
		} else {
		    pre = pre.trim();   // 余計な空白を除去
		}
		
		if(edit == null || edit.trim().equals("")){
		    edit = "false"; //商品ランキング扱い
		} else {
		    edit = edit.trim();
		}


		request.setAttribute("RANKInfo", RankingList(pre, edit));
		request.setAttribute("pre", pre);
		request.setAttribute("edit", edit);
		RequestDispatcher dispatch = request.getRequestDispatcher("view/FMrank2.jsp");
		dispatch.forward(request, response);
	}

	// 8月　ランキングデータを取得するSQLをセットする。RankingListで呼び出している 9/22
	private String SendSQLSentence(String pre, String edit) {
		String sql = null;

		// 8月　追加sql文 長すぎてメインメソッドが行方不明になるので分離。簡潔に書ける場合は要修正…
		if(edit.equals("true")) { // 店舗データ
			if(pre.equals("総合")) { // 総合データを出すとき
				sql = "SELECT "
						+ " 店舗名, 住所, Sum(数量*価格) as 売上額, "
						+ " DENSE_RANK() OVER(ORDER BY Sum(数量*価格) desc) AS 順位"
						+ " FROM "
						+ " 売上データ "
						+ " inner join " + "出店計画 " + "on " + "出店計画.店舗id = 売上データ.店舗id "
						+ " inner join " + "商品データ " + "on " + "売上データ.商品コード = 商品データ.商品コード "
//						+ " where " 		<!-- 汎用SQLとの差別点 -->
//						+ " 都道府県 = '"+ pre +"'"
						+ " GROUP BY "
						+ " 店舗名, 住所 ";

			} else { // その他は汎用SQL
				sql = "SELECT "
						+ " 店舗名, 住所, Sum(数量*価格) as 売上額, "
						+ " DENSE_RANK() OVER(ORDER BY Sum(数量*価格) desc) AS 順位"
						+ " FROM "
						+ " 売上データ "
						+ " inner join " + "出店計画 " + "on " + "出店計画.店舗id = 売上データ.店舗id "
						+ " inner join " + "商品データ " + "on " + "売上データ.商品コード = 商品データ.商品コード "
						+ " where "
						+ " 都道府県 = '"+ pre +"' "
						+ " GROUP BY "
						+ " 店舗名, 住所 ";
			}

		} else if(edit.equals("false")) { // 商品データ
			if(pre.equals("新商品")) { // 新商品の時はジャンルを無視して販売日に絞る
				sql = "SELECT "
						+ " 画像, 商品名, 販売日, Sum(数量) AS 売上数, Sum(数量)*価格 AS 売上額, "
						+ " DENSE_RANK() OVER(ORDER BY Sum(数量)*価格 desc) AS 順位"
						+ " FROM "
						+ " 商品データ "
						+ " inner join " + "売上データ " + "on " + "商品データ.商品コード = 売上データ.商品コード "
						+ " where "
						+ " CAST('"+today+"' AS DATE) >= 販売日 AND 販売日 >= CAST('"+newProductsPeriod+"' AS DATE)" // 変更点
						+ " GROUP BY "
						+ " 商品名, 画像, 価格, 販売日 ";

			} else if(pre.equals("総合")) { // 総合ランキングの時はジャンルを無視する
				sql = "SELECT "
						+ " 画像, 商品名, 販売日, Sum(数量) AS 売上数, Sum(数量)*価格 AS 売上額, "
						+ " DENSE_RANK() OVER(ORDER BY Sum(数量)*価格 desc) AS 順位"
						+ " FROM "
						+ " 商品データ "
						+ " inner join " + "売上データ " + "on " + "商品データ.商品コード = 売上データ.商品コード "
						+ " WHERE 販売日 <= CAST('"+today+"' AS DATE) "
						+ " GROUP BY "
						+ " 商品名, 画像, 価格, 販売日 ";

			} else { // その他は汎用SQL
				sql = "SELECT "
						+ " 画像, 商品名, 販売日, Sum(数量) AS 売上数, Sum(数量)*価格 AS 売上額, "
						+ " DENSE_RANK() OVER(ORDER BY Sum(数量)*価格 desc) AS 順位"
						+ " FROM "
						+ " 商品データ "
						+ " inner join " + "売上データ " + "on " + "商品データ.商品コード = 売上データ.商品コード "
						+ " where "
						+ " ジャンル = '"+ pre +"' "
					    + "   AND 販売日 <= CAST('"+today+"' AS DATE) "
						+ " GROUP BY "
						+ " 商品名, 画像, 価格, 販売日 ";
			}
		}

		return sql;
	}

	// 8月　ランキングデータをリストに入れる。リクエストで呼び出している 9/22
	private List<RANKInfo> RankingList(String pre, String edit) {
		List<RANKInfo> RankList = new ArrayList<RANKInfo>();

		MyDBAccess model = new MyDBAccess();
		try{
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(pre,edit));

			if(edit.equals("true")) {
				while(rs.next()) {
					RANKInfo setRank = new RANKInfo();

					setRank.shop_name = rs.getString("店舗名");
					setRank.shop_add  = rs.getString("住所");
					setRank.shop_sale = rs.getInt("売上額");
					setRank.shop_rank = rs.getInt("順位");

					RankList.add(setRank);
				}

			} else if(edit.equals("false")) {
				while(rs.next()) {
					
					Date releaseDate = rs.getDate("販売日");

					int judge;
					if (today.compareTo(releaseDate) < 0) {
					    judge = 1; // 発売予定
					} else if (newProductsPeriod.compareTo(releaseDate) <= 0) {
					    judge = 0; // 新商品
					} else {
					    judge = -1; // 既存商品
					}
					
					
					if (judge == 1) {
					    continue; // 発売予定はランキングに入れない
					}


					
					RANKInfo setRank = new RANKInfo();
					
					setRank.newItemJudge = judge;

					setRank.product_img  		= rs.getString("画像");
					setRank.product_name 		= rs.getString("商品名");
					setRank.product_Sale 		= rs.getInt("売上数");
					setRank.product_rank 		= rs.getInt("順位");
					setRank.product_AmountSales = rs.getInt("売上額");

					RankList.add(setRank);
					
					
				}
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return RankList;
	}

}