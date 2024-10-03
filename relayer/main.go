package main

import (
	"fmt"
	"os"

	besulc "github.com/datachainlab/besu-ibc-relay-prover/module"
	"github.com/datachainlab/ethereum-ibc-relay-chain/pkg/relay/ethereum"
	ethereumlc "github.com/datachainlab/ethereum-ibc-relay-prover/relay"
	"github.com/datachainlab/ibc-hd-signer/pkg/hd"
	lcp "github.com/datachainlab/lcp-go/relay"
	rawsigner "github.com/datachainlab/lcp-go/relay/signers/raw"
	"github.com/hyperledger-labs/yui-relayer/cmd"
)

func main() {
	if err := cmd.Execute(
		besulc.Module{},
		ethereum.Module{},
		ethereumlc.Module{},
		hd.Module{},
		lcp.Module{},
		rawsigner.Module{},
	); err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
		os.Exit(1)
	}
}
