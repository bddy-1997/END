#!/bin/bash

# 检查是否以root用户运行
if [ "$EUID" -ne 0 ]; then
  echo "请以root用户运行此脚本"
  exit 1
fi

# 更新系统包列表
echo "更新系统包列表..."
apt-get update -y

# 升级已安装的软件包
echo "升级已安装的软件包..."
apt-get upgrade -y

# 开启BBR
echo "开启BBR..."
echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr

# 检查BBR是否开启成功
if [[ $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}') == "bbr" ]]; then
  echo "BBR已成功开启"
else
  echo "BBR开启失败"
  exit 1
fi

# 安装v2ray-agent
echo "安装v2ray-agent..."
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh

echo "脚本执行完毕！"