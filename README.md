# besu-ethereum-ibc-lcp

This repository contains the configuration and scripts to run an e2e demo of the IBC between Besu and Ethereum utilizing the LCP.

## Run e2e tests

### Prerequisites

- Install lcp v0.2.13 in your PATH

### Run tests

```bash
# build ethereum execution and consensus client images
$ make build-images
# install contracts using npm
$ make prepare-contracts
# run e2e tests
$ make e2e-test
```

## Module versions

- [ibc-solidity v0.3.40](https://github.com/hyperledger-labs/yui-ibc-solidity/releases/tag/v0.3.40)
- [lcp v0.2.13](https://github.com/datachainlab/lcp/releases/tag/v0.2.13)
- [ethereum-elc v0.1.0](https://github.com/datachainlab/ethereum-elc/releases/tag/v0.1.0)
- [besu-qbft-elc v0.1.4](https://github.com/datachainlab/besu-qbft-elc/releases/tag/v0.1.4)
- [lcp-go v0.2.18-0.20250326095730-101ba8c9dfa1](https://github.com/datachainlab/lcp-go/tree/101ba8c9dfa1b7c9153490dfd91c5242d9e43862)
- [lcp-solidity v0.2.0-rc.3](https://github.com/datachainlab/lcp-solidity/releases/tag/v0.2.0-rc.3)
- [yui-relayer v0.5.13](https://github.com/hyperledger-labs/yui-relayer/releases/tag/v0.5.13)
- [ethereum-ibc-relay-chain v0.3.17](https://github.com/datachainlab/ethereum-ibc-relay-chain/releases/tag/v0.3.17)
- [ethereum-ibc-relay-prover v0.3.10](https://github.com/datachainlab/ethereum-ibc-relay-prover/releases/tag/v0.3.10)
- [besu-ibc-relay-prover v0.2.8](https://github.com/datachainlab/besu-ibc-relay-prover/releases/tag/v0.2.8)
