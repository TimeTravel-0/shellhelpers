#! /usr/bin/env python
import serial
import time

port = serial.Serial('/dev/ttyUSB0')

def thinklightstatus():
    led="/sys/class/leds/tpacpi::thinklight/brightness"
    if not "0" in file(led).read():
        return 1
    else:
        return 0

while(1):


    port.setDTR(1-thinklightstatus())

    time.sleep(0.1)
