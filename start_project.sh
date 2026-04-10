#!/bin/zsh

echo "===== PostgreSQLを起動します ====="
# Mac環境でサービス経由によりPostgreSQL 16を起動
sudo launchctl load /Library/LaunchDaemons/postgresql-16.plist 2>/dev/null || echo "PostgreSQLは既に起動済み、または権限が必要です。"
echo "PostgreSQLの起動が完了しました。"
echo ""

echo "===== プロジェクトのクリーンおよびビルドを実行します ====="
mvn clean install
echo ""

echo "===== Maven Cargoを使用してTomcat 10を起動します ====="
mvn cargo:run