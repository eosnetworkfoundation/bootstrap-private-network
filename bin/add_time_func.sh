#!/usr/bin/env bash

ROOT_DIR=/local/eosnetworkfoundation/repos
ENDPOINT_ONE=http://127.0.0.1:8888
account_name=eosio.time
PUBLIC_KEY=EOS5Tsxa9KPn885rgXUyQMb5MMJhtCZNSYR8YueHoe36oGY3xSatS
CONTRACT_DIR=${ROOT_DIR}/eosio.time/


cd $ROOT_DIR || exit
./bootstrap-private-network/bin/open_wallet.sh $HOME/eosio-wallet/
git clone https://github.com/eosnetworkfoundation/eosio.time
cd eosio.time/ || exit
cdt-cpp eosio.time.cpp

cleos --url $ENDPOINT_ONE system newaccount eosio ${account_name:?} ${PUBLIC_KEY:?} --stake-net "500 EOS" --stake-cpu "500 EOS" --buy-ram "1000 EOS"
cleos --url $ENDPOINT_ONE set contract ${account_name} ${CONTRACT_DIR} eosio.time.wasm eosio.time.abi -p ${account_name}@active
