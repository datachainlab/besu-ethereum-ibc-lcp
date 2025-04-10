{
  "chain": {
    "@type": "/relayer.chains.ethereum.config.ChainConfig",
    "chain_id": "ibc0",
    "eth_chain_id": 2018,
    "rpc_addr": "http://localhost:8645",
    "signer": {
      "@type": "/relayer.signers.hd.SignerConfig",
      "mnemonic": "math razor capable expose worth grape metal sunset metal sudden usage scheme",
      "path": "m/44'/60'/0'/0/0"
    },
    "ibc_address": $IBC_ADDRESS,
    "initial_send_checkpoint": 1,
    "initial_recv_checkpoint": 1,
    "enable_debug_trace": false,
    "average_block_time_msec": 1000,
    "max_retry_for_inclusion": 5,
    "gas_estimate_rate": {
      "numerator": 1,
      "denominator": 1
    },
    "max_gas_limit": 10000000,
    "tx_type": "legacy",
    "abi_paths": ["../../chains/besu/contracts/abis"],
    "allow_lc_functions": {
      "lc_address": $LC_ADDRESS,
      "allow_all": false,
      "selectors": [
        "0xa97c61d6",
        "0x6ac73aa0"
      ]
    }
  },
  "prover": {
    "@type": "/relayer.provers.lcp.config.ProverConfig",
    "origin_prover": {
      "@type": "/relayer.provers.qbft.config.ProverConfig",
      "consensus_type": "qbft",
      "trusting_period": "336h",
      "max_clock_drift": "30s",
      "refresh_threshold_rate": {
        "numerator": 2,
        "denominator": 3
      }
    },
    "lcp_service_address": "localhost:50051",
    "mrenclave": $MRENCLAVE,
    "allowed_quote_statuses": ["SWHardeningNeeded"],
    "allowed_advisory_ids": ["INTEL-SA-00219","INTEL-SA-00289","INTEL-SA-00334","INTEL-SA-00477","INTEL-SA-00614","INTEL-SA-00615","INTEL-SA-00617", "INTEL-SA-00828"],
    "key_expiration": $LCP_KEY_EXPIRATION,
    "key_update_buffer_time": 3600,
    "elc_client_id": "hb-qbft-0",
    "message_aggregation": true,
    "is_debug_enclave": $IS_DEBUG_ENCLAVE,
    "current_tcb_evaluation_data_number": 1,
    "tcb_evaluation_data_number_update_grace_period": 0,
    "risc0_zkvm_config": {
      "image_id": $RISC0_IMAGE_ID,
      "mock": $LCP_ZKDCAP_RISC0_MOCK
    },
    "operators": [
      "0x9722414d09f43fb02235d739B50F4C027F43e657"
    ],
    "operator_signer": {
      "@type": "/relayer.provers.lcp.signers.raw.SignerConfig",
      "private_key": "0x8a94e9f944a297c402a997aa9a60026ce47a6e018192d111c1703176bbc26651"
    },
    "operators_eip712_evm_chain_params": {
      "chain_id": 15,
      "verifying_contract_address": $LC_ADDRESS
    }
  }
}
