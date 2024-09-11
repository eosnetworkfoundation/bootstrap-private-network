#!/usr/bin/env bash

####
# Once private network is setup and running with legacy consensus algo
# we can switch over to new finality method
# For each producers we will register new BLS keys
# and `switchtosvnn` will activate Savanna Algorithm
####

ENDPOINT=$1
# First array starts from the second argument to the 22st argument
PUBLIC_KEY=("${@:2:4}")
# Second array starts from the 23rd argument to the 43rd argument
PROOF_POSSESION=("${@:5:7}")

# DISABLE_DEFERRED_TRXS_STAGE_1
cleos --url $ENDPOINT push action eosio activate '["fce57d2331667353a0eac6b4209b67b843a7262a848af0a49a6e2fa9f6584eb4"]' -p eosio
# DISABLE_DEFERRED_TRXS_STAGE_2
cleos --url $ENDPOINT push action eosio activate '["09e86cb0accf8d81c9e85d34bea4b925ae936626d00c984e4691186891f5bc16"]' -p eosio
# BLS_PRIMITIVES2
cleos --url $ENDPOINT push action eosio activate '["63320dd4a58212e4d32d1f58926b73ca33a247326c2a5e9fd39268d2384e011a"]' -p eosio
# SAVANNA
# Depends on all other protocol features
cleos --url $ENDPOINT push action eosio activate '["cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"]' -p eosio

sleep 2

# unwindw our producer finalizer keys and make activating call
# New System Contracts Replace with actions regfinkey, and switchtosvnn
# regfinkey [producer name] [public key] [proof of possession]
counter=0
for producer_name in bpa bpb bpc
do
    # Execute the cleos command error if vars not set
    # void system_contract::regfinkey( const name& finalizer_name, const std::string& finalizer_key, const std::string& proof_of_possession)
    cleos --url $ENDPOINT push action eosio regfinkey "{\"finalizer_name\":\"${producer_name:?}\", \
                            \"finalizer_key\":\"${PUBLIC_KEY[$counter]:?}\", \
                            \"proof_of_possession\":\"${PROOF_POSSESION[$counter]:?}\"}" -p ${producer_name:?}
    let counter+=1
done

sleep 1

# switchtosvnn
# void system_contract::switchtosvnn()
cleos --url $ENDPOINT push action eosio switchtosvnn '{}' -p eosio
