#!/bin/bash

set -euxo pipefail

sudo apt-get update -y
sudo apt-get install -y \
  file xxd \
  build-essential python-is-python3 \
  clang libclang-dev

rustup show

# install Intel SGX SDK.
sudo bash lcp/.github/scripts/install_sgx_sdk.sh /opt

# Install Foundry.
$(dirname $0)/install_foundry.sh

cat << EOF | tee -a ~/.bashrc
export PATH="/workspaces/besu-ethereum-ibc-lcp/lcp/bin:\$PATH"
export SGX_MODE=SW
source /opt/sgxsdk/environment
EOF
