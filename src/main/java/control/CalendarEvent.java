package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.CalendarEventDAO;
import DTO.CalendarEventDTO;

@WebServlet("/CalendarEvent")
public class CalendarEvent extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            CalendarEventDAO dao = new CalendarEventDAO();
            List<CalendarEventDTO> list = dao.findAll();
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                CalendarEventDTO dto = list.get(i);
                json.append("{")
                    .append("\"id\":\"").append(dto.getId()).append("\",")
                    .append("\"title\":\"").append(dto.getTitle()).append("\",")
                    .append("\"start\":\"").append(dto.getStartAt()).append("\",")
                    .append("\"end\":\"").append(dto.getEndAt() != null ? dto.getEndAt() : "").append("\",")
                    .append("\"allDay\":").append(dto.isAllDay()).append(",")
                    .append("\"color\":\"").append(dto.getColor()).append("\"")
                    .append("}");
                if (i < list.size() - 1) json.append(",");
            }
            json.append("]");
            
            PrintWriter out = response.getWriter();
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. DTOのインスタンス化
        CalendarEventDTO dto = new CalendarEventDTO();

        // 2. セッターを利用してリクエストパラメータをDTOに詰め込む
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            dto.setId(Integer.parseInt(idStr));
        }

        dto.setTitle(request.getParameter("title"));
        dto.setColor(request.getParameter("color"));
        boolean isAllDay = Boolean.parseBoolean(request.getParameter("allDay"));
        dto.setAllDay(isAllDay);

        // 日時文字列のパース（解析）と補完ロジック
        String startStr = request.getParameter("start");
        String endStr = request.getParameter("end");

        try {
            if (startStr != null && !startStr.isEmpty()) {
                if (startStr.length() == 10) startStr += "T00:00:00";
                dto.setStartAt(LocalDateTime.parse(startStr));
            }

            if (endStr != null && !endStr.isEmpty()) {
                if (endStr.length() == 10) endStr += "T00:00:00";
                dto.setEndAt(LocalDateTime.parse(endStr));
            }

            // 3. 準備が整ったDTOをDAOに渡す
            CalendarEventDAO dao = new CalendarEventDAO();
            if (dto.getId() > 0) {
                // IDが存在する場合は更新（UPDATE）
                dao.update(dto);
            } else {
                // IDが存在しない場合は新規登録（INSERT）
                dao.insert(dto);
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                CalendarEventDAO dao = new CalendarEventDAO();
                dao.delete(id);
                response.setStatus(HttpServletResponse.SC_OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}