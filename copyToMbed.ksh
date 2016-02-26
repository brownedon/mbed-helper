PID=0
while [ 1==1 ];do
echo Wait for hex file
while [[ `ls Downloads/*|grep .hex|wc -l` -eq 0 ]];do
  sleep 1
done

if [[ ! -e /Volumes/MBED ]];then
  echo "Can't find MBED"
  exit 1
fi
sleep 30 
#kill any open screen sessions
if [[ ! $PID -eq 0 ]];then
  kill -9 $PID
fi

echo "Moving hex file"
cp -X ~/Downloads/*.hex "/Volumes/MBED"
rm ~/Downloads/*.hex

echo Wait for MBED to reboot
while [[  -f "/Volumes/MBED/mbed.htm" ]];do
  sleep 1 
done

echo MBED rebooting
while [[ ! -f "/Volumes/MBED/mbed.htm" ]];do
  sleep 1
done
echo MBED done rebooting

echo Launch Terminal
#launch serial window
osascript <<EOF
tell app "Terminal"
  do script "mbedSerial.ksh"
end tell
EOF
PID=`ps -ef|grep Screen|cut -d' ' -f4`
done
