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
 * Servlet implementation class FMsearch
 */
@WebServlet("/FMsearch")
public class FMsearch extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
    public FMsearch() {
        super();
    }

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		String shp = request.getParameter("shp"); // 検索窓に入力されたデータ
		String edit = request.getParameter("edit"); // 出店済みか否か(TorF)の情報取得

		request.setAttribute("shopdata", ShopDataList(shp, edit)); // 表示する店舗データ
		request.setAttribute("skey", "2"); // hiddenに渡す
		request.setAttribute("shp", shp);
		request.setAttribute("edit", edit);
		RequestDispatcher dispatch = request.getRequestDispatcher("view/FMview.jsp");
		dispatch.forward(request, response);
	}

	// 8月　検索窓データから店舗を取得するSQLをセットする。ShopDataListで呼び出している 9/22
	private String SendSQLSentence(String shp, String edit) {
		String sql = null;

		if(edit.equals("true")){ // 店舗名を取得
			sql = "SELECT "
					+ "店舗名,to_char(出店日, 'YYYY年MM月DD日')出店日,住所,	deleted,店舗id "
					+ "FROM "
					+ "出店計画 "
					+ "WHERE "
					+ "店舗名 LIKE '%" + shp + "%'"
					+ "AND deleted='true'";
		} else {
			sql = "SELECT "
					+ "店舗名,to_char(出店日, 'YYYY年MM月DD日')出店日,住所,	deleted,店舗id "
					+ "FROM "
					+ "出店計画 "
					+ "WHERE "
					+ "店舗名 LIKE '%" + shp + "%'"
					+ "AND deleted='false'";
		}

		return sql;
	}

	// 8月　店舗のデータをリストに入れる。リクエストで呼び出している 9/22
	private List<Shopinfo> ShopDataList(String shp, String edit){
		List<Shopinfo> ShopList = new ArrayList<Shopinfo>();

		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(shp, edit));

			while(rs.next()) {
				Shopinfo setShop = new Shopinfo() ;

				setShop.shopName	= rs.getString("店舗名");
				setShop.uriShopName = URLEncoder.encode(setShop.shopName, "UTF-8");
				setShop.openDate 	= rs.getString("出店日");
				setShop.shopAdr		= rs.getString("住所");
				setShop.uriShopAdr	= URLEncoder.encode(setShop.shopAdr, "UTF-8");
				setShop.deleted		= rs.getBoolean("deleted");
				setShop.shopid		= rs.getString("店舗id");

				ShopList.add(setShop);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ShopList;
	}

}