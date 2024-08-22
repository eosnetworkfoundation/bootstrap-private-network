#!/bin/env bash

CONTRACT_DIR="/local/eosnetworkfoundation/repos/eos-system-contracts/build/contracts"
PUBLIC_SIG_KEY=EOS81nrWtjvMfDi9E7ddb5nbub2hBWWg6Kih7Y5oTuNPFv5mE72zN
CHAIN_ID=493a38dc7c172cd8157fcfa4cc90ae955b3d2f714eba4dba959d5649e39efc15
ENDPOINT=https://jungle4.cryptolions.io:443

# create list of permissions
# pull all the permissions from eosio.prods
# create a new json array from the accounts
printf '[' > /tmp/requested.json
cleos -u $ENDPOINT get account eosio.prods -j \
       | jq .permissions[].required_auth.accounts[].permission \
       | sed 's/}/},/' >> /tmp/requested.json
LINES=$(cat /tmp/requested.json | wc -l)
let LINES=LINES-1
head -${LINES} /tmp/requested.json > /tmp/perms2.json
echo '}]' >> /tmp/perms2.json
mv /tmp/perms2.json /tmp/requested.json


# use cleos to create the multi-sig
# second line  json is requstor for my producer
# third line json  is permission for transaction
# fourth line is the action
cleos -u $ENDPOINT multisig propose \
    jung.svn.1 \
    /tmp/requested.json \
    '[{"actor": "eosio", "permission": "active"} ]' \
    eosio activate '{"feature_digest":"cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"}' \
    -p spaceranger1@active

## EXample Approve and Execut in cleos
#cleos multisig approve spaceranger1 testfeaturee \
#  '{"actor": "spaceranger1", "permission": "active"}' \
#  -p spaceranger1@active
#
# cleos multisig exec spaceranger1 testfeaturee -p spaceranger1@active

## SETUP EOSC
# DOWNLOAD RELEASE https://github.com/eoscanada/eosc/releases
# IMPORT KEYS eosc vault create --vault-file .eosc-vault-user --import

# Prepare unsigned setcode setabi transaction
# cleos -u $ENDPOINT multisig cancel spaceranger1 spring.upd spaceranger1

cleos -u $ENDPOINT set contract eosio ${CONTRACT_DIR}/eosio.system eosio.system.wasm eosio.system.abi -s -d \
    --json-file ${CONTRACT_DIR}/setcontract-eosio.system.json --expiration 8640000

eosc -u $ENDPOINT multisig propose spaceranger1 spring.upd \
    ${CONTRACT_DIR}/setcontract-eosio.system.json \
    --request-producers --vault-file .eosc-vault-spaceranger.json

# switch to savanna
ENDPOINT=https://jungle4.cryptolions.io:443
cleos -u $ENDPOINT push action eosio switchtosvnn '{}' -s -d --json-file ${CONTRACT_DIR}/jungle-switchtosvnn.json --expiration 8640000
eosc -u $ENDPOINT multisig propose spaceranger1 spring.svn \
    ${CONTRACT_DIR}/jungle-switchtosvnn.json \
    --request-producers --vault-file .eosc-vault-spaceranger.json

# Test
ENDPOINT=http://127.0.0.1:8888
cleos -u $ENDPOINT push action eosio switchtosvnn '{}' -s -d --json-file ${CONTRACT_DIR}/local-switchtosvnn.json --expiration 8640000
eosc -u $ENDPOINT multisig propose bpa spring.svn \
  ${CONTRACT_DIR}/local-switchtosvnn.json \
  --request-producers --vault-file .eosc-vault-bpa
