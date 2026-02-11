import { ethers } from 'ethers';

// To match: keccak256(abi.encodePacked(_secretKey))
export const createSecretHash = (secretKey) => {
    return ethers.solidityPackedKeccak256(["string"], [secretKey]);
    };

    // To match: keccak256(abi.encodePacked(_secretKey, playerAddress))
    export const createCommitment = (secretKey, playerAddress) => {
        return ethers.solidityPackedKeccak256(
                ["string", "address"], 
                        [secretKey, playerAddress]
                            );
                            };