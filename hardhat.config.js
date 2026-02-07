require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
      version: "0.8.20",
          settings: {
                optimizer: {
                        enabled: true,
                                runs: 200,
                                      },
                                          },
                                            },
                                              // This is the part that was missing or hidden!
                                                paths: {
                                                    sources: "./contracts",
                                                        tests: "./test",
                                                            cache: "./cache",
                                                                artifacts: "./artifacts" 
                                                                  },
                                                                    networks: {
                                                                        "base-sepolia": {
                                                                              url: process.env.RPC_URL || "https://sepolia.base.org",
                                                                                    accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
                                                                                        },
                                                                                          },
                                                                                          };