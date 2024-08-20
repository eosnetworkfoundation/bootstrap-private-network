#!/bin/env bash

# setcode and abi for updated system contracts 
CONTRACT_DIR="/local/eosnetworkfoundation/repos/eos-system-contracts/build/contracts"
cleos set contract eosio ${CONTRACT_DIR}/eosio.system eosio.system.wasm eosio.system.abi -s -d --json-file ${CONTRACT_DIR}/setcontract-eosio.system.json --expiration 8640000
#eosc -u https://eos.api.eosnation.io multisig propose eosnationftw rex.2 ~/Github/eos-rex-2.0/actions/msig-mainnet-rex.2.json --request-producers
eosc -u http://127.0.0.1:8888 multisig propose tcontract.1 ${CONTRACT_DIR}/setcontract-eosio.system.json --request bpa,bpb,bpc --expiration 8640000
