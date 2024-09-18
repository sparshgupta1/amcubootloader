#!/bin/bash

./rttLogger.sh -ka

numArgs=$#
if [[ $numArgs -gt 0 ]]; then
    if [[ $1 == "-d" ]]; then
        echo "Downgrading AMCU"
        ./JLinkExe -CommandFile amcu_zero.jlink
    elif [[ $1 == "-h" ]]; then
        echo "Help for Programming AMCU"
        echo "For Programming version 1.1.1.0 and earlier"
        echo "./programAmcu.sh -d"
        echo "For Programming version 1.1.2.0 and later"
        echo "./programAmcu.sh"
    fi
else 
    echo " programming AMCU"
    ./JLinkExe -CommandFile amcu.jlink
fi
