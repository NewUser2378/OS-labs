 
#!/bin/bash

ps aux | grep -E "/sbin/" | awk '{print $2}'