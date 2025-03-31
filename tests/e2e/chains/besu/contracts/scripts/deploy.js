const portMock = "mockapp";
const lcpClientType = "lcp-client-zkdcap";

function saveAddress(contractName, contract) {
  const fs = require("fs");
  const path = require("path");

  const dirpath = "addresses";
  if (!fs.existsSync(dirpath)) {
    fs.mkdirSync(dirpath, {recursive: true});
  }

  const filepath = path.join(dirpath, contractName);
  fs.writeFileSync(filepath, contract.target);

  console.log(`${contractName} address:`, contract.target);
}

async function deploy(deployer, contractName, args = []) {
  const factory = await hre.ethers.getContractFactory(contractName);
  const contract = await factory.connect(deployer).deploy(...args);
  await contract.waitForDeployment();
  return contract;
}

async function deployAndLink(deployer, contractName, libraries, args = []) {
  const factory = await hre.ethers.getContractFactory(contractName, {
    libraries: libraries
  });
  const contract = await factory.connect(deployer).deploy(...args);
  await contract.waitForDeployment();
  return contract;
}

async function deployLCPClientIAS(deployer, ibcHandler, developMode, rootCert) {
  const lcpProtoMarshaler = await deploy(deployer, "LCPProtoMarshaler");
  saveAddress("LCPProtoMarshaler", lcpProtoMarshaler);
  const avrValidator = await deploy(deployer, "AVRValidator");
  saveAddress("AVRValidator", avrValidator);
  const lcpClient = await deployAndLink(deployer, "LCPClientIAS", {
    LCPProtoMarshaler: lcpProtoMarshaler.target,
    AVRValidator: avrValidator.target
  }, [ibcHandler.target, developMode, rootCert]);
  saveAddress("LCPClient", lcpClient);
  return lcpClient;
}

async function deployLCPClientZKDCAP(deployer, ibcHandler, developMode, rootCert, isMock) {
  var riscZeroVerifier;
  if (isMock) {
    console.log("Deploying RiscZeroMockVerifier");
    riscZeroVerifier = await deploy(deployer, "RiscZeroMockVerifier", [
      // Selector
      "0x00000000"
    ]);
  } else {
    console.log("Deploying RiscZeroGroth16Verifier");
    // CONTROL_ROOT and BN254_CONTROL_ROOT must match the version of risc0 utilized by the LCP
    // ref. https://github.com/risc0/risc0-ethereum/blob/b9b22c396a0d5ef97bf02702da9415d5bb79a85a/contracts/src/groth16/ControlID.sol#L22 (v1.2)
    riscZeroVerifier = await deploy(deployer, "RiscZeroGroth16Verifier", [
      // CONTROL_ROOT
      "0x8cdad9242664be3112aba377c5425a4df735eb1c6966472b561d2855932c0469",
      // BN254_CONTROL_ROOT
      "0x04446e66d300eb7fb45c9726bb53c793dda407a62e9601618bb43c5c14657ac0"
    ]);
  }
  const lcpProtoMarshaler = await deploy(deployer, "LCPProtoMarshaler");
  saveAddress("LCPProtoMarshaler", lcpProtoMarshaler);
  const dcapValidator = await deploy(deployer, "DCAPValidator");
  saveAddress("DCAPValidator", dcapValidator);
  const lcpClient = await deployAndLink(deployer, "LCPClientZKDCAP", {
    LCPProtoMarshaler: lcpProtoMarshaler.target,
    DCAPValidator: dcapValidator.target
  }, [ibcHandler.target, developMode, rootCert, riscZeroVerifier.target]);
  saveAddress("LCPClient", lcpClient);
  return lcpClient;
}

async function deployIBC(deployer) {
  const logicNames = [
    "IBCClient",
    "IBCConnectionSelfStateNoValidation",
    "IBCChannelHandshake",
    "IBCChannelPacketSendRecv",
    "IBCChannelPacketTimeout",
    "IBCChannelUpgradeInitTryAck",
    "IBCChannelUpgradeConfirmOpenTimeoutCancel"
  ];
  const logics = [];
  for (const name of logicNames) {
    const logic = await deploy(deployer, name);
    logics.push(logic);
  }
  return deploy(deployer, "OwnableIBCHandler", logics.map(l => l.target));
}

async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  const fs = require('fs');
  let rootCert;
  if (process.env.NO_RUN_LCP === "false" && process.env.SGX_MODE === "SW") {
    if (process.env.ZKDCAP === "true") {
      console.log("zkDCAP RA simulation is enabled");
      rootCert = fs.readFileSync("../config/simulation_dcap_rootca.der");
    } else {
      console.log("RA simulation is enabled");
      rootCert = fs.readFileSync("../config/simulation_rootca.der");
    }
  } else {
    if (process.env.ZKDCAP === "true") {
      console.log("ZKDCAP is enabled");
      rootCert = fs.readFileSync("../config/Intel_SGX_Provisioning_Certification_RootCA.der");
    } else {
      console.log("RA simulation is disabled");
      rootCert = fs.readFileSync("../config/Intel_SGX_Attestation_RootCA.der");
    }
  }

  let developMode = process.env.LCP_ENCLAVE_DEBUG === "1";
  console.log("Develop mode:", developMode);

  // ethers is available in the global scope
  const [deployer] = await hre.ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.getAddress())).toString());

  const ibcHandler = await deployIBC(deployer);
  saveAddress("IBCHandler", ibcHandler)

  if (process.env.ZKDCAP === "true") {
    console.log("Deploying LCPClientZKDCAP");
    const lcpClient = await deployLCPClientZKDCAP(deployer, ibcHandler, developMode, rootCert, process.env.LCP_ZKDCAP_RISC0_MOCK === "true");
    await ibcHandler.registerClient(lcpClientType, lcpClient.target);
  } else {
    console.log("Deploying LCPClientIAS");
    const lcpClient = await deployLCPClientIAS(deployer, ibcHandler, developMode, rootCert);
    await ibcHandler.registerClient(lcpClientType, lcpClient.target);
  }

  const mockApp = await deploy(deployer, "MockApp", [ibcHandler.target]);
  saveAddress("MockApp", mockApp)

  await ibcHandler.bindPort(portMock, mockApp.target);
}

if (require.main === module) {
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}

exports.deployIBC = deployIBC;
