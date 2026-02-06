require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
      version: "0.8.19",
          settings: {
                optimizer: {
                        enabled: true,
                                runs: 200,
                                      },
                                          },
                                            },
                                              networks: {
                                                  "base-sepolia": {
                                                        url: process.env.RPC_URL || "https://sepolia.base.org",
                                                              accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
                                                                  },
                                                                    },
                                                                    };