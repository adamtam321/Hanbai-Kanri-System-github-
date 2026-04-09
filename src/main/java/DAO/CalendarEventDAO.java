package DAO;

import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import DTO.CalendarEventDTO;
import model.MyDBAccess;

public class CalendarEventDAO {
	/**
     * 全ての予定を取得するメソッド
     */
    public List<CalendarEventDTO> findAll() throws Exception {
        List<CalendarEventDTO> list = new ArrayList<>();
        MyDBAccess db = new MyDBAccess();
        
        try {
            db.open();
            String sql = "SELECT * FROM カレンダー情報 ORDER BY start_at ASC";
            ResultSet rs = db.getResultSet(sql);
            
            if (rs != null) {
                while (rs.next()) {
                    CalendarEventDTO dto = new CalendarEventDTO();
                    // ResultSetから値を取り出しDTOにセット
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    
                    // TIMESTAMP型をLocalDateTimeに変換
                    Timestamp startTs = rs.getTimestamp("start_at");
                    if (startTs != null) dto.setStartAt(startTs.toLocalDateTime());
                    
                    Timestamp endTs = rs.getTimestamp("end_at");
                    if (endTs != null) dto.setEndAt(endTs.toLocalDateTime());
                    
                    dto.setAllDay(rs.getBoolean("is_all_day"));
                    dto.setColor(rs.getString("color"));
                    
                    Timestamp createdTs = rs.getTimestamp("created_at");
                    if (createdTs != null) dto.setCreatedAt(createdTs.toLocalDateTime());
                    
                    list.add(dto);
                }
            }
        } finally {
            db.close();
        }
        return list;
    }

    /**
     * 新規予定を保存するメソッド
     */
    public void insert(CalendarEventDTO dto) throws Exception {
        MyDBAccess db = new MyDBAccess();
        try {
            db.open();
            // SQL文の組み立て
            // ※LocalDateTimeはtoString()でISO形式になるためPostgreSQLが解釈可能です
            String sql = "INSERT INTO カレンダー情報 (title, start_at, end_at, is_all_day, color) VALUES ("
                + "'" + dto.getTitle() + "', "
                + "'" + dto.getStartAt() + "', "
                + (dto.getEndAt() != null ? "'" + dto.getEndAt() + "'" : "NULL") + ", "
                + dto.isAllDay() + ", "
                + "'" + dto.getColor() + "')";
            
            db.execute(sql);
        } finally {
            db.close();
        }
    }
    
    public void delete(int id) throws Exception {
        MyDBAccess db = new MyDBAccess();
		try {
			db.open();
			String sql = "DELETE FROM カレンダー情報 WHERE id = " + id;
			db.execute(sql);
		} finally {
			db.close();
		}
    }
    
    public void update(CalendarEventDTO dto) throws Exception {
        MyDBAccess db = new MyDBAccess();
        try {
            db.open();
            
            // SQL文の組み立て
            String sql = "UPDATE カレンダー情報 SET "
                + "title = '" + dto.getTitle() + "', "
                + "start_at = '" + dto.getStartAt() + "', "
                + "end_at = " + (dto.getEndAt() != null ? "'" + dto.getEndAt() + "'" : "NULL") + ", "
                + "is_all_day = " + dto.isAllDay() + ", "
                + "color = '" + dto.getColor() + "' "
                + "WHERE id = " + dto.getId();
            
            db.execute(sql);
        } finally {
            db.close();
        }
    }
    

}