package control;
import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/FMlogout")
public class FMlogout extends HttpServlet{

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException{

		/* httpsessionで権限を持たせる */
		HttpSession session = request.getSession(true);

		if (session == null) {
			System.out.println("セッションは破棄されました");
		} else {
			System.out.println("セッションが残っています");
		}

		session.invalidate();
		session = request.getSession(false);
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/view/login.jsp");

		if (session == null) {
			System.out.println("セッションは破棄されました");
			dispatch.forward(request, response); // 画面遷移 セッション不具合の原因
		} else {
			System.out.println("セッションが残っています");
		}
		session = request.getSession(false);
	}
}