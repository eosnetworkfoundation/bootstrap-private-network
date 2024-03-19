# Instructions for Building Savanna Network

## Environment

Many linux OS will work, these instructions have been validated on `ubuntu 22.04`.

### Prerequisites
Apt-get and install the following
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/main/AntelopeDocker#L3-L20
You will also need to install the following python packages
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/main/AntelopeDocker#L21

## Build Antelope Software
You will need to build the following Antelope software from source, using the specified git tags or commit hashes. The software should be built in the following order to satisfy dependancies `Leap`, followed by `CDT`, followed by `Reference Contracts`.

These Git Commit Hashes or Tags are current to the following date.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/docker-build-image.sh#L17

### Leap
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/AntelopeDocker#L46

[Full Instructions for Building Leap](https://github.com/antelopeio/leap?tab=readme-ov-file#build-and-install-from-source) or you can review the [Reference Script to Build Leap and CDT](/bin/build_antelope_software.sh).

### CDT
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/AntelopeDocker#L47

[Full Instructions for Building CDT](https://github.com/antelopeio/cdt?tab=readme-ov-file#building-from-source) or you can review the [Reference Script to Build Leap and CDT](/bin/build_antelope_software.sh).

### Reference Contract
Latest Git Commit or Tag
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/AntelopeDocker#L53

[Full Instructions for Building Refereence Contracts](https://github.com/antelopeio/reference-contracts?tab=readme-ov-file#building) or you can review [Reference Script to Build Contracts](/bin/build_eos_contracts.sh).

## Install Antelope Software
Now that the binaries are build you need to add them to your path or install them into well know locations. The [Reference Install Script](/bin/install_antelope_software.sh) must be run as root and has one way to install the software.

Note, the `Reference Contracts` as install later during the initialization of the EOS blockchain.

## Initialize Block Chain
Before we can start up our multi-producer blockchain a few preperations are needed.
#### `Create New Key Pair`
We will create a new key pair for the root user of the blockchain. You will use the Public Key often in the setup, so please save these keys for use later. You will see a `PublicKey` and `PrivateKey` printed to the console using the following command.
`cleos create key --to-console`
#### `Create Genesis File`
Take the reference [Genesis File](/config/genesis.json) and replace the value for `Initial Key` with the `PublicKey` generated previously. Replace the the value for `Initial Timestamp` with now. In linux you can get the correct format for the date with the following command `date +%FT%T.%3N`.
#### `Create Shared Config`
We will create a shared config file for the common configuration values. Configuration here is only for preview development purposes and should not be used as a reference production config. Copy [config.ini](/config/config.ini) to your filesystem. Additional configuration values will be added on the command line.
#### `Create Log and Data Dir`
You will need to create three data directories, one for each instance of nodeos you will run. You will need a place for log files as well. For example:
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L79-L82
#### `Create Wallet`
You need to create and import the root private key into a wallet. This will allow you to run initialization commands on the blockchain. In the example below we have a named wallet and we save the wallet password to a file.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/open_wallet.sh#L14
Then import your `PrivateKey` adding it to the wallet
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L89-L90
If you have already created a wallet you may need to unlock your wallet using your password
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/open_wallet.sh#L19
#### `Initialization Data`
Taking everything we have prepared we will now start a `nodoes` instance. We will be issuing commands while nodes is running so run this command in the background, or be prepared to open multiple terminals on your host. You'll notice we specified the
- genesis file
- config file
- data directory for first instance
- public and private key from our very first step
It is very important to include the option `--enable-stale-production`, we will need that to bootstrap our network.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L94-L101

One the node is running we need to run two scripts to add accounts, permissions, and contracts.
- boot actions
- block producer schedule

[boot_actions.sh](/bin/boot_actions.sh) is the reference script. You pass in the following values, reference contracts is your locale git repository where you build the reference contracts software.

- 127.0.0.1:8888
- $DIR/reference-contracts/build/contracts
- PublicKey

This script creates the needed accounts.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/d2db1d588bf824beb84967e300224fbf35f29987/bin/boot_actions.sh#L15-L24

Below we activate the protocols needed to support Savanna and create the `token`, `boot`, and `bios` contracts.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/d2db1d588bf824beb84967e300224fbf35f29987/bin/boot_actions.sh#L26-L51

[block_producer_schedule](/bin/block_producer_schedule.sh) is the reference script. You pass in the following values

- 127.0.0.1:8888
- PublicKey

This script create new block producers and creates the production schedule.
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/d2db1d588bf824beb84967e300224fbf35f29987/bin/block_producer_schedule.sh#L6-L52

#### `Shutdown`
Now that we have initialized our first instance we need to shut it down and restart. Find the pid and send `kill -15 $pid` to terminate the instance.

## Create Network
Now we start our three nodes peer'd to each other. The Second and Third nodes will start from genesis and pull updates from the First node. The First nodes has already been initialized and it will start from its existing state. Soon each node will have the same information and the same head block number.

In the examples below the `PublicKey` and `PrivateKey` have the same values.

#### `Node One`
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L119-L128
#### `Node Two`
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L134-L142
#### `Node Three`
https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L158-L166

## Check Blocks Behind
Here you can check the Head Block Number and Last Irreversible Block and see there are far apart. `cleos get info`

## Active Savana
For the last step we will activate the new Savanna algorithm.

#### `Generate Finalizer Keys`
We need to generate the new BLS finalizer keys and add them to our configuration file. Each producer needs to generate a finalizer key. We have three nodes and that requires calling `leap-util bls create key` three times.
`leap-util bls create key --to-console`
Save the output from the command. The public and private keys will be added as `signiture-provided` lines to `config.ini`. This configuration file is shared across all three instances and each instance will have all three lines.
- BLS Public keys start with `PUB_BLS_`
- BLS Private keys start with `PVT_BLS_`
- BLS Proof of possession signatures start with `SIG_BLS_`

```
echo "signature-provider = ""${NODE_ONE_PUBLIC_KEY}""=KEY:""${NODE_ONE_PRIVATE_KEY}" >> config.ini
echo "signature-provider = ""${NODE_TWO_PUBLIC_KEY}""=KEY:""${NODE_TWO_PRIVATE_KEY}" >> config.ini
echo "signature-provider = ""${NODE_THREE_PUBLIC_KEY}""=KEY:""${NODE_THREE_PRIVATE_KEY}" >> config.ini
```

#### `Apply New Configuration`
Now that the configuration is in the shared `config.ini` we need to stop and re-start all three nodes to load the new configuration. Find the pid and send `kill -15 $pid` to terminate all three instances. Now start up the nodes. Here are examples from our reference development script. The `signature-provided` argument on the command line is the [EOS Root Key Pair](/doc/step-by-step.md#create-new-key-pair) we created earlier, and it is still needed for this restart step.

https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L119-L128

https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L144-L152

https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/finality_test_network.sh#L168-L176

#### `Apply Finalizer Key`
`cleos push action eosio setfinalizer` with `setfinalizer_policy` json. In the developer example below we have three producers. The threshold value should be 2/3 of the weights across all the finalizers listed. Once this command is run, the new Savanna algorithm is activated.

https://github.com/eosnetworkfoundation/bootstrap-private-network/blob/c1fdba2dcf8ff69d983292960f8ee49711105195/bin/activate_savanna.sh#L20-L44

#### `Verify Faster Finality`
Here you can check the Head Block Number and Last Irreversible Block and see they are three apart. `cleos get info`

Congratulations you are running a Private EOS network with the new, faster finality, Savanna algorithm.
