RLY_BIN ?= ../../../../bin/yrly

.PHONY: network
network:
	$(MAKE) -C ../../chains/besu network
	$(MAKE) -C ../../chains/ethereum network
	sleep 10
	$(MAKE) -C ../../chains/besu deploy extract-abi
	$(MAKE) -C ../../chains/ethereum deploy extract-abi

.PHONY: network-down
network-down:
	$(MAKE) -C ../../chains/besu network-down
	$(MAKE) -C ../../chains/ethereum network-down

.PHONY: setup
setup:
	RLY_BIN=$(RLY_BIN) ./scripts/init-rly

.PHONY: handshake
handshake:
	RLY_BIN=$(RLY_BIN) ./scripts/handshake

.PHONY: test
test:
	RLY_BIN=$(RLY_BIN) ./scripts/test-tx

.PHONY: restore
restore:
	RLY_BIN=$(RLY_BIN) ./scripts/restore
