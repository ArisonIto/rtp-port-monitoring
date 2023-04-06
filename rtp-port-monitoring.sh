#!/bin/bash
RED='\033[1;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
BOLD='\033[1;37m'
NC='\033[0m' # No Color

#Extract subtraction of RTP START/END by rtp show settings command.
rtpend=$(asterisk -rx "rtp show settings" | grep end | head -n 1 | cut -d ":" -f 2 | awk '{gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1}')
rtpstart=$(asterisk -rx "rtp show settings" | grep start | head -n 1 | cut -d ":" -f 2 | awk '{gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1}')
diff=$((rtpend - rtpstart))

#Check if the logdat.txt file exists
if [ -f /root/scripts/logdat.txt ]; then
#Get the highest port from the log.txt file
max_port=$(cat /root/scripts/logdat.txt | awk '{ if ($5 > max) max = $5 } END { print max }')
else
echo " logdat.txt file not found."
fi

#Get the latest port result
if [ -f /root/scripts/logdat.txt ]; then
timereal=$(tail -n 1 "logdat.txt" | awk '{ print $5 }')
else
echo " logdat.txt file not found."
fi

#This command below, it will see if the number is integer before comparing.
if test "$max_port" -eq "$max_port" 2>/dev/null; then
#The command below will show if the max value is greater than the diff.
if [ "$max_port" -gt "$diff" ]; then
response="INCREASE"
else
response="DO NOT INCREASE"
fi
else
#max_port is not an integer
response="DO NOT INCREASE"
fi
#Display variables in the script
echo -e "${GREEN}$(hostname)${NC}"
echo " Initial RTP port: $rtpstart"
echo " Final RTP port: $rtpend"
echo " Calculated ports: $diff"
echo " Highest port of the day : $max_port"
echo " Real-time ports : $timereal"
echo " Needs to increase: $response"
