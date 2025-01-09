#!/bin/bash

# сохраняем ID в file
echo $$ > .pid


counter=1

# определим функцию для режима
addition_mode() {
    operation_mode="addition"
}

multiply_mode() {
    operation_mode="multiply"
}

terminate() {
    operation_mode="terminate"
}

# установим обработчики
trap 'addition_mode' USR1
trap 'multiply_mode' USR2
trap 'terminate' SIGTERM


while true; do
    case "$operation_mode" in # если на сложении то увеличим счетчик
        "addition")
            counter=$((counter + 2))
            echo "Counter after addition: $counter"
            ;;

        "multiply")
            counter=$((counter * 2))
            echo "Counter after multiplication: $counter" # если на умножении то удвоим счетчик
            ;;

        "terminate") 
            echo "DONE"
            exit
            ;;
    esac

    sleep 2
done
