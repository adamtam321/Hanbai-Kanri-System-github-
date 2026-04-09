package control;

import java.io.IOException;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.MyDBAccess;

/*
 * Servlet implementation class FMlogin
 */
@WebServlet("/FMlogin")
public class FMlogin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public FMlogin() {
		super();
	}

	/*
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		String userId		 = request.getParameter("userId");
		String password	 = request.getParameter("password");

		String name			= "";
		String pw 			= "";
		Boolean adminflg 	= true;
		Boolean music     	= false/*true*/;
		Boolean firstlogin	= true; // 8月新規
		String manegement	= "unknown";	//7月新規 画面切り替え時の音楽を替えるための変数

		// 指定されたユーザIDの持つ、ユーザの名前、パスワード、管理者権限の有無を取得する
		MyDBAccess model = new MyDBAccess();
		try {
			model.open();

			ResultSet rs = null;
			rs = model.getResultSet(SendSQLSentence(userId));

			while(rs.next()) {
				name 	 = rs.getString("user_name");
				pw 		 = rs.getString("password");
				adminflg = rs.getBoolean("admin_flg");
			}

			model.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		Ubcrypt ubcrypt = Ubcrypt.getInstance();
		String epw = ubcrypt.encodePw(password);
		System.out.println(epw);
		if(ubcrypt.matchesPw(password, pw)){ // パスワードとIDが合致しているとき
			session.setAttribute("userId", userId);
			session.setAttribute("userName", name);
			session.setAttribute("adminFlg", adminflg);

			session.setAttribute("music", music);			 //7月音楽を流すための判断
			session.setAttribute("manegement", manegement);  //7月音楽を変更する判断
			session.setAttribute("isRegisteredUserId", false);	//7月既存登録かどうかの判断

			session.setAttribute("firstlogin",firstlogin); // 8月新規
			request.setAttribute("disp_alert", "0"); // loginアラートを出したいがためのフラグ…未解決
			System.out.println(request.getAttribute("disp_alert"));

			RequestDispatcher dispatch = request.getRequestDispatcher("view/USgeneral.jsp");// USgeneral
			dispatch.forward(request, response);
			/* if(adminflg){	// adminであるケース。ここがtrueなら、管理者ページへ
				RequestDispatcher dispatch = request.getRequestDispatcher("/USshow");
				dispatch.forward(request, response);
			} else {		// adminではないケース
				RequestDispatcher dispatch = request.getRequestDispatcher("view/USgeneral.jsp");// USgeneral
				dispatch.forward(request, response);
			} */

		} else {				  // パスワードとIDが間違っているとき
			request.setAttribute("disp_alert", "1"); // loginアラートを出したいがためのフラグ…未解決
			RequestDispatcher dispatch = request.getRequestDispatcher("view/login.jsp");
			dispatch.forward(request, response);
		}

	}

	private String SendSQLSentence(String userId) {
		String sql = null;

		// ログイン時にidとパスワードがマッチしているかを調べるためのSQL
		sql = "SELECT"
				+ " user_name,"
				+ " password,"
				+ " admin_flg"
				+ " FROM"
				+ " ユーザ情報"
				+ " WHERE user_id ='"+ userId +"';";

		return sql;
	}

}