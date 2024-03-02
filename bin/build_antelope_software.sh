#!/usr/bin/env bash

####
# Builds leap/nodeos and cdt software
# does not install software
# called from Docker Build
###

LEAP_GIT_COMMIT_TAG=${1:-hotstuff_integration}
CDT_GIT_COMMIT_TAG=${2:-hotstuff_integration}
NPROC=${3:-$(nproc)}
TUID=$(id -ur)

# must not be root to run
if [ "$TUID" -eq 0 ]; then
  echo "Can not run as root user exiting"
  exit
fi

ROOT_DIR=/local/eosnetworkfoundation
LEAP_GIT_DIR="${ROOT_DIR}"/repos/leap
LEAP_BUILD_DIR="${ROOT_DIR}"/leap_build
LOG_DIR=/bigata1/log
cd "${LEAP_GIT_DIR:?}" || exit

git checkout $LEAP_GIT_COMMIT_TAG
git pull origin $LEAP_GIT_COMMIT_TAG
git submodule update --init --recursive

[ ! -d "$LEAP_BUILD_DIR"/packages ] && mkdir -p "$LEAP_BUILD_DIR"/packages
cd "${LEAP_BUILD_DIR:?}" || exit

echo "BUILDING LEAP FROM ${LEAP_GIT_COMMIT_TAG}"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-11 "$LEAP_GIT_DIR" >> "$LOG_DIR"/leap_build_log.log 2>&1
make -j ${NPROC} package >> "$LOG_DIR"/leap_build_log.log 2>&1
echo "FINISHED BUILDING LEAP"


echo "BUILDING CDT FROM ${CDT_GIT_COMMIT_TAG}"
cd "${ROOT_DIR:?}"/repos/cdt || exit

git checkout $CDT_GIT_COMMIT_TAG
git pull origin $CDT_GIT_COMMIT_TAG

mkdir build
cd build || exit
export leap_DIR="$LEAP_BUILD_DIR"/lib/cmake/leap
cmake .. >> "$LOG_DIR"/cdt_build_log.log 2>&1
make -j ${NPROC} >> "$LOG_DIR"/cdt_build_log.log 2>&1
echo "FINSIHED BUILDING CDT"
