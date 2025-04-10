#!/bin/sh
set -ex

IS_DEBUG_ENCLAVE=false

if [ "$LCP_ENCLAVE_DEBUG" = "1" ]; then
    IS_DEBUG_ENCLAVE=true
fi
if [ -z "$LCP_KEY_EXPIRATION" ]; then
    echo "LCP_KEY_EXPIRATION is not set"
    exit 1
fi
# set LCP_ZKDCAP_RISC0_MOCK as false if not set
if [ -z "$LCP_ZKDCAP_RISC0_MOCK" ]; then
    LCP_ZKDCAP_RISC0_MOCK=false
fi

TEMPLATE_DIR=${E2E_TEST_DIR}/configs/templates
CONFIG_DIR=${E2E_TEST_DIR}/configs/demo

BESU_ADDRESSES_DIR=./tests/e2e/chains/besu/contracts/addresses
BESU_IBC_ADDRESS=`cat $BESU_ADDRESSES_DIR/IBCHandler`
BESU_LC_ADDRESS=`cat $BESU_ADDRESSES_DIR/LCPClient`

ETH_ADDRESSES_DIR=./tests/e2e/chains/ethereum/contracts/addresses
ETH_IBC_ADDRESS=`cat $ETH_ADDRESSES_DIR/IBCHandler`
ETH_LC_ADDRESS=`cat $ETH_ADDRESSES_DIR/LCPClient`

MRENCLAVE=$(${LCP_BIN} enclave metadata --enclave=./bin/enclave.signed.so | jq -r .mrenclave)
mkdir -p $CONFIG_DIR
if [ "$ZKDCAP" = true ]; then
    if [ -z "$LCP_RISC0_IMAGE_ID" ]; then
        echo "LCP_RISC0_IMAGE_ID is not set"
        exit 1
    fi

    jq -n \
        --arg MRENCLAVE ${LCP_MRENCLAVE} \
        --argjson IS_DEBUG_ENCLAVE ${IS_DEBUG_ENCLAVE} \
        --argjson LCP_KEY_EXPIRATION ${LCP_KEY_EXPIRATION} \
        --arg IBC_ADDRESS ${BESU_IBC_ADDRESS} \
        --arg LC_ADDRESS ${BESU_LC_ADDRESS} \
        --arg RISC0_IMAGE_ID ${LCP_RISC0_IMAGE_ID} \
        --argjson LCP_ZKDCAP_RISC0_MOCK ${LCP_ZKDCAP_RISC0_MOCK} \
        -f ${TEMPLATE_DIR}/ibc-0-zkdcap.json.tpl > ${CONFIG_DIR}/ibc-0.json

    jq -n \
        --arg MRENCLAVE ${LCP_MRENCLAVE} \
        --argjson IS_DEBUG_ENCLAVE ${IS_DEBUG_ENCLAVE} \
        --argjson LCP_KEY_EXPIRATION ${LCP_KEY_EXPIRATION} \
        --arg IBC_ADDRESS ${ETH_IBC_ADDRESS} \
        --arg LC_ADDRESS ${ETH_LC_ADDRESS} \
        --arg RISC0_IMAGE_ID ${LCP_RISC0_IMAGE_ID} \
        --argjson LCP_ZKDCAP_RISC0_MOCK ${LCP_ZKDCAP_RISC0_MOCK} \
        -f ${TEMPLATE_DIR}/ibc-1-zkdcap.json.tpl > ${CONFIG_DIR}/ibc-1.json
else
    jq -n \
        --arg MRENCLAVE ${LCP_MRENCLAVE} \
        --argjson IS_DEBUG_ENCLAVE ${IS_DEBUG_ENCLAVE} \
        --argjson LCP_KEY_EXPIRATION ${LCP_KEY_EXPIRATION} \
        --arg IBC_ADDRESS ${BESU_IBC_ADDRESS} \
        --arg LC_ADDRESS ${BESU_LC_ADDRESS} \
        -f ${TEMPLATE_DIR}/ibc-1.json.tpl > ${CONFIG_DIR}/ibc-1.json

    jq -n \
        --arg MRENCLAVE ${LCP_MRENCLAVE} \
        --argjson IS_DEBUG_ENCLAVE ${IS_DEBUG_ENCLAVE} \
        --argjson LCP_KEY_EXPIRATION ${LCP_KEY_EXPIRATION} \
        --arg IBC_ADDRESS ${ETH_IBC_ADDRESS} \
        --arg LC_ADDRESS ${ETH_LC_ADDRESS} \
        -f ${TEMPLATE_DIR}/ibc-1.json.tpl > ${CONFIG_DIR}/ibc-1.json
fi
