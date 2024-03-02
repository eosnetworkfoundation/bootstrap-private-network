# Instructions for Building Savanna Network

## Environment

Many linux OS will work, these instructions have been validates on `ubuntu 22.04`.

### Prerequisites
Apt-get and install the following
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/AntelopeDocker#L3-L20
You will also need to install the following python packages
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/AntelopeDocker#L21

## Build Antelope Software
You will need to build the following Antelope software from source, using the specified git tags or commit hashes. The software should be built in the following order to satisfy dependancies `Leap`, followed by `CDT`, followed by `Reference Contracts`.

These Git Commit Hashes or Tags are current to the following date.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/docker-build-image.sh#L3

### Leap
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/AntelopeDocker#L46

[Full Instructions for Building Leap](https://github.com/antelopeio/leap?tab=readme-ov-file#build-and-install-from-source) or you can review the [Reference Script to Build Leap and CDT](bin/build_antelope_software.sh).

### CDT
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/AntelopeDocker#L47

[Full Instructions for Building CDT](https://github.com/antelopeio/cdt?tab=readme-ov-file#building-from-source) or you can review the [Reference Script to Build Leap and CDT](bin/build_antelope_software.sh).

### Reference Contract
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/AntelopeDocker#L46

[Full Instructions for Building Refereence Contracts](https://github.com/antelopeio/reference-contracts?tab=readme-ov-file#building) or you can review [Reference Script to Build Contracts](bin/build_eos_contracts.sh).

## Install Antelope Software
Now that the binaries are build you need to add them to your path or install them into well know locations. The [Reference Install Script](bin/install_antelope_software.sh) must be run as root and has one way to install the software.

Note, the `Reference Contracts` as install later during the initialization of the EOS blockchain.

## Initialize Block Chain
Before we can start up our multi-producer blockchain a few preperations are needed.
#### `Create New Key Pair`
We will create a new key pair for the root user of the blockchain. You will use the Public Key often in the setup, so please save these keys for use later. You will see a `PublicKey` and `PrivateKey` printed to the console using the following command.
`cleos create key --to-console`
#### `Create Genesis File`
Take the reference [Genesis File](config/genesis.json) and replace the value for `Initial Key` with the `PublicKey` generated previously. Replace the the value for `Initial Timestamp` with now. In linux you can get the correct format for the date with the following command `date +%FT%T.%3N`.
#### `Create Shared Config`
We will create a shared config file for the common configuration values. Configuration here is only for preview development purposes and should not be used as a reference production config. Copy [config.ini](config/config.ini) to your filesystem. Additional configuration values will be added on the command line.
#### `Create Log and Data Dir`
You will need to create three data directories, one for each instance of nodeos you will run. You will need a place for log files as well. For example:
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/finality_test_network.sh#L55-L58
#### `Create Wallet`
You need to create and import the root private key into a wallet. This will allow you to run initialization commands on the blockchain. In the example below we have a named wallet and we save the wallet password to a file.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/open_wallet.sh#L14
Then import your `PrivateKey` adding it to the wallet
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/finality_test_network.sh#L66
If you have already created a wallet you may need to unlock your wallet using your password
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/open_wallet.sh#L19
#### `Initialization Data`
Taking everything we have prepared we will now start a `nodoes` instance. We will be issuing commands while nodes is running so run this command in the background, or be prepared to open multiple terminals on your host. You'll notice we specified the
- genesis file
- config file
- data directory for first instance
- public and private key from our very first step
It is very important to include the option `--enable-stale-production`, we will need that to bootstrap our network.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/ad6a5536fde8f751cf94b63a2641d5b0d8c37c6b/bin/finality_test_network.sh#L70-L77

One the node is running we need to run two scripts to add accounts, permissions, and contracts.
- boot actions
- block producer schedule
[boot_actions.sh](bin/boot_actions.sh) is the reference script. You pass in the following values, reference contracts is your locale git repository where you build the reference contracts software.  
- 127.0.0.1:8888
- $DIR/reference-contracts/build/contracts
- PublicKey
[block_producer_schedule](bin/block_producer_schedule.sh) is the reference script. You pass in the following values
- 127.0.0.1:8888
- PublicKey
#### `Shutdown`
Now that we have initialized our first instance we need to shut it down and restart. Find the pid and send `kill -15 $pid` to terminate the instance.

## Create Network
