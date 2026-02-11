import React from 'react';

export default function Header({ walletAddress, balance }) {
  const shortAddress = walletAddress 
      ? `${walletAddress.slice(0, 6)}...${walletAddress.slice(-4)}` 
          : "Connect Wallet"; // Better default text

            return (
                <header className="flex justify-between items-center py-4 border-b border-slate-800">
                      <div className="flex items-center space-x-2">
                              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center font-bold shadow-lg shadow-blue-500/20">Q</div>
                                      <div>
                                                 <h1 className="text-xl font-bold tracking-tight">Quest<span className="text-blue-500">L2</span></h1>
                                                            {/* Added a tiny status indicator */}
                                                                       <div className="flex items-center gap-1">
                                                                                    <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse"></div>
                                                                                                 <span className="text-[10px] text-slate-500 uppercase font-bold">Mainnet Live</span>
                                                                                                            </div>
                                                                                                                    </div>
                                                                                                                          </div>
                                                                                                                                
                                                                                                                                      <div className="text-right">
                                                                                                                                              <p className="text-xs text-slate-400 font-mono bg-slate-800 px-2 py-1 rounded-md">{shortAddress}</p>
                                                                                                                                                      <p className="text-sm font-bold text-green-400 mt-1">{balance || "0.00"} ETH</p>
                                                                                                                                                            </div>
                                                                                                                                                                </header>
                                                                                                                                                                  );
                                                                                                                                                                  }