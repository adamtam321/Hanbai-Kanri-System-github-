package control;

import java.io.IOException;
import java.net.URLEncoder;
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
 * Servlet implementation class GIcontrol
 */
@WebServlet("/GIcontrol")
public class GIcontrol extends HttpServlet{
	private static final long serialVersionUID=1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public GIcontrol(){
		super();
	}
	
	Date today = Date.valueOf(LocalDate.now());
	Date newProductsPeriod = Date.valueOf(LocalDate.now().minusDays(30));

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException{

		String item = request.getParameter("item"); // 商品名
		item = new String(item.getBytes("UTF-8"), "UTF-8");

		request.setAttribute("getitem",ItemDetailList(item));
		RequestDispatcher dispatch = request.getRequestDispatcher("view/getItem.jsp");
		dispatch.forward(request, response);
	}

	// 8月　商品の詳細データを取得するSQLをセットする。ItemDetailListで呼び出している 9/22
	private String SendSQLSentence(String item) {
		String sql ="SELECT " // プルダウンで指定された商品データを取得するSQL
					+ "商品コード,商品名,販売会社,ジャンル,販売日,価格,画像 "
					+ "FROM "
					+ "商品データ "
					+ "WHERE "
					+ "商品名='" + item +"';";

		return sql;
	}

	// 8月　商品の詳細データをリストに入れる。リクエストで呼び出している 9/22
	private List<Itemfam> ItemDetailList(String item){
		List<Itemfam> ItemList = new ArrayList<Itemfam>();

		MyDBAccess model = new MyDBAccess();
		try{
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(item));

			while(rs.next()){
				Itemfam setItem = new Itemfam();

				setItem.ItemId		 = rs.getString("商品コード");
				setItem.ItemName	 = rs.getString("商品名");
				setItem.uriItemName  = URLEncoder.encode(setItem.ItemName,"UTF-8");
				setItem.maker		 = rs.getString("販売会社");
				setItem.genre		 = rs.getString("ジャンル");
				setItem.day			 = rs.getDate("販売日");
				setItem.price		 = rs.getInt("価格");
				setItem.img			 = rs.getString("画像");

				// 8月　新商品判定を追加。1=発売予定 0=新商品 -1=既存商品
				if((today).compareTo(setItem.day) < 0) {
					setItem.newItemJudge = 1;
				} else if((newProductsPeriod).compareTo(setItem.day) <= 0) {
					setItem.newItemJudge = 0;
				} else {
					setItem.newItemJudge = -1;
				}

				ItemList.add(setItem);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ItemList;
	}

}