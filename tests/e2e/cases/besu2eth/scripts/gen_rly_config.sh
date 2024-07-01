#!/bin/sh
set -eux
LCP_BIN=${LCP_BIN:-lcp}
TEMPLATE_DIR=./tests/e2e/cases/besu2eth/configs/templates
CONFIG_DIR=./tests/e2e/cases/besu2eth/configs/demo

BESU_ADDRESSES_DIR=./tests/e2e/chains/besu/contracts/addresses
BESU_IBC_ADDRESS=`cat $BESU_ADDRESSES_DIR/IBCHandler`
BESU_LC_ADDRESS=`cat $BESU_ADDRESSES_DIR/LCPClient`

ETH_ADDRESSES_DIR=./tests/e2e/chains/ethereum/contracts/addresses
ETH_IBC_ADDRESS=`cat $ETH_ADDRESSES_DIR/IBCHandler`
ETH_LC_ADDRESS=`cat $ETH_ADDRESSES_DIR/LCPClient`

MRENCLAVE=$(${LCP_BIN} enclave metadata --enclave=./bin/enclave.signed.so | jq -r .mrenclave)
mkdir -p $CONFIG_DIR
jq -n -f ${TEMPLATE_DIR}/ibc-0.json.tpl --arg MRENCLAVE ${MRENCLAVE} --arg IBC_ADDRESS ${BESU_IBC_ADDRESS} --arg LC_ADDRESS $BESU_LC_ADDRESS > ${CONFIG_DIR}/ibc-0.json
jq -n -f ${TEMPLATE_DIR}/ibc-1.json.tpl --arg MRENCLAVE ${MRENCLAVE} --arg IBC_ADDRESS ${ETH_IBC_ADDRESS} --arg LC_ADDRESS $ETH_LC_ADDRESS > ${CONFIG_DIR}/ibc-1.json
