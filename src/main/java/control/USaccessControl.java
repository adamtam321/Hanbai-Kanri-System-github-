package control;

import java.io.IOException;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.MyDBAccess;

@WebServlet("/USaccessControl")
public class USaccessControl extends HttpServlet{

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		String actionId	  = request.getParameter("actionId");
		String[] userIdList = request.getParameterValues("userId");

		if("access".equals(actionId) ){
			usAccess(userIdList);
		} else if("delete".equals(actionId)) {
			usDelete(userIdList);
		}

		RequestDispatcher dispatch = request.getRequestDispatcher("/USshow");
		dispatch.forward(request, response);
	}

	// ユーザのアクセス権を変更する関数
	private void usAccess(String[] userIdList){
		Boolean adminflg = true;
		String str = ""; // コンソール表示用

		MyDBAccess model = new MyDBAccess();
		try{
			model.open();

			for(String userId : userIdList){
				if(!(userId.equals(""))){
					String sql = "SELECT admin_flg, delete_flg "
								+ "FROM ユーザ情報 "
								+ "WHERE user_id='" + userId + "'";

					ResultSet rs = null;
					rs = model.getResultSet(sql);

					while(rs.next()) {
						adminflg = rs.getBoolean("admin_flg");
					}

					if(adminflg == false) {
						str = "管理者 ";
						sql = "UPDATE ユーザ情報 "
							+ "SET admin_flg='true' "
							+ "WHERE user_id='" + userId + "'";

					} else {
						str = "一般 ";
						sql = "UPDATE ユーザ情報 "
							+ "SET admin_flg='false' "
							+ "WHERE user_id='" + userId + "'";
					}

					model.execute(sql);
					System.out.println("ユーザ " + userId + " は " + str + "です");
				}
			}

			model.close();

		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	// ユーザを削除する関数
	private void usDelete(String[] userIdList){

		MyDBAccess model = new MyDBAccess();
		try{
			model.open();

			for(String userId : userIdList){
				if(!(userId.equals(""))){
					String sql = "DELETE FROM ユーザ情報 " + "WHERE user_id='" + userId + "'";

					model.execute(sql);

					System.out.println("ユーザ " + userId + " は 削除 されました");
				}
			}

			model.close();

		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}