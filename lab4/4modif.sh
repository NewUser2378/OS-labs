#!/bin/bash

search_dir="/home/user/"

# Создаем массив для информации о файлах
declare -A files

# Находим все файлы в директории и её поддиректориях
find "$search_dir" -type f | while read file; do
  # Вычисляем размер и контрольную сумму файла
  file_info=$(stat -c "%s:%n" "$file")
  
  # Если файл с такими данными есть то, это дубликат
  if [ -n "${files[$file_info]}" ]; then
    echo "Copy:"
    echo "1. $file"
    echo "2. ${files[$file_info]}"
    echo "---"
  else
    # Сохраняем информацию в массив
    files["$file_info"]=$file
  fi
done
if [ ${#files[@]} -eq 0 ]; then
  echo "No copies."
fi
