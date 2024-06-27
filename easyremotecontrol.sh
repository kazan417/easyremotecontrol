###автор Казанцев Михаил Валеьевич (kazan417@mail.ru) лицензия MIT
SYSTEMD="/etc/systemd/system/x11vnc.service"
PACK="x11vnc"
PASS="/etc/vncpasswd"
PORT="5900"

function main() {
  if [[ "$EUID" -ne 0 ]]; then
    printf "%s\\n" "Недостаточно прав! Запустите скрипт через sudo или от root"
    exit 1
  fi
}

function install() {
  if [[ $(which apt) ]]; then
      apt-get install ${PACK} -y
  elif [[ $(which yum) ]]; then
      yum install ${PACK} -y
  fi

  if [[ $? == 0 ]]; then
      clear
      printf "\n%s\n" "Установка ${PACK}: [OK]"
  else
      printf "\n%s\n" "Установка ${PACK}: [FAIL]"
      exit 1
  fi
}

function settings() {
  printf "\n%s:\n" "Введите пароль для удаленного доступа"
  read mypass
  x11vnc -storepasswd "$mypass" ${PASS}

  cat > ${SYSTEMD} <<EOF
[Unit] 
Description=Start x11vnc at startup. 
After=multi-user.target 

[Service] 
Type=simple 
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbport ${PORT} -shared -dontdisconnect -rfbauth ${PASS} -o /var/log/x11vnc.log

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable --now x11vnc.service 1> /dev/null
}

function final() {
  printf "\n%s\n" "Настройка ${PACK}: [OK]"
  exit 0
}


main
install
settings
final
