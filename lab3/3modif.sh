#!/bin/bash

# Создаем именованный канал для генератора
GENERATOR_PIPE="generator_pipe"
mkfifo $GENERATOR_PIPE

# Запускаем обработчик
./handler.sh $GENERATOR_PIPE &

# Создаем именованные каналы для пользователей
CONSUMER_PIPES=("consumer_pipe_1" "consumer_pipe_2" "consumer_pipe_3")

for pipe in "${CONSUMER_PIPES[@]}"; do
    mkfifo $pipe
done

# Переключаем режим на сложение по умолчанию
echo "+" > $GENERATOR_PIPE

for i in {1..5}; do
    # Генерируем случайное число от 1 до 10
    number=$((RANDOM % 10 + 1))
    
    # Отправляем данные в канал генератора
    echo $number > $GENERATOR_PIPE
    sleep 1
done

# Отправляем сигнал в каждый канал 
for pipe in "${CONSUMER_PIPES[@]}"; do
    echo "QUIT" > $pipe
done

# Удаляем каналы
rm $GENERATOR_PIPE
for pipe in "${CONSUMER_PIPES[@]}"; do
    rm $pipe
done
