#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOMCAT_HOME="${1:-/Users/user/Downloads/apache-tomcat-10.1.54}"
APP_NAME="FamilyMart"
BUILD_DIR="$ROOT_DIR/build/$APP_NAME"
CLASSES_DIR="$BUILD_DIR/WEB-INF/classes"
WEBAPP_DIR="$ROOT_DIR/src/main/webapp"
JAVA_SOURCES=("${(@f)$(find "$ROOT_DIR/src/main/java" -name '*.java' | sort)}")

rm -rf "$BUILD_DIR"
mkdir -p "$CLASSES_DIR"

javac -encoding UTF-8 \
  -cp "$TOMCAT_HOME/lib/*:$WEBAPP_DIR/WEB-INF/lib/*" \
  -d "$CLASSES_DIR" \
  "${JAVA_SOURCES[@]}"

cp -R "$WEBAPP_DIR/." "$BUILD_DIR/"

cat > "$ROOT_DIR/build/${APP_NAME}.xml" <<EOF
<Context docBase="$BUILD_DIR" path="/$APP_NAME" reloadable="true" />
EOF

printf 'Prepared %s at %s\n' "$APP_NAME" "$BUILD_DIR"
printf 'Context descriptor ready at %s\n' "$ROOT_DIR/build/${APP_NAME}.xml"
