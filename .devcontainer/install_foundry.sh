#!/bin/bash

set -euxo pipefail

curl -L https://foundry.paradigm.xyz | bash

export PATH="$PATH:~/.foundry/bin"
foundryup
