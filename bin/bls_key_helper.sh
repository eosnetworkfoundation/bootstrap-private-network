#!/usr/bin/env bash

NAME=${1:-scratch}

ROOT_DIR="/bigata1/savanna"
LOG_DIR="/bigata1/log"
WALLET_DIR=${HOME}/eosio-wallet

spring-util bls create key --to-console > "${WALLET_DIR:?}"/"${NAME}.finalizer.key"
PUBLIC_KEY+=( $(grep Public "${WALLET_DIR}"/"${NAME}.finalizer.key" | cut -d: -f2 | sed 's/ //g') ) \
  || exit 127
PRIVATE_KEY+=( $(grep Private "${WALLET_DIR}"/"${NAME}.finalizer.key" | cut -d: -f2 | sed 's/ //g') ) \
  || exit 127
PROOF_POSSESION+=( $(grep Possession "${WALLET_DIR}"/"${NAME}.finalizer.key" | cut -d: -f2 | sed 's/ //g') ) \
  || exit 127

echo "# ${NAME} finalizer key"
echo "signature-provider = ""${PUBLIC_KEY[@]: -1}""=KEY:""${PRIVATE_KEY[@]: -1}"
