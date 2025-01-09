#!/bin/bash


current_date=$(date +'%Y-%m-%d')

# Порог минимальной разницы 
min_difference=365

# делаем файлы для хранения информации о выбранной резервной копии
backup_info_file=".backup_info"
min_diff_file=".min_diff"

# Создаем каталог для восстановления, если его нет
restore_dir=~/restore
mkdir -p "$restore_dir"

# Ищем каталоги резервных копий
backup_dirs=$(find ~/ -maxdepth 1 -type d -regex ".*/Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" -print0 2>/dev/null)

# Перебираем найденные каталоги
selected_backup=""
min_diff=$min_difference

while IFS= read -r -d '' backup_dir; do
    backup_date=$(echo "$backup_dir" | awk -F'-' '{print $2"-"$3"-"$4}')
    diff_in_days=$(( ( $(date -d "$current_date" +%s) - $(date -d "$backup_date" +%s) ) / 86400 ))

    # Проверяем минимальную разницу
    if [ "$min_diff" -ge "$diff_in_days" ]; then
        min_diff="$diff_in_days"
        selected_backup="$backup_dir"
    fi
done <<< "$backup_dirs"

# Записываем информацию о выбранной резервной копии
echo "$selected_backup" > "$backup_info_file"
echo "$min_diff" > "$min_diff_file"

# Если не найдено резервных копий
if [ -z "$selected_backup" ]; then
    echo "No directory to backup."
else
    # Копируем файлы из выбранной резервной копии
    find "$selected_backup" -mindepth 1 -maxdepth 1 -type f -exec cp -a {} "$restore_dir" \;
fi
