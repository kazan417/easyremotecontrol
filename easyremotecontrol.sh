#!/bin/bash
###автор Казанцев Михаил Валеьевич (kazan417@mail.ru) лицензия MIT
echo "скрипт настройки удаленного доступа"
echo "введите желаемый пароль для удаленного доступа"
read mypass  
if [ -n "$(command -v yum)" ]; then
  if [[ $EUID -ne 0 ]]; then
     echo "введите пароль суперпользователя"
     su -c 	"/bin/bash ./easyremotecontrol.sh"
     exit 0
  fi
  if [[ $EUID -ne 0 ]]; then
  echo "ошибка получения прав суперпользователя"
  exit 1
  fi
echo "установка x11vnc"
yum install x11vnc -y
echo "прописываем файл автозагрузки"
echo "
[Unit] 
Description=Start x11vnc at startup. 
After=multi-user.target 

[Service] 
Type=simple 
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbport 5900 -shared -dontdisconnect -rfbauth /etc/vncpasswd -o /var/log/x11vnc.log

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/x11vnc.service
x11vnc -storepasswd "$mypass" /etc/vncpasswd
echo "включаем автозагрузку vncserver"
systemctl enable --now x11vnc.service
echo "удаленный доступ настроен"
read
fi
if [ -n "$(command -v apt-get)" ]; then
	echo "найден apt-get устанавливаем требуемые программы с помощью apt-get"
  if [[ $EUID -ne 0 ]]; then
     echo "введите пароль суперпользователя"
     su -c 	"/bin/bash ./easyremotecontrol.sh"
     exit 0
  fi
  if [[ $EUID -ne 0 ]]; then
  echo "ошибка получения прав суперпользователя"
  exit 1
  fi
echo "установка x11vnc"
sudo apt-get install x11vnc -y
x11vnc -storepasswd "$mypass" /etc/vncpasswd
echo "
[Unit]
Description=Start x11vnc at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbport 5900 -shared -dontdisconnect -rfbauth /etc/vncpasswd -o /var/log/x11vnc.log

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/x11vnc.service
x11vnc -storepasswd "$mypass" /etc/vncpasswd
echo "включаем автозагрузку vncserver"
systemctl enable --now x11vnc.service
echo "удаленный доступ настроен"
read
fi

