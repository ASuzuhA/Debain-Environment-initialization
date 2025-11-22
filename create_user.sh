#!/bin/bash

# 提示用户输入用户名
echo "请输入要创建的用户名："
read username

# 提示用户输入密码
echo "请输入密码："
read -s password

# 提示用户输入用户组名
echo "请输入用户组名："
read groupname

# 创建用户组
if ! getent group "$groupname" > /dev/null 2>&1; then
    echo "用户组 $groupname 不存在，正在创建..."
    groupadd "$groupname"  # 不使用 sudo
else
    echo "用户组 $groupname 已存在。"
fi

# 创建新用户并将其添加到指定的用户组
useradd -m -g "$groupname" "$username"  # 不使用 sudo

# 设置密码
echo "$username:$password" | chpasswd  # 不使用 sudo

# 为该用户指定命令解释程序
usermod -s /bin/bash "$username"  # 不使用 sudo

# 为该用户添加 sudo 权限（如果需要）
# 检查是否在 root 用户下，直接修改 sudoers 文件
echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers  # 不使用 sudo

# 设置新用户目录的读写权限
chown "$username:$username" -R /home/"$username"  # 不使用 sudo

# 提示切换到新用户
echo "用户 $username 创建成功。现在可以使用 su 命令切换到 $username 用户并进行操作。"

# 切换到新用户
echo "运行以下命令切换到新用户并开始操作："
echo "su $username"
