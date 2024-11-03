#!/bin/bash

# 显示选项菜单
echo "请选择要执行的操作:"
select option in "允许系统以root形式进行SSH连接" "更改更新源并执行更新命令" "安装必要工具" "安装Docker并添加密钥及APT源" "退出"
do
    case $REPLY in
        1)
            # 允许以root形式进行ssh连接
            sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
            systemctl restart sshd
            echo "已允许系统以root形式进行SSH连接."
            ;;
        2)
            # 下载不同的更新源文件
            wget -O source1.list https://example.com/source1.list
            wget -O source2.list https://example.com/source2.list
            # 可继续添加其他更新源文件的下载链接

            # 显示可选的更新源文件列表
            echo "可选的更新源文件:"
            select source_file in "阿里云源.list" "清华大学源.list"
            do
                case $REPLY in
                    1)
                        cp source1.list /etc/apt/sources.list
                        break
                        ;;
                    2)
                        cp source2.list /etc/apt/sources.list
                        break
                        ;;
                    *)
                        echo "无效选项，请重新选择."
                        ;;
                esac
            done

            # 执行更新命令
            apt update
            apt upgrade -y
            ;;
        3)
            # 安装必要工具
            apt-get install -y wget apt-transport-https gnupg2 software-properties-common curl vim
            echo "必要工具安装完成."
            ;;
        4)
            # 安装Docker并添加密钥及APT源
            read -p "是否要安装Docker并添加密钥及APT源? (y/n): " install_docker_apt
            if [ "$install_docker_apt" = "y" ]; then
                # 添加密钥
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                echo "Docker密钥添加完成."

                # 添加Docker的APT源
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://download.docker.com/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
                
                # 安装Docker
                apt-get update
                apt-get install -y docker.io
                systemctl start docker
                systemctl enable docker
                echo "Docker安装完成."
            else
                echo "未安装Docker及添加密钥及APT源."
            fi
            ;;
        5)
            echo "退出脚本."
            break
            ;;
        *)
            echo "无效选项，请重新选择."
            ;;
    esac
done
