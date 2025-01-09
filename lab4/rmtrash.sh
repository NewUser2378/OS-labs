#!/bin/bash

# Проверяем наличие переданного параметра
if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Имя файла
file="$1"

# Домашний каталог пользователя
home_dir="$HOME"

# Путь к скрытому каталогу trash
trash_dir="$home_dir/trash"

# Путь к файлу trash.log
log_file="$home_dir/trash.log"

# Проверяем наличие скрытого каталога trash, и если его нет, создаем
if [ ! -d "$trash_dir" ]; then
    mkdir "$trash_dir"
fi

# Генерируем  имя для  ссылки
link_name="$trash_dir/$(date +"%Y%m%d%H%M%S")_$file"

# Создаем жесткую ссылку в каталоге trash
ln "$file" "$link_name"

# Удаляем файл в текущем каталоге
rm "$file"

# Записываем информацию в файл trash.log
echo "Deleted file: $file" >> "$log_file"
echo "link created: $link_name" >> "$log_file"

echo "File '$file' has been moved to trash."
