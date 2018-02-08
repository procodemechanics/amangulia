#!/bin/bash

NODEID=$1
DEVICE=$2

cd Music
#make telosb
make telosb install,$NODEID bsl,/dev/ttyUSB$DEVICE
