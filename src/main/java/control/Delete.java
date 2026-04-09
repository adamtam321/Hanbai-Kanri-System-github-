package control;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
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
 * Servlet implementation class Delete
 */
@WebServlet("/Delete")
public class Delete extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public Delete() {
		super();
	}

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ボタンが押されたときに非表示にするコード
		String iddata 	= request.getParameter("shop");
		String pre		= request.getParameter("pre");
		String edit 	= request.getParameter("edit");
		String shp		= request.getParameter("shp");	// 8月
		String skey		= request.getParameter("skey");	// 8月

		request.setAttribute("shopdata", ShopDataList(edit, iddata, shp)); // 店舗データ
		request.setAttribute("pre", pre);	// 県情報を送る
		request.setAttribute("edit", edit); // TorFのデータを送り返す
		request.setAttribute("shp", shp);	// 検索する店舗名
		request.setAttribute("skey", skey);	// 都道府県か検索か判断するため

		if("1".equals(skey)) {	//都道府県からか検索かの判断
			RequestDispatcher dispatch = request.getRequestDispatcher("/FMcontrol");
			dispatch.forward(request, response);
		} else {
			RequestDispatcher dispatch = request.getRequestDispatcher("view/FMview.jsp");
			dispatch.forward(request, response);
		}
	}

	// 8月　出店情報、店舗データを取得するSQLをセットする。ShopDataListで呼び出している 9/22
	private String SendSQLSentence(String edit, String iddata, String shp, String SearchGenre) {
		String sql = "";

		if(SearchGenre.equals("OpenOrClose")) {
			if(edit.equals("true")){ // 非表示にするSQL
				sql = " UPDATE"
					+ " 出店計画"
					+ " SET"
					+ " deleted='false'"
					+ " WHERE"
					+ " 店舗id='"+ iddata +"'";
			} else { 				  // 再表示するSQL
				sql = " UPDATE"
					+ " 出店計画"
					+ " SET"
					+ " deleted='true'"
					+ " WHERE"
					+ " 店舗id='"+ iddata +"'";
			}
		}

		if(SearchGenre.equals("ShopSerach")) {
			if(edit.equals("true")) {
				// 店舗名を取得
				sql = " SELECT"
					+ " 店舗名,to_char(出店日, 'YYYY年MM月DD日')出店日,住所,	deleted,店舗id"
					+ " FROM"
					+ " 出店計画"
					+ " WHERE"
					+ " 店舗名 LIKE '%" + shp + "%'"
					+ " AND deleted='true'";
			} else {
				sql = " SELECT"
					+ " 店舗名,to_char(出店日, 'YYYY年MM月DD日')出店日,住所,	deleted,店舗id"
					+ " FROM"
					+ " 出店計画"
					+ " WHERE"
					+ " 店舗名 LIKE '%" + shp + "%'"
					+ " AND deleted='false'";
			}
		}

		return sql;
	}

	// 8月　店舗データをリストに入れる。リクエストで呼び出している 9/22
	private List<Shopinfo> ShopDataList(String edit, String iddata, String shp){
		List<Shopinfo> ShopList = new ArrayList<Shopinfo>();

		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			model.execute(SendSQLSentence(edit, iddata, shp, "OpenOrClose"));

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(edit, iddata, shp, "ShopSerach"));

			// 取得された各結果に対しての処理
			while(rs.next()) {
				Shopinfo setshop = new Shopinfo() ;

				setshop.shopName	= rs.getString("店舗名");
				setshop.uriShopName	= URLEncoder.encode(setshop.shopName, "UTF-8");
				setshop.openDate	= rs.getString("出店日");
				setshop.shopAdr	 	= rs.getString("住所");
				setshop.uriShopAdr	= URLEncoder.encode(setshop.shopAdr, "UTF-8");
				setshop.deleted	 	= rs.getBoolean("deleted");
				setshop.shopid		= rs.getString("店舗id");

				ShopList.add(setshop);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ShopList;
	}

}