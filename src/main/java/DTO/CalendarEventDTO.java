package DTO;

import java.time.LocalDateTime;

public class CalendarEventDTO {
private int id;                 // 予定ID (SERIAL)
private String title;           // 予定タイトル (VARCHAR)
private LocalDateTime startAt;  // 開始日時 (TIMESTAMP)
private LocalDateTime endAt;    // 終了日時 (TIMESTAMP)
private boolean isAllDay;       // 終日フラグ (BOOLEAN)
private String color;           // カラーコード (VARCHAR)
private LocalDateTime createdAt;// 作成日時 (TIMESTAMP)

// デフォルトコンストラクタ
public CalendarEventDTO() {}

// 全フィールドを持つコンストラクタ（データの詰め替えに便利です）
public CalendarEventDTO(int id, String title, LocalDateTime startAt, LocalDateTime endAt, 
                        boolean isAllDay, String color, LocalDateTime createdAt) {
    this.id = id;
    this.title = title;
    this.startAt = startAt;
    this.endAt = endAt;
    this.isAllDay = isAllDay;
    this.color = color;
    this.createdAt = createdAt;
}

// --- Getter / Setter ---
public int getId() { return id; }
public void setId(int id) { this.id = id; }

public String getTitle() { return title; }
public void setTitle(String title) { this.title = title; }

public LocalDateTime getStartAt() { return startAt; }
public void setStartAt(LocalDateTime startAt) { this.startAt = startAt; }

public LocalDateTime getEndAt() { return endAt; }
public void setEndAt(LocalDateTime endAt) { this.endAt = endAt; }

public boolean isAllDay() { return isAllDay; }
public void setAllDay(boolean isAllDay) { this.isAllDay = isAllDay; }

public String getColor() { return color; }
public void setColor(String color) { this.color = color; }

public LocalDateTime getCreatedAt() { return createdAt; }
public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

}