#!/bin/bash

# Проверяем агумента с файлом
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_csv_file>"
    exit 1
fi


input_file=$1

# Проверяем существование файла
if [ ! -f $input_file ]; then
    echo "File not found: $input_file"
    exit 1
fi

# Создаем временный файл для сортировки
temp_sorted_file=$(mktemp)

# Извлекаем артикул и рейтинг сортируем по рейтингк
awk -F ',' '{print $1, $5}' $input_file | sort -k2n > $temp_sorted_file

# берем 5 худших товаров
worst_articles=$(head -n 5 $temp_sorted_file | awk '{print $1}')

# тепрь уже нормальный файл для ответа
worst_file="worst.lst"
echo "$worst_articles" > $worst_file

# Удаляем временный файл
rm $temp_sorted_file

echo "Worst articles written to $worst_file"