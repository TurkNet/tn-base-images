#!/bin/bash -e

if [ -z "$(prlsrvctl info | grep Version)" ]; then
	echo "prlsrvctl is not installed!!"
    echo "Download => https://www.parallels.com/products/desktop/trial/"
    exit 1
else
    echo "prlsrvctl is installed!!"
    prlsrvctl info | grep Version
fi

if [ -z "$(jq --version)" ]; then
	echo "jq is not installed!!"
    echo "Please install jq: brew install jq"
    exit 1
else
    echo "jq is installed!!"
    jq --version
fi

isShutDown=false

### Shared Config ###

constSTARTADDRESS='172.16.100.1'
constENDADDRESS='172.16.100.254'
constSUBNETADDRESS='255.255.255.0'
constIPADDRESS='172.16.100.2'

JSON="$(prlsrvctl net info Shared -j)"
STARTADDRESS="$(echo $JSON|jq -r '."DHCPv4 server"."IP scope start address"')"
ENDADDRESS="$(echo $JSON|jq -r '."DHCPv4 server"."IP scope end address"')"
SUBNETADDRESS="$(echo $JSON|jq -r '."Parallels adapter"."IPv4 subnet mask"')"

if [ $constSTARTADDRESS != $STARTADDRESS ] || [ $constENDADDRESS != $ENDADDRESS ] || [ $constSUBNETADDRESS != $SUBNETADDRESS ]; then

    echo "Shared Network start address($constSTARTADDRESS)"
    echo "Shared Network end address($constENDADDRESS)"
    echo "Shared Network subnet address($constSUBNETADDRESS)"

    sudo prlsrvctl net set Shared --ip-scope-start ${constSTARTADDRESS} \
        --ip-scope-end ${constENDADDRESS} \
        --ip ${constIPADDRESS} \
        --dhcp-ip ${constSTARTADDRESS}

    isShutDown=true
fi

#####################


### Host-Only Config ###

constSTARTADDRESS="172.16.10.1"
constENDADDRESS="172.16.10.254"
constSUBNETADDRESS="255.255.255.0"
constIPADDRESS="172.16.10.2"

JSON="$(prlsrvctl net info Host-Only -j)"
STARTADDRESS="$(echo $JSON|jq -r '."DHCPv4 server"."IP scope start address"')"
ENDADDRESS="$(echo $JSON|jq -r '."DHCPv4 server"."IP scope end address"')"
SUBNETADDRESS="$(echo $JSON|jq -r '."Parallels adapter"."IPv4 subnet mask"')"


if [ $constSTARTADDRESS != $STARTADDRESS ] || [ $constENDADDRESS != $ENDADDRESS ] || [ $constSUBNETADDRESS != $SUBNETADDRESS ]; then

    echo "Host-Only Network start address($constSTARTADDRESS)"
    echo "Host-Only Network end address($constENDADDRESS)"
    echo "Host-Only Network subnet address($constSUBNETADDRESS)"

    sudo prlsrvctl net set Host-Only --ip-scope-start ${constSTARTADDRESS} \
        --ip-scope-end ${constENDADDRESS} \
        --ip ${constIPADDRESS} \
        --dhcp-ip ${constSTARTADDRESS}

    isShutDown=true
fi

#####################

if $isShutDown ; then
    sudo prlsrvctl shutdown -f

    echo "Parallels's Network Configuration is ready.\n"
else
    echo "Parallels's Network Configuration is already ok.\n"
fi

