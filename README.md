# Readme

## Purpose  
See [Use Cases](doc/use-cases-private-network.md) for background.

## Directory Structure
There are three directories
- bin: all the scripts
- config: nodeos configuration files and templates
- doc: markdown documenation

## Setup and Run

Build Docker Image
`./bin/docker-build-image.sh`
Start Docker Container with Image
`./bin/docker-create-container.sh`
Enter the Container
`./bin/docker-enter-container.sh`
Setup Antelope Network
`/local/eosnetworkfoundation/repos/bootstrap-private-network/bin/finality_test_network.sh CREATE`
Check out logs
```
tail /bigata1/log/nodeos-one.log
tail /bigata1/log/nodeos-two.log
tail /bigata1/log/nodeos-three.log
```
