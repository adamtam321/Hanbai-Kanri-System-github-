package control;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.MyDBAccess;

/*
 * Servlet implementation class SUshow
 */
@WebServlet("/USshow")
public class USshow extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<HashMap<String, String>> userList = new ArrayList<HashMap<String, String>>();
		Boolean adminflg = true;
		// 管理者を降順で表示するsql
		String sql = "SELECT * FROM \"ユーザ情報\" ORDER BY CASE WHEN user_id = 'admin'  THEN 0 when admin_flg = 'true' then 1 ELSE 2 END,user_id COLLATE \"C\" ASC;";

		// DBアクセス処理
		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(sql);

			while (rs.next()) {
				HashMap<String, String> userInfo = new HashMap<String, String>();

				userInfo.put("userName", rs.getString("user_name"));
				userInfo.put("userId", rs.getString("user_id"));
				adminflg = rs.getBoolean("admin_flg"); // 削除判定追加
				String userAdmin = adminflg == true ? "true" : "false";
				userInfo.put("userAdmin", userAdmin);

				userList.add(userInfo);
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		request.setAttribute("userList", userList);
		RequestDispatcher dispatch = request.getRequestDispatcher("view/USview.jsp");
		dispatch.forward(request, response);
	}
}