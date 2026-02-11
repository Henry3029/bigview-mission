import React, { useState } from 'react';
import Header from './components/Header';
import QuestCard from './components/QuestCard';
import MissionLog from './components/MissionLog';

function App() {
  // Start at 0 to match Solidity totalQuests
    const [currentLevel, setCurrentLevel] = useState(0);
      const [walletAddress, setWalletAddress] = useState("0x..."); // You'll get this from MetaMask later
      const [walletBalance, setWalletBalance] = useState("0.00");

        const handleClaimProcess = async (secret) => {
            console.log("Starting Two-Step Claim for:", secret);
                // 1. Call createCommitment(secret, walletAddress)
                    // 2. Call contract.commitSecret(commitment)
                        // 3. Wait for block, then call contract.claimTreasure(currentLevel, secret)
                            // 4. If successful: setCurrentLevel(prev => prev + 1)
                              };

                                return (
                                    <div className="min-h-screen bg-slate-900 text-white p-4">
                                          <Header 
                                                  walletAddress={walletAddress} 
                                                          balance={walletBalance} 
                                                                />
                                                                      <main className="max-w-md mx-auto space-y-6 mt-8">
                                                                              <QuestCard 
                                                                                        level={currentLevel} 
                                                                                                  onVerify={handleClaimProcess} 
                                                                                                          />
                                                                                                                  <MissionLog currentLevel={currentLevel} />
                                                                                                                        </main>
                                                                                                                            </div>
                                                                                                                              );
                                                                                                                              }
                                                                                                                              export default App;