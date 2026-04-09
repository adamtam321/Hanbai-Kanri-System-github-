package control;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.MyDBAccess;

/*
 * Servlet implementation class USregist
 */
@WebServlet("/USregist")
public class USregist extends HttpServlet {

	/*
	 * @see HttpServlet#HttpServlet()
	 */
	public USregist() {
		super();
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		HttpSession session = request.getSession(true);

		String[] ArrayUserId = (String[])session.getAttribute("kizo");

		String userId			= request.getParameter("userId");
		String username		= request.getParameter("username");
		String createuser		= (String)session.getAttribute("userId");
		String updateuser		= (String)session.getAttribute("userId");
		String execProcess		= request.getParameter("actionId");
		String pw = request.getParameter("passWord");
		Ubcrypt bcrypt = Ubcrypt.getInstance();
		String hashedpassword = bcrypt.encodePw(pw);

		String str = ""; // コンソール表示用
		String sql = "";

		if(execProcess.equals("update")) {
			str = "更新";
			userId = (String)session.getAttribute("updateId");

		} else if(execProcess.equals("userRegist")) {
			str = "登録";
			userId = request.getParameter("userId");

			for(int i = 0 ; ArrayUserId[i] != null ; i++) {
				if(ArrayUserId[i].equals(userId)) {
					session.setAttribute("isRegisteredUserId", true);
					break;
				}
			}
		}

		if((Boolean)session.getAttribute("isRegisteredUserId")) {
			RequestDispatcher dispatch = request.getRequestDispatcher("view/USregist.jsp");
			dispatch.forward(request, response);

		} else {
			MyDBAccess model = new MyDBAccess();
			try{
				model.open();

				if(execProcess.equals("userRegist")) {
					sql = "INSERT"
						+ " INTO"
						+ " ユーザ情報 (user_name, user_id, password, admin_flg, delete_flg,"
						+ " create_date, create_user, update_date, update_user) "
						+ " VALUES"
						+ " ('"+ username +"', '"+ userId +"', '"+ hashedpassword +"', FALSE, FALSE,"
						+ " current_timestamp, '"+ createuser +"', current_timestamp, '"+ updateuser +"');";

				} else if(execProcess.equals("update")) {
					sql = "UPDATE"
						+ " ユーザ情報 SET"
						+ " user_id = '"+ userId +"',"
						+ " user_name = '"+ username +"',"
						+ " update_date = current_timestamp,"
						+ " update_user = '"+ updateuser +"'"
						+ " WHERE"
						+ " user_id='"+ userId +"';";

						if(session.getAttribute("userId").equals(userId)){
							session.setAttribute("userName", username);
						}
				}

				model.execute(sql);
				model.close();

			} catch(Exception e) {
				e.printStackTrace();
			}

			System.out.println("ユーザ " + userId + " は " + str + " されました");
			RequestDispatcher dispatch = request.getRequestDispatcher("/USshow");
			dispatch.forward(request, response);

		}
	}

}