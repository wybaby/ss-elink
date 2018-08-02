#!/bin/bash
declare -a array
for ((i=1;i<=22;i++))
do
    array[${i}]="s${i}.plink.hk"
done
MIN=300
delay=3
INDEX=1
IP="1.1.1.1"
id=1
for ((id=1;id<=22;id++))
do
    delay="`ping -c 3 ${array[${id}]} | grep avg | awk -F / '{print $4}' | awk -F . '{print $1}'`"
#    echo ${id} ": " ${delay}
    if [ -n "${delay}" ]
    then
        if [ "${delay}" -le "${MIN}" ]
        then
            INDEX=${id}
            MIN=${delay}
            IP="`ping -c 1 ${array[${id}]} | grep PING | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`"
#            echo ${IP}
        fi
    fi
done
FILE="/etc/config/shadowsocks-libev"
sed -i '/option server /d' ${FILE}
sed -i '$a''\        option server '"'"${IP}"'" ${FILE}
`/etc/init.d/shadowsocks-libev restart`
#echo ${array[${INDEX}]} "," ${MIN} "," ${IP}
