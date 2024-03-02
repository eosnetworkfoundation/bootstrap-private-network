# Readme

## Purpose  
The TLDR; Quickly set up Antelope Software and see Savanna working with near instant finality.
See [Use Cases](doc/use-cases-private-network.md) for background.

## Topology

This reference and documentation sets up three separate nodes on a single host. Each node is a separate process distinguished with different port numbers.
```mermaid
graph LR;
    One(Node-One:8888)<-->Two(Node-Two:6888);
    One(Node-One:8888)<-->Three(Node-Three:7888);
    Two(Node-Two:6888)<-->Three(Node-Three:7888);
```

## Quick Start Guide

Build Docker Image
`./bin/docker-build-image.sh`
Start Docker Container with Image
`./bin/docker-create-container.sh`
Enter the Container
`./bin/docker-enter-container.sh`
Setup Antelope Network
`/local/eosnetworkfoundation/repos/bootstrap-private-network/bin/finality_test_network.sh CREATE`
See Last Irreversible Block is many blocks behind Head Block
`cleos get info`
Activate Savanna
`/local/eosnetworkfoundation/repos/bootstrap-private-network/bin/finality_test_network.sh SAVANNA`
See Last Irreversible Block is *-->one<--* block behind Head Block
`cleos get info`

## Step By Step Documentation
See [Step By Step](doc/step-by-step.md)

## Frequently Asked Questions
Q: Why is nodeos version `5.1.0-dev`?
A: The current Savanna is in development as a branch of the `5.0` release. Proper release versions will be set as we get closer to releasing the software.
