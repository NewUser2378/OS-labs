#!/bin/bash

output="output.txt"

 
awk -F'[ =]' '
BEGIN {
    sum = 0
    currentPpid = 0
    childrenCount = 0
}

{
    # Если Ppid изменился, выводим среднее время и сбрасываем счетчики
    if ($5 != currentPpid) {
        if (childrenCount > 0) {
            averageTime = sum / childrenCount
            print "Average_Running_Children_of_ParentID=" currentPpid " is " averageTime
        }
        currentPpid = $5
        childrenCount = 1
        sum = $8
    } else {
        # Если Ppid не изменился, увеличиваем счетчики и добавляем время
        childrenCount++
        sum += $8
    }
    print
}

END {
    # Выводим среднее время для последнего Ppid
    if (childrenCount > 0) {
        averageTime = sum / childrenCount
        print "Average_Running_Children_of_ParentID=" currentPpid " is " averageTime
    }
}
' "$output"
