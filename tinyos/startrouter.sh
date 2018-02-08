#Shell script to start a Ppp router
#in the device 0
cd PppRouter
make telosb
make telosb install
tos-pppd_start 0
