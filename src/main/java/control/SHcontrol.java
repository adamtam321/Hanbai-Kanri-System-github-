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
 * Servlet implementation class SHcontrol
 */
@WebServlet("/SHcontrol")
public class SHcontrol extends HttpServlet{
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public SHcontrol(){
		super();
	}
	
	Date today = Date.valueOf(LocalDate.now());
	Date newProductsPeriod = Date.valueOf(LocalDate.now().minusDays(30));

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException,IOException{

		String pre = request.getParameter("pre"); // pre=ジャンル(おにぎり、パスタ、新商品etc)
		String sort = request.getParameter("sort");  // 並び替え条件
		
		request.setAttribute("itemfam",ItemDataList(pre, sort));
		request.setAttribute("pre", pre);
		RequestDispatcher dispatch = request.getRequestDispatcher("view/SHview.jsp");
		dispatch.forward(request,response);
	}
	
	//ORDER BYまとめ用
	private String getOrderBy(String sort) { 
		if("price_asc".equals(sort)) { return " ORDER BY 価格 ASC"; 
		} else if("price_desc".equals(sort)) { return " ORDER BY 価格 DESC"; 
		} else { return " ORDER BY 販売日 DESC"; 
		} 
	}

	// 8月　ジャンル分けする商品データを取得するSQLをセットする。ItemDataListで呼び出している 9/22
	private String SendSQLSentence(String pre, String sort) {
		String sql = "";
		
		//ジャンルの入力がないときに商品データを表示
		if(pre == null || pre.equals("")) {
				sql ="SELECT "
			    + "商品コード,商品名,販売会社,ジャンル,販売日,価格,画像 "
			    + "FROM "
			    + "商品データ ";
		
		// 8月　発売予定と新商品は日付指定が必要なためSQLを別枠で、それ以外は通常通りジャンルで分ける。
		} else if(pre.equals("発売予定")) { // 2017/8/8以降の商品は発売予定と判定
			sql ="SELECT "
				+ "商品コード,商品名,販売会社,ジャンル,販売日,価格,画像 "
				+ "FROM "
				+ "商品データ "
				+ "WHERE "
				+ "CAST('"+today+"' AS DATE) < 販売日 ";

		} else if(pre.equals("新商品")){ // 2017/07/01～2017/08/07の商品は新商品と判定
			sql ="SELECT "
				+ "商品コード,商品名,販売会社,ジャンル,販売日,価格,画像 "
				+ "FROM "
				+ "商品データ "
				+ "WHERE "
				+ "CAST('"+today+"' AS DATE) >= 販売日 AND 販売日 >= CAST('"+newProductsPeriod+"' AS DATE)";

		} else { // ここが最初にあったコード
			sql ="SELECT "
				+ "商品コード,商品名,販売会社,ジャンル,販売日,価格,画像 "
				+ "FROM "
				+ "商品データ "
				+ "WHERE "
				+ "ジャンル = '"+ pre +"' ";
		}
		
		sql += getOrderBy(sort);
		
		return sql;
	}

	// 8月　ジャンル分けした商品データをリストに入れる。リクエストで呼び出している 9/22
	private List<Itemfam> ItemDataList(String pre, String sort){
		List<Itemfam> ItemList = new ArrayList<Itemfam>();

		MyDBAccess model = new MyDBAccess();
		try{
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(pre, sort));

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

		} catch(Exception e) {
			e.printStackTrace();
		}

		return ItemList;
	}

}