#!/bin/bash

# Получаем дату
currentDate=$(date +'%Y-%m-%d')
minAgeThreshold=365

# убираем предыдущие данные
if [ -f .lastBackupDir ]; then
  rm .lastBackupDir
  rm .minAgeDiff
fi

# создаем новую директорию
if ! [ -d ~/source ]; then
  mkdir ~/source
fi

# Создаем файл для информации еслт его нет
if ! [ -f ~/backup-report ]; then
  touch ~/backup-report
fi


  # проверяем является ли backup самым старым или новым в директории
  if [ "$minAgeThreshold" -ge "$ageDiff" ]; then
    minAgeThreshold="$ageDiff"
    echo "$backupDir" > .lastBackupDir
    echo "$minAgeThreshold" > .minAgeDiff
  fi
done

# ищем backup в директории
find ~/ -maxdepth 1 -regex ".*/Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" -type d -print0 2>/dev/null |
while IFS= read -r -d '' backupDir; do
  backupDate=$(echo "$backupDir" | awk -F'-' '{print $2"-"$3"-"$4}')
  ageDiff=$((($(date -d "$currentDate" +%s) - $(date -d "$backupDate" +%s)) / 86400))



# ввод новых переменных 
lastBackupDir="none"
if [ -f .lastBackupDir ]; then
  lastBackupDir=$(cat .lastBackupDir)
  minAgeThreshold=$(cat .minAgeDiff)
fi

# смотрим нужен ли новый backup 
if [ "$lastBackupDir" == "none" ] || [ "$minAgeThreshold" -ge 7 ]; then
  newBackupDir="Backup-$currentDate"
  mkdir ~/"$newBackupDir"
  echo "Done new backup: $newBackupDir" >> ~/backup-report
  echo "here is files and directories:" >> ~/backup-report
  for sourceFile in $(find ~/source | cut -d/ -f 5-); do
    cp -a ~/source/"$sourceFile" ~/"$newBackupDir"/"$sourceFile"
    echo "$sourceFile" >> ~/backup-report
  done
else
  # обновляем backup
  echo "Added to the last backup: $currentDate" >> ~/backup-report
  echo "Information:" >> ~/backup-report
  for sourceFile in $(find ~/source | cut -d/ -f 5-); do
    backupFile="$lastBackupDir"/"$sourceFile"
    if ! [ -f "$backupFile" ]; then
      cp -a ~/source/"$sourceFile" "$backupFile"
      echo "Copied ~/source/$sourceFile to $backupFile" >> ~/backup-report
    else
      size1=$(wc -c "$backupFile" | awk '{print $1}')
      size2=$(wc -c ~/source/"$sourceFile" | awk '{print $1}')
      if [ "$size1" -ne "$size2" ]; then
        extensionDate=$(date +'%Y-%m-%d-%H-%M-%S')
        mv "$backupFile" "$backupFile"."$extensionDate"
        cp -a ~/source/"$sourceFile" "$backupFile"
        echo "Copied: $backupFile and $backupFile.$extensionDate" >> ~/backup-report
      fi
    fi
  done
fi
