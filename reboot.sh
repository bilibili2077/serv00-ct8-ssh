#!/bin/bash

red="\033[1;91m"
green="\e[1;32m"
red() { echo -e "\e[1;91m$1\033[0m"; }
green() { echo -e "\e[1;32m$1\033[0m"; }
USERNAME=$(whoami)
HOSTNAME=$(hostname)
WORKDIR="/home/${USERNAME}/logs"
chmod 777 "${WORKDIR}"
cd "${WORKDIR}" || { echo "无法切换到工作目录 ${WORKDIR}"; exit 1; }

# 确保脚本和程序有执行权限
[ -x "${WORKDIR}/nezha.sh" ] || chmod +x "${WORKDIR}/nezha.sh"
[ -x "${WORKDIR}/npm" ] || chmod +x "${WORKDIR}/npm"
[ -x "${WORKDIR}/web" ] || chmod +x "${WORKDIR}/web"
[ -e "${WORKDIR}/config.json" ] || chmod +x "${WORKDIR}/config.json"
[ -x "${WORKDIR}/argo.sh" ] || chmod +x "${WORKDIR}/argo.sh"
[ -x "${WORKDIR}/bot" ] || chmod +x "${WORKDIR}/bot"

ps aux | grep "$(whoami)" | grep -v 'sshd\|bash\|grep' | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
red "已清理所有进程"
nohup ./nezha.sh >/dev/null 2>&1 &
sleep 2
   if pgrep -x 'npm' > /dev/null; then
      green "NEZHA 已重启"
   fi
nohup ./web run -c config.json >/dev/null 2>&1 &
sleep 2
   if pgrep -x 'web' > /dev/null; then
      green "singbox 已重启"
   fi
nohup ./argo.sh >/dev/null 2>&1 &
sleep 2
   if pgrep -x 'bot' > /dev/null; then
      green "ARGO 隧道已重启"
   fi
