#!/bin/bash

LATR=$1
LONG=$2
LAT=$(echo $LATR | awk -F ',' '{print $1}')
REG='^[+-]?[0-9]+([.][0-9]+)?$'


if [[ $LAT = "" ]]  ||  [[ $LONG = "" ]]
    then
        echo "You need to enter latitude"
        echo "and longitude"
        exit 1
fi

if ! [[ $LAT =~ $REG ]]
    then
        echo "Invalid Latitude Entered"
        exit 1
    else
        if ! [[ $LONG =~ $REG ]]
            then
                echo "Invalid Longitude Entered"
                exit 1
        fi
fi

REST=https://maps.t-mobile.com/Rest/pcc-getcoverage.php?point=$LAT,$LONG

FILE=/tmp/json

curl -s -o $FILE $REST

#get gsm
GSM=$(cat $FILE | jq '.response[0:1]' | xargs)
echo "GSM coverage:      " $GSM

#get U1900 coverage
U19=$(cat $FILE | jq '.response[21:22]' | xargs)
echo "U1900 coverage:    " $U19

#get U2100 coverage
U21=$(cat $FILE | jq '.response[22:23]' | xargs)
echo "U2100 coverage:    " $U21

#get L2100
L21=$(cat $FILE | jq '.response[3:4]' | xargs)
echo "L2100 coverage:    " $L21

#get L1900
L19=$(cat $FILE | jq '.response[4:5]' | xargs)
echo "L1900 coverage:    " $L19

#get L700
L7=$(cat $FILE | jq '.response[5:6]' | xargs)
echo "L700 coverage:     " $L7

#get L600
L6=$(cat $FILE | jq '.response[23:24]' | xargs)
echo "L600 coverage:     " $L6

#get combined NR signal
NCC=$(cat $FILE | jq '.response[27:28]' | xargs)
echo "5G coverage:       " $NCC

#get N600N
N6N=$(cat $FILE | jq '.response[6:7]' | xargs)
#echo "N600 coverage:     " $N6N

#get N600S
N6S=$(cat $FILE | jq '.response[26:27]' | xargs)
#echo "N600 SA coverage:  " $N6S

#get N2500S
N25S=$(cat $FILE | jq '.response[25:26]' | xargs)
#echo "N2500 SA coverage: " $N25S

#get roaming signal
RS=$(cat $FILE | jq '.response[7:8]' | xargs)
#echo "Roaming coverage:  " $RS

#get roaming type
RT=$(cat $FILE | jq '.response[8:9]' | xargs)
#   echo "Roaming type:      " $RT


if  [[ $RT = 2 ]]
    then
        RT="Roaming not LTE"
        echo "Roaming type:      " $RT
    else
        if  [[ $RT = 3 ]]
            then
                RT="Roaming UMTS 850"
                echo "Roaming type:      " $RT
            else
                if  [[ $RT = 4 ]]
                    then
                        RT="Roaming LTE"
                        echo "Roaming type:      " $RT
		    else
			if  [[ $RT = 0 ]]
			    then
				echo ""
			fi
                fi
        fi
fi

#signal legent
echo ""
echo "Signal Legend:"
echo "                    1 = Best"
echo "                    2 = Good"
echo "                    3 = Okay"
echo "                    4 = Poor"
echo "                    0 = None"

exit 0
