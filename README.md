# WSN Lab Project

The project is about playing different instruments using light sensor provided by Tmote Sky(from Hamamatsu). By introducing a ppp router all the nodes will communicate with each other using ipv6 multicast, therefore enabling the detection of simultaneously triggering nodes. Every node will communicate with endpoint(computer) via UDP, where depending upon the node configuration, different instruments will be played.

### Prerequisites
* python3 with pip3 for installing the required packages
* tinyos

### Installation

1. Installing python requirements:

```
cd WSN_Lab_Project/tinyos/Music/utils
pip3 install -r requirements.txt
```
2. Setting one node as router:

```
cd WSN_Lab_Project/tinyos
./startrouter.sh

```
3. Installing the program on the nodes:

```
cd WSN_Lab_Project/tinyos
./installmusic.sh <node id> <usb number>

#Installing in the node connected to ttyUSB1 with the id 2
./installmusic.sh 2 1

```

## Getting Started with Application

1. Set one node as ppp router and the others as instruments as shown in the **Installation** section.

2. Configure the nodes as following:

```
#Connect to the node
nc6 -u fec0::<node id> 2000

#Get current configuration
get

#Set the threshold
set th <threshold>

#Set the instrument
set inst <instrument number>

```
3. Start application

```
cd WSN_Lab_Project/tinyos/Music/utils
python3 Play.py

```
4. Enjoy :v:

## Instrument configuration

1. drum_splash
2. drum_bass
3. drum_snare
4. guit
5. choir
6. cymbal


## Authors
* *Mohammad Imran Syed*
* *Aman Kumar Gulia*
* *Enrique Campomanes Miguel*