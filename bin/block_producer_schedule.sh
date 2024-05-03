#!/usr/bin/env bash

ENDPOINT=$1
PUBLIC_KEY=$2

# create 21 producers error out if vars not set
for producer_name in bpa bpb bpc bpd bpe bpf bpg bph bpi bpj bpk bpl bpm bpn bpo bpp bpq bpr bps bpt bpu
do
    cleos system newaccount eosio ${producer_name:?} ${PUBLIC_KEY:?} --stake-net "50 EOS" --stake-cpu "50 EOS" --buy-ram "500 EOS"
    # get some spending money
    cleos --url $ENDPOINT transfer eosio ${producer_name} "10000 EOS" "init funding"
    # register producer
    cleos --url $ENDPOINT system regproducer ${producer_name} ${PUBLIC_KEY}
done

# cleos --url $ENDPOINT system voteproducer prods eosio bpa bpb bpc
