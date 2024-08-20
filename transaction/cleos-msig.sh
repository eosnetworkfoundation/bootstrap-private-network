#!/bin/env bash

# use cleos to create the multi-sig
# second line  json is requstor my block producer account
# thirs line json  is permission for transaction
# fourth line is the action 
cleos multisig propose testfeaturee \
'[{"actor": "bpa", "permission": "active"}, {"actor": "bpb", "permission": "active"}, {"actor": "bpc", "permission": "active"}]' \
      '[{"actor": "eosio", "permission": "active"} ]' \
      eosio activate '{"feature_digest":"cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"}' \
      -p bpa@active

cleos multisig approve bpa testfeatured \
  '{"actor": "bpa", "permission": "active"}' \
  -p bpa@active
cleos multisig approve bpa testfeatured \
    '{"actor": "bpb", "permission": "active"}' \
    -p bpb@active
cleos multisig approve bpa testfeatured \
    '{"actor": "bpc", "permission": "active"}' \
    -p bpc@active

cleos multisig exec bpa testfeatured -p bpa@active
