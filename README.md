# WSN Lab Project

The project consists in...

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites
* python3 with pip3 for installing the required packages
* tinyos

What things you need to install the software and how to install them

```
Give examples
```

### Installing

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
3. Installing the programm in the nodes:

```
cd WSN_Lab_Project/tinyos
./installmusic.sh <node id> <usb number>

#Installing in the node connected to ttyUSB1 with the id 2
./installmusic.sh 2 1

```

## Authors
* *Mohammad Imran Syed*
* *Aman Kumar Gulia*
* *Enrique Campomanes Miguel*
