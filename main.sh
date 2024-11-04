#!/bin/bash

# 显示选项菜单
echo "请选择要执行的操作:"
select option in "允许系统以root形式进行SSH连接" "更改更新源并执行更新命令" "安装必要工具" "退出"
do
    case $REPLY in
        1)
            # 允许以root形式进行ssh连接
            sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
            sed -i 's/#PermitRootLogin.*prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
            systemctl restart sshd
            echo "已允许系统以root形式进行SSH连接."
            ;;
        2)

            # 显示可选的更新源文件列表
            echo "可选的更新源文件:"
            select source_file in "aliyun.list" "qinghua.list"
            do
                case $REPLY in
                    1)
                        cp aliyun.list /etc/apt/sources.list
                        break
                        ;;
                    2)
                        cp qinghua.list /etc/apt/sources.list
                        break
                        ;;
                    *)
                        echo "无效选项，请重新选择."
                        ;;
                esac
            done

            # 执行更新命令
            apt update
            ;;
        3)
            # 安装必要工具
            apt-get install -y wget apt-transport-https gnupg2 software-properties-common curl vim
            echo "必要工具安装完成."
            ;;
        4)
            echo "退出脚本."
            break
            ;;
        *)
            echo "无效选项，请重新选择."
            ;;
    esac
done
