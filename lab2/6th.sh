#!/bin/bash

max_memory=0
pid_with_max_memory=0

while read -r process_id; do
    memory_size=$(awk '{print $1}' "/proc/$process_id/statm" 2>/dev/null)   #извлекаем информацию о потребляемой памяти процесса из файла
    if [[ -n $memory_size && $memory_size -gt $max_memory ]]; then  #Проверяем memory_size не пусто и больше текущего максимального значения max_memory и если что перезаписываем
        max_memory=$memory_size
        pid_with_max_memory=$process_id
    fi
done < <(ps -ax -o pid --no-headers)

echo "Pid using proc: $pid_with_max_memory"

top_pid=$(top -n1 -b -o +%MEM | awk 'NR>7 {print $1; exit}')  # Сортируем вывод по столбцу %MEM 
#'NR>7 для того чтобы убрать первые бесполезные строки, awk, чтобы извлечь идентификатор процесса с наибольшей памятью
echo "Pid using top: $top_pid"
