 
#!/bin/bash
ps -eo pid,etime --sort=-etime | awk 'NR==2 {print $1}'