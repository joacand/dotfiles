#!/bin/bash

CORE0_TEMP=`sensors | grep "Core 0" | awk '{print $3}' | cut -c2-3`
CORE1_TEMP=`sensors | grep "Core 1" | awk '{print $3}' | cut -c2-3`
MEASURING_TEMP=-1
finish=0

trap 'finish=1' SIGUSR1 SIGINT SIGTERM

echo "Fanscript v1.1"
echo "Initial core0 temp: +$CORE0_TEMP°C"
echo "Initial core1 temp: +$CORE1_TEMP°C"
echo " "
echo "Setting fan mode to manual..."
sudo acer_ec.pl := 0x93 0x14
echo "Done."
echo " "
echo "Starting program loop..."

while (( finish != 1 ))
do
CORE0_TEMP=`sensors | grep "Core 0" | awk '{print $3}' | cut -c2-3`
CORE1_TEMP=`sensors | grep "Core 1" | awk '{print $3}' | cut -c2-3`

if [ $CORE0_TEMP -gt $CORE1_TEMP ]
then
    MEASURING_TEMP=$CORE0_TEMP
else
    MEASURING_TEMP=$CORE1_TEMP
fi

echo $MEASURING_TEMP

if [ $MEASURING_TEMP -le 45 ]
then
    echo "Setting fan to 0 at temp $MEASURING_TEMP"
    sudo acer_ec.pl := 0x94 0xFF
elif [ $MEASURING_TEMP -le 75 ]
then
    echo "Setting fan to low at temp $MEASURING_TEMP"
    sudo acer_ec.pl := 0x94 0xAA
elif [ $MEASURING_TEMP -le 80 ]
then
    echo "Setting fan to high at temp $MEASURING_TEMP"
    sudo acer_ec.pl := 0x94 0x5A
else
    echo "Setting fan to very high at temp $MEASURING_TEMP"
    sudo acer_ec.pl := 0x94 0x4D
fi

sleep 2
done

echo "Setting fan mode to auto..."
sudo acer_ec.pl := 0x93 0x04
echo "Done."
echo "Exiting..."
