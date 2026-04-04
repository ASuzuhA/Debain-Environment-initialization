#!/bin/bash
set -e

echo "===== 1. 备份原 sources.list ====="
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "===== 2. 替换为阿里云 Debian 12 源 ====="
cat <<EOF > /etc/apt/sources.list
deb http://mirrors.aliyun.com/debian/ bookworm main contrib non-free
deb-src http://mirrors.aliyun.com/debian/ bookworm main contrib non-free

deb http://mirrors.aliyun.com/debian-security bookworm-security main contrib non-free
deb-src http://mirrors.aliyun.com/debian-security bookworm-security main contrib non-free

deb http://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free
deb-src http://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free

deb http://mirrors.aliyun.com/debian/ bookworm-backports main contrib non-free
deb-src http://mirrors.aliyun.com/debian/ bookworm-backports main contrib non-free
EOF

echo "===== 3. 清理 /etc/apt/sources.list.d/ 中的残留源 ====="
rm -f /etc/apt/sources.list.d/*.list

echo "===== 4. 更新系统 ====="
apt update && apt upgrade -y

echo "===== 5. 安装必要工具 ====="
apt install -y wget gnupg software-properties-common

echo "===== 6. 添加 Temurin (Adoptium) Java 21 源 ====="
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
echo "deb https://packages.adoptium.net/artifactory/deb bookworm main" | tee /etc/apt/sources.list.d/adoptium.list

echo "===== 7. 安装 Java 21 ====="
apt update
apt install -y temurin-21-jdk

echo "===== 8. 配置环境变量 ====="
JAVA_PATH=$(dirname $(dirname $(readlink -f $(which java))))
echo "export JAVA_HOME=$JAVA_PATH" > /etc/profile.d/java.sh
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh
source /etc/profile.d/java.sh

echo "===== 9. 验证安装 ====="
java -version
echo "JAVA_HOME=$JAVA_HOME"

echo "===== 脚本执行完毕，Java 21 安装并配置成功 ====="
