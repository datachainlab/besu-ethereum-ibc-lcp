DOCKER_COMPOSE ?= docker compose
COMPOSE_UP_OPTS ?= -d
HARDHAT ?= npx hardhat

#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------

.PHONY: network
network:
	$(DOCKER_COMPOSE) up $(COMPOSE_UP_OPTS)

.PHONY: network-down
network-down:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

#------------------------------------------------------------------------------
# Contract Deployment
#------------------------------------------------------------------------------
.PHONY:deploy
deploy:
	cd contracts && $(HARDHAT) run ./scripts/deploy.js --network besu_local

.PHONY: dep
dep:
	cd contracts && npm install

.PHONY: clean
clean:
	cd contracts && $(HARDHAT) clean && rm -rf node_modules abis addresses && rm -f package-lock.json

.PHONY: extract-abi
extract-abi:
	./scripts/extract-abi.sh
