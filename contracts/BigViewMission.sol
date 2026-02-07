// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BigViewMission is ERC2771Context, Ownable, ReentrancyGuard {
        
            struct Quest {
                        bytes32 secretHash; 
                                uint256 reward;     
                                        bool isClaimed;      // RACE LOGIC: Is the treasure already gone?
                                                uint256 totalPricePool;
                                                        string name;
                                                                uint256 entryFee;
                                                                        bool isActive;
                                                                                uint256 deadline;    // TIME LIMIT: When the quest expires
            }

                mapping(uint256 => Quest) public quests;
                    mapping(address => uint256) public playerLevel;
                        mapping(address => mapping(uint256 => bool)) public hasCompletedQuest;
                            mapping(uint256 => mapping(address => bool)) public hasJoined;
                                
                                    // COMMIT-REVEAL: To prevent front-running/stealing secrets
                                        mapping(address => bytes32) public submissionCommitments;

                                            uint256 public totalQuests;

                                                event QuestJoined(uint256 indexed _questId, address indexed player);
                                                    event QuestSolved(address indexed player, uint256 questId, uint256 reward);
                                                        event CommitmentMade(address indexed player, bytes32 commitment);

                                                            constructor(address trustedForwarder) ERC2771Context(trustedForwarder) Ownable(msg.sender) {}

                                                                // 1. ADMIN LOGIC: Launch new hunts
                                                                    function launchNewQuest(
                                                                                string memory _name, 
                                                                                        uint256 _reward, 
                                                                                                uint256 _fee, 
                                                                                                        bytes32 _secretHash,
                                                                                                                uint256 _durationMinutes
                                                                    ) public onlyOwner {
                                                                                quests[totalQuests] = Quest({
                                                                                                secretHash: _secretHash,
                                                                                                            reward: _reward,
                                                                                                                        isClaimed: false,
                                                                                                                                    totalPricePool: 0,
                                                                                                                                                name: _name,
                                                                                                                                                            entryFee: _fee,
                                                                                                                                                                        isActive: true,
                                                                                                                                                                                    deadline: block.timestamp + (_durationMinutes * 1 minutes)
                                                                                });
                                                                                        totalQuests++;
                                                                    }

                                                                        // 2. PLAYER LOGIC: Join with Level Locking
                                                                            function joinQuest(uint256 _questId) public payable {
                                                                                        address player = _msgSender(); 
                                                                                                Quest storage quest = quests[_questId];
                                                                                                        
                                                                                                                require(quest.isActive, "Mission Not active");
                                                                                                                        require(block.timestamp < quest.deadline, "Quest has expired");
                                                                                                                                require(!quest.isClaimed, "Treasure already found!");
                                                                                                                                        require(playerLevel[player] == _questId, "Complete previous levels first!"); // PROGRESSION LOGIC
                                                                                                                                                require(!hasJoined[_questId][player], "Already In The Mission");
                                                                                                                                                        require(msg.value >= quest.entryFee, "Insufficient entry fee");

                                                                                                                                                                hasJoined[_questId][player] = true;
                                                                                                                                                                        quest.totalPricePool += quest.entryFee;

                                                                                                                                                                                emit QuestJoined(_questId, player);

                                                                                                                                                                                        if(msg.value > quest.entryFee) {
                                                                                                                                                                                                        uint256 refund = msg.value - quest.entryFee;
                                                                                                                                                                                                                    (bool success, ) = payable(player).call{value: refund}("");
                                                                                                                                                                                                                                require(success, "Refund Failed");
                                                                                                                                                                                        }
                                                                            }

                                                                                // 3. GAMEPLAY LOGIC: Complete the mission
                                                                                    function completeQuest(uint256 _questId) public {
                                                                                                address player = _msgSender();
                                                                                                        require(hasJoined[_questId][player], "Must join quest first");
                                                                                                                hasCompletedQuest[player][_questId] = true;
                                                                                    }

                                                                                        // 4. SECURITY LOGIC: Step 1 - Commit the secret (to prevent front-running)
                                                                                            function commitSecret(bytes32 _commitment) public {
                                                                                                        submissionCommitments[_msgSender()] = _commitment;
                                                                                                                emit CommitmentMade(_msgSender(), _commitment);
                                                                                            }

                                                                                                // 5. SECURITY LOGIC: Step 2 - Reveal and Claim
                                                                                                    function claimTreasure(uint256 _questId, string memory _secretKey) public nonReentrant {
                                                                                                                address player = _msgSender(); 
                                                                                                                        Quest storage quest = quests[_questId];

                                                                                                                                // Ensure the commitment matches (secret + player address)
                                                                                                                                        bytes32 expectedCommitment = keccak256(abi.encodePacked(_secretKey, player));
                                                                                                                                                require(submissionCommitments[player] == expectedCommitment, "Commitment mismatch or not found");
                                                                                                                                                        
                                                                                                                                                                require(!quest.isClaimed, "Too late! Someone else found it.");
                                                                                                                                                                        require(block.timestamp < quest.deadline, "Quest expired!");
                                                                                                                                                                                require(hasCompletedQuest[player][_questId], "Mission task not finished!");
                                                                                                                                                                                        require(keccak256(abi.encodePacked(_secretKey)) == quest.secretHash, "Incorrect Secret Key!");

                                                                                                                                                                                                uint256 totalAvailable = quest.reward + quest.totalPricePool;
                                                                                                                                                                                                        uint256 devFee = (totalAvailable * 5) / 100;
                                                                                                                                                                                                                uint256 playerNet = totalAvailable - devFee;

                                                                                                                                                                                                                        // Update state to prevent double claim and block others
                                                                                                                                                                                                                                quest.isClaimed = true;
                                                                                                                                                                                                                                        playerLevel[player]++;
                                                                                                                                                                                                                                                delete submissionCommitments[player]; // Clear commitment

                                                                                                                                                                                                                                                        // Transfers
                                                                                                                                                                                                                                                                (bool devSuccess, ) = payable(owner()).call{value: devFee}("");
                                                                                                                                                                                                                                                                        (bool success, ) = payable(player).call{value: playerNet}("");
                                                                                                                                                                                                                                                                                require(success && devSuccess, "Reward transfer failed");

                                                                                                                                                                                                                                                                                        emit QuestSolved(player, _questId, playerNet);
                                                                                                    }

                                                                                                        // 6. RECOVERY LOGIC: If a quest expires, owner can reclaim base reward
                                                                                                            function recycleExpiredQuest(uint256 _questId) public onlyOwner {
                                                                                                                        Quest storage quest = quests[_questId];
                                                                                                                                require(block.timestamp > quest.deadline && !quest.isClaimed, "Quest still valid or claimed");
                                                                                                                                        quest.isActive = false;
                                                                                                                                                // Logic to move funds or withdraw could go here
                                                                                                            }

                                                                                                                function _msgSender() internal view override(Context, ERC2771Context) returns (address) {
                                                                                                                            return ERC2771Context._msgSender();
                                                                                                                }

                                                                                                                    function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata) {
                                                                                                                                return ERC2771Context._msgData();
                                                                                                                    }

                                                                                                                        receive() external payable {}
}
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                    }
                                                                                            }
                                                                                    }
                                                                                                                                                                                        }
                                                                            }
                                                                                })
                                                                    }
                                                                    )
            }
}