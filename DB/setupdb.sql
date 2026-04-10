-- ============================================================================
-- データベース初期化スクリプト (FamilyMart 販売管理システム)
-- ターゲット: PostgreSQL 16 (Mac環境対応)
-- ============================================================================

-- 1. 既存の接続を終了し、データベースを新規作成
SELECT pg_terminate_backend(pid) FROM pg_stat_activity 
WHERE datname = 'familymart' AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS familymart;

CREATE DATABASE familymart
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       CONNECTION LIMIT = -1;

-- データベースへ接続
\c familymart

-- 2. Table: "ユーザ情報" (User Information)
CREATE TABLE public."ユーザ情報"
(
  user_name character varying(8) NOT NULL,
  user_id character varying(8) NOT NULL,
  password character(60) NOT NULL, -- BCryptハッシュ用
  admin_flg boolean NOT NULL DEFAULT false,
  delete_flg boolean NOT NULL DEFAULT false,
  create_date timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  create_user character varying(8) NOT NULL,
  update_date timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_user character varying(8) NOT NULL,
  management_flg boolean NOT NULL DEFAULT false,
  CONSTRAINT "ユーザ情報_pkey" PRIMARY KEY (user_id)
);
ALTER TABLE public."ユーザ情報" OWNER TO postgres;

-- 3. Table: "出店計画" (Store Opening Plan)
CREATE TABLE public."出店計画"
(
  "店舗id" character varying(4) NOT NULL,
  "店舗名" text,
  "都道府県" text,
  "出店日" date,
  "住所" text,
  deleted boolean NOT NULL DEFAULT false,
  CONSTRAINT "出店計画_pkey" PRIMARY KEY ("店舗id")
);
ALTER TABLE public."出店計画" OWNER TO postgres;

-- 4. Table: "商品データ" (Product Data)
CREATE TABLE public."商品データ"
(
  "商品コード" character varying(4) NOT NULL,
  "商品名" text,
  "販売会社" text,
  "ジャンル" text,
  "販売日" date,
  "価格" integer,
  "仕入れ値" integer,
  "画像" text,
  CONSTRAINT "商品データ_pkey" PRIMARY KEY ("商品コード")
);
ALTER TABLE public."商品データ" OWNER TO postgres;

-- 5. Table: "売上データ" (Sales Data)
CREATE TABLE public."売上データ"
(
  "売上コード" character varying(4) NOT NULL,
  "商品コード" character varying(4),
  "数量" integer,
  "日付" date,
  "店舗id" character varying(4),
  CONSTRAINT "売上データ_pkey" PRIMARY KEY ("売上コード")
);
ALTER TABLE public."売上データ" OWNER TO postgres;

-- 6. Table: "年俸" (Salary Data)
CREATE TABLE public."年俸"
(
  "氏名" text NOT NULL,
  "店舗id" character varying(4),
  "年俸" integer,
  CONSTRAINT "年俸_pkey" PRIMARY KEY ("氏名")
);
ALTER TABLE public."年俸" OWNER TO postgres;

-- 7. Table: "経費" (Expenses)
CREATE TABLE public."経費"
(
  "店舗id" character varying(4) NOT NULL,
  "光熱費" integer,
  "テナント料" integer,
  CONSTRAINT "経費_pkey" PRIMARY KEY ("店舗id")
);
ALTER TABLE public."経費" OWNER TO postgres;

-- 8. Table: "カレンダー情報" (Calendar/Schedule)
CREATE TABLE public."カレンダー情報"
(
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title character varying(255) NOT NULL,
  start_at timestamp without time zone NOT NULL,
  end_at timestamp without time zone,
  is_all_day boolean NOT NULL DEFAULT false,
  color character varying(32) NOT NULL DEFAULT '#3788d8',
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE public."カレンダー情報" OWNER TO postgres;

-- ============================================================================
-- 9. テスト用データ (Dummy Data) 
-- ※CSVファイルは.gitignoreにより除外されているため、初期表示用に以下のデータを投入します。
-- ============================================================================

-- 管理者ユーザーの追加 (Password: admin123 のBCryptハッシュ例)
INSERT INTO public."ユーザ情報" (user_name, user_id, password, admin_flg, create_user, update_user)
VALUES ('管理者', 'admin', '$2a$10$X.pY6.SUpvQ4Iq.vA/YfTeZ8vD6uTz9h.Ff.WjIeS7hL/pY.v.6u.', true, 'SYSTEM', 'SYSTEM');

-- サンプル店舗の追加
INSERT INTO public."出店計画" ("店舗id", "店舗名", "都道府県", "出店日", "住所")
VALUES ('S001', 'ファミリーマート 渋谷店', '東京都', '2024-01-01', '東京都渋谷区...');

-- サンプル商品の追加
INSERT INTO public."商品データ" ("商品コード", "商品名", "ジャンル", "価格", "仕入れ値")
VALUES 
('P001', 'ファミチキ', 'ホットスナック', 220, 150),
('P002', 'おにぎり（鮭）', '食品', 150, 100);

-- ============================================================================
-- 10. CSVインポート (ローカル環境用)
-- ※必要に応じてコメントアウトを解除して使用してください。
-- ============================================================================
-- \copy "ユーザ情報" from 'ユーザ情報_utf8.csv' with encoding 'utf-8' csv
-- \copy "出店計画" from '出店計画_utf8.csv' with encoding 'utf-8' csv
-- \copy "商品データ" from '商品データ.csv' with encoding 'utf-8' csv
-- \copy "売上データ" from '売上データ_utf8.csv' with encoding 'utf-8' csv
-- \copy "年俸" from '年俸.csv' with encoding 'utf-8' csv
-- \copy "経費" from '経費_utf8.csv' with encoding 'utf-8' csv