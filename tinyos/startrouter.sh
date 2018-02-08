#!/bin/bash

cd PppRouter
make telosb
make telosb install
tos-pppd_start 0
