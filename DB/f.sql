-- 1. Xóa bảng cũ nếu đã tồn tại để làm sạch
DROP TABLE IF EXISTS public."ユーザ情報" CASCADE;

-- 2. Tạo lại bảng (Bạn copy đoạn CREATE TABLE từ file f.sql hoặc setupdb.sql vào đây)
-- Ví dụ:
CREATE TABLE public."ユーザ情報" (
    user_name character varying(8),
    user_id character varying(8) PRIMARY KEY,
    password character varying(60),
    admin_flg boolean,
    delete_flg boolean,
    create_date timestamp without time zone
);

-- 3. Chèn dữ liệu mẫu ngay lập tức
INSERT INTO public."ユーザ情報" (user_name, user_id, password, admin_flg, delete_flg, create_date)
VALUES ('Admin', 'admin', '123456', true, false, CURRENT_TIMESTAMP);