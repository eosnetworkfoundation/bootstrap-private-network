#!/usr/bin/env bash

####
# Once private network is setup and running with legacy consensus algo
# we can switch over to new finality method
# For each producers we will register new BLS keys
# and `switchtosvnn` will activate Savanna Algorithm
####

ENDPOINT=$1
# First array starts from the second argument to the 22st argument
PUBLIC_KEY=("${@:2:22}")
# Second array starts from the 23rd argument to the 43rd argument
PROOF_POSSESION=("${@:23:43}")


# unwindw our producer finalizer keys and make activating call
# New System Contracts Replace with actions regfinkey, and switchtosvnn
# regfinkey [producer name] [public key] [proof of possession]
counter=0
for producer_name in bpa bpb bpc bpd bpe bpf bpg bph bpi bpj bpk bpl bpm bpn bpo bpp bpq bpr bps bpt bpu
do
    let counter+=1

    # Execute the cleos command error if vars not set
    cleos --url $ENDPOINT push action eosio regfinkey "${producer_name:?}" "${PUBLIC_KEY[$counter]:?}" "${PROOF_POSSESION[$counter]:?}"
done

sleep 1

# switchtosvnn
cleos --url $ENDPOINT push action eosio switchtosvnn
