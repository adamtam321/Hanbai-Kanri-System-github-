package control;

import java.io.IOException;
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
 * Servlet implementation class GScontrol
 */
@WebServlet("/GScontrol")
public class GScontrol extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public GScontrol() {
		super();
	}

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String shop = request.getParameter("shop"); // 店舗名
		shop = new String(shop.getBytes("UTF-8"), "UTF-8");

		request.setAttribute("shopfam", ShopTopDetailList(shop));
		request.setAttribute("shoppay", ShopDownDetailList(shop));
		RequestDispatcher dispatch = request.getRequestDispatcher("view/getShop.jsp");
		dispatch.forward(request, response);
	}

	// 8月　店舗の詳細データを取得するSQLをセットする。二つのShop[---]DetaiListで呼び出している 9/22
	private String SendSQLSentence(String shop, String potision) {
		String sql = "";

		if(potision.equals("top")) {
			// 店舗所属の氏名と年俸を取得。これは上段のショップリストに格納される
			sql = "SELECT"
				+ " 店舗名, 氏名, 年俸"
				+ " FROM"
				+ " 出店計画 INNER JOIN 年俸 ON 出店計画.店舗id=年俸.店舗id"
				+ " WHERE"
				+ " 店舗名='"+ shop +"';";

		} else if(potision.equals("down")) {
			// 8月　数量と価格、仕入れ値を用いて計算させる。これは下段のショップリストに格納される
			sql = "SELECT"
				+ " Sum(数量*価格) AS 売り ,Sum(数量*仕入れ値) AS 仕入れ,光熱費,テナント料,人件費,"
				+ " Sum(数量*価格)-Sum(数量*仕入れ値)-光熱費-テナント料-人件費 AS 利益"
				+ " FROM"
				+ " 出店計画"
				+ " INNER JOIN (SELECT 店舗id, SUM(年俸)/12 AS 人件費 FROM 年俸 GROUP BY 店舗id ) AS S"
				+																" ON 出店計画.店舗id=S.店舗id"
				+ " INNER JOIN 経費 ON 出店計画.店舗id=経費.店舗id"
				+ " INNER JOIN (SELECT 店舗id, 商品コード, 数量 FROM 売上データ) AS U "
				+																" ON 出店計画.店舗id=U.店舗id"
				+ " INNER JOIN (SELECT 商品コード, 価格, 仕入れ値 FROM 商品データ) AS D "
				+ 																" ON U.商品コード = D.商品コード"
				+ " WHERE"
				+ " 店舗名='"+ shop +"'"
				+ " GROUP BY "
				+ " 光熱費,テナント料,人件費 ;";
		}

		return sql;
	}

	// 8月　↓上段下段とも二つに分けてるのがスマートでない。…がSQL結合が上手くいかなかったので任せます↓
	// 8月　店舗詳細データの上段をリストに入れる。リクエストで呼び出している 9/22
	private List<Shopfam> ShopTopDetailList(String shop){
		List<Shopfam> ShopList = new ArrayList<Shopfam>();

		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(shop, "top"));

			while(rs.next()) {
				Shopfam setShop = new Shopfam();

				setShop.employeeName = rs.getString("氏名");
				setShop.employeePay	 = rs.getInt("年俸")/12;

				ShopList.add(setShop);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return ShopList;
	}

	// 8月　店舗詳細データの下段をリストに入れる。リクエストで呼び出している 9/22
	private List<Shopfam2> ShopDownDetailList(String shop){
		List<Shopfam2> ShopList = new ArrayList<Shopfam2>();

		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(shop, "down"));

			while(rs.next()) {
				Shopfam2 setShop2 =  new Shopfam2();

				setShop2.shopSales		 = rs.getInt("売り");
				setShop2.shopPurchase	 = rs.getInt("仕入れ");
				setShop2.shopUtilityCost = rs.getInt("光熱費");
				setShop2.shopRentCost	 = rs.getInt("テナント料");
				setShop2.shopPersonCost  = rs.getInt("人件費");
				setShop2.shopProfits	 = rs.getInt("利益");

				ShopList.add(setShop2);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ShopList;
	}

}