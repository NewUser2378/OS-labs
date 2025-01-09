#!/bin/bash

# Проверяем, передан ли аргумент
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

# ищем записи в trash.log по имени файла
matches=$(grep "^$filename " trash.log)

if [ -z "$matches" ]; then
    echo "sorry '$filename' was not found."
    exit 1
fi

# Вывод найденных записей с запросом подтверждения
echo "found this in trash.log for '$filename':"
echo "$matches"

read -p "Are we going to upload files? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "canceled by user."
    exit 1
fi

# Перебираем записи и восстанавливаем файлыт в них
while IFS= read -r line; do
    # берем путь и имя из записи
    full_path=$(echo "$line" | awk '{print $2}')

    # смотрим есть ли каталог
    if [ ! -d "$(dirname "$full_path")" ]; then
        echo "dir $(dirname "$full_path") do not exist.Reload it to home dir."
        destination="$HOME/$(basename "$full_path")"
    else
        destination="$full_path"
    fi

    # пытаемся восстановить файл
    if ln "$HOME/.trash/$filename" "$destination" 2>/dev/null; then
        echo "Файл '$filename' now in: $destination"
        # Удаляем запись из trash.log
        sed -i "/^$filename /d" trash.log
    else
        read -p "Cant create link. Enter new name: " new_filename
        mv "$HOME/.trash/$filename" "$HOME/.trash/$new_filename"
        filename=$new_filename
        echo "file '$filename' returned in : $destination"
        # Удаляем запись из trash.log
        sed -i "/^$filename /d" trash.log
    fi

done <<< "$matches"

echo "process finished."
