#!/bin/bash
########################################################################################
#
#    File: ext_loopback.sh
#
#    Description:
#    configures two ethernet interfaces routing tables so data will run over the
#    wire instead of beeing routed internally
#
#    this enables testing ethernet cards and connections (switch, router, firewall)
#    from one single PC with tools like ping (flood), iperf, ...
#
#    References:
#    based on "Routing Traffic Between Local Applications on Linux" by Luke Gorrie
#    blog.lukego.com
#
########################################################################################

ETH_DEV_1_NO=0
ETH_DEV_2_NO=1

# overwrite with shell parameters (if provided)
if [ $# -eq 2 ]
then
    ETH_DEV_1_NO=$1
    ETH_DEV_2_NO=$2
fi

ETH_DEV_1_IP=10.200.200.$(($ETH_DEV_1_NO+201))
ETH_DEV_2_IP=10.200.200.$(($ETH_DEV_2_NO+201))

ETH_DEV_1_NAME=eth$ETH_DEV_1_NO
ETH_DEV_2_NAME=eth$ETH_DEV_2_NO

ETH_DEV_1_TABLENAME=$(($ETH_DEV_1_NO+100))
ETH_DEV_2_TABLENAME=$(($ETH_DEV_2_NO+100))

########################################################################################

echo "~~~~~~~~external loopback script~~~~~~~~"
echo "Interface 1: $ETH_DEV_1_NAME"
echo "             $ETH_DEV_1_IP"
echo ""
echo "Interface 2: $ETH_DEV_2_NAME"
echo "             $ETH_DEV_2_IP"
echo ""

ip route flush table all

echo "setting IPs"
ifconfig $ETH_DEV_1_NAME $ETH_DEV_1_IP netmask 255.255.255.0 multicast broadcast 0.0.0.0
ifconfig $ETH_DEV_2_NAME $ETH_DEV_2_IP netmask 255.255.255.0 multicast broadcast 0.0.0.0

echo "cycling interfaces"
ifconfig $ETH_DEV_1_NAME down ; sleep 1 ; ifconfig $ETH_DEV_1_NAME up
ifconfig $ETH_DEV_2_NAME down ; sleep 1 ; ifconfig $ETH_DEV_2_NAME up

sleep 1

#echo "list table local"
#ip route list table local

echo "> configuring TX <"

echo "adding external routing table entries..."
ip route add $ETH_DEV_1_IP dev $ETH_DEV_2_NAME # send packets to this ip on that device
ip route add $ETH_DEV_2_IP dev $ETH_DEV_1_NAME # send packets to this ip on that device

echo "removing local routing table entries..."
ip route del $ETH_DEV_1_IP table local # this ip cannot be reached locally
ip route del $ETH_DEV_2_IP table local # this ip cannot be reached locally


sleep 2
echo "> configuring RX <"

echo "removing existing rules (if any)..."
ip rule delete iif $ETH_DEV_1_NAME
ip rule delete iif $ETH_DEV_2_NAME

echo "adding additional RX rules tables..."
ip rule add iif $ETH_DEV_1_NAME lookup $ETH_DEV_1_TABLENAME
ip rule add iif $ETH_DEV_2_NAME lookup $ETH_DEV_2_TABLENAME

echo "filling RX routing tables with local routes..."
ip route add local $ETH_DEV_1_IP dev $ETH_DEV_1_NAME table $ETH_DEV_1_TABLENAME
ip route add local $ETH_DEV_2_IP dev $ETH_DEV_2_NAME table $ETH_DEV_2_TABLENAME

echo "enabeling accept_local flag..."
echo 1 > /proc/sys/net/ipv4/conf/$ETH_DEV_1_NAME/accept_local
echo 1 > /proc/sys/net/ipv4/conf/$ETH_DEV_2_NAME/accept_local

#ip route list table local

sleep 1

echo "> link test <"
ping $ETH_DEV_1_IP -c 5 -i 0.2 -w 1 ; EXITCODE_1=$?
ping $ETH_DEV_2_IP -c 5 -i 0.2 -w 1 ; EXITCODE_2=$?

if [ $(($EXITCODE_1+$EXITCODE_2)) -eq 0 ]
then
    echo ""
    echo "ping test ok"
    echo ""
    echo "$ETH_DEV_1_NAME now has IP $ETH_DEV_1_IP"
    echo "$ETH_DEV_2_NAME now has IP $ETH_DEV_2_IP"
    echo "" 
    echo "traffic to $ETH_DEV_1_IP will be sent on $ETH_DEV_2_NAME"
    echo "traffic to $ETH_DEV_2_IP will be sent on $ETH_DEV_1_NAME"
    echo ""

else

    echo "ping test NOT ok. Is network-manager service stopped?"
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"



#arp -a -i
#arp -a -i eth1


