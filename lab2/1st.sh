 
#!/bin/bash
#используем grep чтобы при выводе не учитывать сам awk

ps -U alex -o pid=,cmd= | grep -v "awk" | awk '{print "PID " $1 ": "  $2}' | awk 'END {print NR}'

ps -U alex -o pid=,cmd= | grep -v "awk" | awk '{print "PID " $1 ": "  $2}'