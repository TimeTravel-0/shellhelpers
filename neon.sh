#!/bin/bash
led=/sys/class/leds/tpacpi\:\:thinklight/brightness

function flicker_on
{
for i in {1..50}
    do
        if [ "$(($RANDOM%5))" -eq "0" ]
        then
            echo 255 > $led
        else
            echo 0 > $led
        fi
        sleep 0.01
    done
    echo 255 > $led
}



#echo "$led"
chmod 666 $led
RANDOM=$$
LED_STATE=`cat $led`

for (( ; ; ))
do

    # wait for led state to become zero again (someone switched led off)
    while [ "$LED_STATE" !=  "0" ]
    do
        sleep 1
        LED_STATE=`cat $led`
    done

    echo "off"


    # wait for led state to become non-zero (someone switched led on)
    while [ "$LED_STATE" -eq  "0" ]
    do
        sleep 0.1
        LED_STATE=`cat $led`
    done

    echo "startup"

    # led was switched on, do a light show
    flicker_on
    echo "now on"


done

