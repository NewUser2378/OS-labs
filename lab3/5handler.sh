#!/bin/bash

# Проверим наличие канала
if [ -z "$1" ]; then
    echo "Usage: $0 <pipe_name>"
    exit 1
fi

# Устанавливаем сложение cначала
mode="+"

result=1

# Открываем канал для чтения
PIPE_NAME=$1
exec 3<> $PIPE_NAME

# Обработаем данные из канала
while read line <&3; do
    case $line in
        "+")
            mode="+"
            ;;
        "*")
            mode="*"
            ;;
        [0-9]*)
            if [ "$mode" == "+" ]; then
                result=$((result + line))
            elif [ "$mode" == "*" ]; then
                result=$((result * line))
            fi
            ;;
        "QUIT")
            echo "Result: $result"
            break
            ;;
        *)
            echo "Error with data." >&2
            exit 1
            ;;
    esac
done

# Закрываем именованный канал
exec 3>&-

# Завершаем работу
exit 0
