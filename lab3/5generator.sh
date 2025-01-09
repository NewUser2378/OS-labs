#!/bin/bash
 

# Создаем именованный канал
PIPE_NAME="my_pipe"
mkfifo $PIPE_NAME

# Запускаем обработчик
./handler.sh $PIPE_NAME &

# Переключаем режим на сложение по умолчанию
echo "+" > $PIPE_NAME


for i in {1..5}; do
    # Генерируем случайное число от 1 до 10
    number=$((RANDOM % 10 + 1))
    
    # Отправляем данные в канал
    echo $number > $PIPE_NAME
    sleep 1
done

# Отправляем сигнал завершения
echo "QUIT" > $PIPE_NAME

# Удаляем канал
rm $PIPE_NAME

