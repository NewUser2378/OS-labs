 
#!/bin/bash

for CURR_PID in $(ps ax -o pid | tail -n +2); do # проходим по всем процессам и  убираем служебную строку

    if [ -f /proc/$CURR_PID/sched ]; then #проверяем есть ли в процессоре 
        STATUS_PID=$(grep -s "^Pid:" /proc/$CURR_PID/status | grep -E -s -o "[0-9]+") #берем индентификатор процесса
        STATUS_PPID=$(grep -s "^PPid:" /proc/$CURR_PID/status | grep -E -s -o "[0-9]+") #инд. для родительского процесса


        SUM_EXEC_RUNTIME=$(grep -s "^se.sum_exec_runtime" /proc/$PID/sched | awk '{print $3}') #смотрим на суммарное время
        NR_SWITCHES=$(grep -s "^nr_switches" /proc/$PID/sched | awk '{print $3}') #смотрим на количество переключений процессора

        if [[ -z $STATUS_PID ]]; then #был ли успешно извлечен PID процесса. Если PID отсутствует, то переходим к следующе
            continue
        fi

        if [[ -z $STATUS_PPID ]]; then #аналогично как в предыдущей только для родительских процессов
            STATUS_PPID=0
        fi


        if [[ -n $SUM_EXEC_RUNTIME && -n $NR_SWITCHES && $NR_SWITCHES -gt 0 ]]; then #смотрим чтобы не делили на 0
            ART=$((SUM_EXEC_RUNTIME / NR_SWITCHES)) #считаем среднее время
        else
            ART=0
        fi


        echo "ProcessID=$STATUS_PID : Parent_ProcessID=$STATUS_PPID : Average_Running_Time=$ART" >> output.txt # выводим в файл который будем использовать в 5 номере

    fi
done
