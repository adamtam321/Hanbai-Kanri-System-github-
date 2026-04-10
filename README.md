## 販売管理システム (Sales Management System)

本プロジェクトは、Java Web技術を活用した、コンビニエンスストア向けの販売・在庫管理システムです。データの正確性とセキュリティ、開発プロセスの自動化に重点を置いて設計されています。

---

##  プロジェクト概要 (Overview)

本システムは、店舗の日常的な業務（ログイン管理、売上登録、商品在庫の確認など）を効率化することを目的としています。

- **主な機能:**
  - **ユーザー認証:** BCryptによるパスワードハッシュ化を用いた安全なログイン機能。
  - **販売管理:** 商品データの登録、更新、および売上管理。
  - **自動化:** Mavenおよびシェルスクリプトを用いたワンクリックでの開発環境構築。

---

##  技術スタック (Technologies)

本プロジェクトでは、モダンなJava開発環境と堅牢なデータベース構成を採用しています。

| カテゴリ | 技術詳細 |
| :--- | :--- |
| **Backend** | Java 20, Jakarta Servlet (JSP/Servlet) |
| **Build Tool** | Maven 3.9.14 |
| **Database** | PostgreSQL 16 |
| **Security** | BCrypt Password Hashing |
| **Server** | Apache Tomcat 10.1 (Jakarta EE 10) |
| **Development** | macOS (Intel), VS Code, Maven Cargo Plugin |

---

##  セットアップと実行方法 (Setup & Run)

### 1. データベースの準備
PostgreSQLにてデータベース（`familymart`）を作成し、以下のコマンドでスキーマを構築してください。
```bash
psql -U postgres -d familymart -f DB/setupdb.sql
```

### 2. システムの起動
開発効率を最大化するため、自動化スクリプト（`start_project.sh`）を用意しています。ターミナルで以下のコマンドを実行してください。
```bash
chmod +x start_project.sh
./start_project.sh
```
*スクリプト実行後、自動的にPostgreSQLが起動し、MavenによるビルドとTomcatへのデプロイが行われます。*

### 3. アクセス
ブラウザで以下のURLにアクセスしてください：
 **`http://localhost:8080/FamilyMart/`**

---

## テスト用アカウント (Test Account)

動作確認のため、以下のテスト用アカウントをご利用いただけます。

- **ユーザーID:** admin  
- **パスワード:** admin  

※ 本アカウントは開発・検証用です。

---

## プロジェクト構造 (Project Structure)

```text
.
├── src/main/java        # ビジネスロジック、コントローラー、DBアクセス
├── src/main/webapp      # JSP、CSS、JavaScript、Web設定ファイル
├── DB/                  # データベース設計書およびSQLスクリプト
├── pom.xml              # Mavenプロジェクト構成および依存関係管理
└── start_project.sh     # 開発環境自動起動スクリプト
```

---

**【技術的なこだわり】**
1. **セキュリティの担保:** ユーザーの機密情報を守るため、パスワードを直接DBに保存せず、BCryptアルゴリズムを使用してハッシュ化を行っています。
2. **効率的な開発フロー:** Maven Cargo Pluginを活用し、ローカル環境へのTomcatインストール作業を不要にしました。これにより、環境に依存しない迅速なデプロイが可能です。
3. **コードの保守性:** 責務を明確に分けたディレクトリ構造を採用し、将来的な機能拡張やメンテナンスが容易になるよう設計しました。

---

## 今後の改善予定 (Future Roadmap)

今後は以下の技術を導入し、さらなる最適化を図る予定です：

- **Docker & Docker Compose:** 環境に依存しない「コンテナ化」によるデプロイの完全自動化。
- **Spring Boot への移行:** 内蔵サーバーを活用し、よりスケーラブルなマイクロサービス構成へ。
- **Flyway / Liquibase:** データベース・マイグレーションの自動化による管理コストの削減。

