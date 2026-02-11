import React, { useState } from 'react';

export default function QuestCard({ level, onVerify }) {
  const [userInput, setUserInput] = useState("");

    const hints = [
        "Find the place where the three roads meet under the giant eagle...",
            "The secret gate lies where the shadow falls at noon in Wuse...",
                "The golden summit awaits those who climb the highest peak in Maitama..."
                  ];

                    return (
                        <section className="bg-slate-800 rounded-2xl p-6 shadow-xl border border-slate-700">
                              <h2 className="text-xl font-bold mb-2 text-blue-400">Mission {level}</h2>
                                    <p className="text-slate-300 italic mb-6">
                                            "{hints[level] || "More missions coming soon..."}"
                                                  </p>

                                                        <input 
                                                                type="text"
                                                                        placeholder="Enter secret found at location..."
                                                                                className="w-full p-3 mb-4 rounded-lg bg-slate-900 border border-slate-600 text-white focus:border-blue-500 outline-none"
                                                                                        value={userInput}
                                                                                                onChange={(e) => setUserInput(e.target.value)}
                                                                                                      />

                                                                                                            <button 
                                                                                                                    onClick={() => onVerify(userInput)}
                                                                                                                            className="w-full bg-blue-600 hover:bg-blue-500 py-3 rounded-xl font-bold transition-all active:scale-95"
                                                                                                                                  >
                                                                                                                                          📍 Verify & Claim Treasure
                                                                                                                                                </button>
                                                                                                                                                    </section>
                                                                                                                                                      );
                                                                                                                                                      }