const hre = require("hardhat");

async function main() {
  console.log("Deploying BigViewMission...");

    const BigViewMission = await hre.ethers.getContractFactory("BigViewMission");
      
        // This deploys the contract
          const mission = await BigViewMission.deploy();

            await mission.waitForDeployment();

              console.log(`Success! BigViewMission deployed to: ${await mission.getAddress()}`);
              }

              main().catch((error) => {
                console.error(error);
                  process.exitCode = 1;
                  });