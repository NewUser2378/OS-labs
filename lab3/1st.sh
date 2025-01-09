#!/bin/bash

# Создадим директорию test в домашней директории
mkdir ~/lab3/test 2>/dev/null && echo "catalog test was created successfully" >> ~/lab3/report

# Создаем файл с именем даты и времени в директории /lab3/test/
touch ~/lab3/test/$(date +"%Y%m%d_%H%M%S")_Script_Start_Time

# Делаем запрос на хост www.net_nikogo.ru с помощью ping
ping -c 1 www.net_nikogo.ru  || echo "$(date +"%Y-%m-%d %H:%M:%S") Ping to www.net_nikogo.ru failed" >> ~/lab3/report

