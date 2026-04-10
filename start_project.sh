#!/bin/zsh

echo "===== Đang khởi động PostgreSQL ====="
# Lệnh khởi động PostgreSQL 16 qua service trên Mac
sudo launchctl load /Library/LaunchDaemons/postgresql-16.plist 2>/dev/null || echo "PostgreSQL có thể đã chạy hoặc cần quyền khởi động."
echo "PostgreSQL đã được kích hoạt!"
echo ""

echo "===== Đang dọn dẹp và Build code ====="
mvn clean install
echo ""

echo "===== Đang chạy Máy chủ Tomcat 10 (thông qua Maven Cargo) ====="
mvn cargo:run
