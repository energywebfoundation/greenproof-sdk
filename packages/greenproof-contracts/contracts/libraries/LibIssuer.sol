//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {IVoting} from "../interfaces/IVoting.sol";
import {IGreenProof} from "../interfaces/IGreenProof.sol";

import {UintUtils} from "@solidstate/contracts/utils/UintUtils.sol";

import {ERC1155BaseInternal} from "@solidstate/contracts/token/ERC1155/base/ERC1155BaseInternal.sol";
import {ERC1155EnumerableInternal} from "@solidstate/contracts/token/ERC1155/enumerable/ERC1155EnumerableInternal.sol";

library LibIssuer {
    bytes32 constant ISSUER_STORAGE_POSITION = keccak256("ewc.greenproof.issuer.diamond.storage");
    bytes32 constant DEFAULT_VCREDENTIAL_VALUE = "";

    struct IssuerStorage {
        uint256 latestCertificateId;
        uint256 revocablePeriod;
        mapping(bytes32 => uint256) dataToCertificateID;
        mapping(uint256 => IGreenProof.Proof) mintedProofs;
        mapping(bytes32 => mapping(string => string)) disclosedData;
        //checks that data is disclosed for a specific key (string) of a precise certificate (bytes32)
        mapping(bytes32 => mapping(string => bool)) isDataDisclosed;
        mapping(bytes32 => mapping(bytes32 => uint256)) voteToCertificates;
    }

    event ProofMinted(uint256 indexed proofID, uint256 indexed volume, address indexed receiver);
    event IssuanceRequested(uint256 indexed proofID);
    event RequestRejected(uint256 indexed proofID);

    error NonExistingProof(uint256 proofId);
    error NonRevokableProof(uint256 proofID, uint256 issuanceDate, uint256 revocableDateLimit);
    error NotInConsensus(bytes32 voteID);
    error AlreadyCertifiedData(bytes32 dataHash);

    function init(uint256 revocablePeriod) internal {
        IssuerStorage storage issuer = _getStorage();
        require(issuer.revocablePeriod == 0, "revocable period: already set");
        issuer.revocablePeriod = revocablePeriod;
    }

    function _incrementProofIndex() internal {
        IssuerStorage storage issuer = _getStorage();
        issuer.latestCertificateId++;
    }

    function _registerProof(
        bytes32 dataHash,
        address generator,
        uint256 amount,
        uint256 proofID,
        bytes32 voteID
    ) internal {
        bool isRevoked = false;
        bool isRetired = false;

        LibIssuer.IssuerStorage storage issuer = _getStorage();

        issuer.mintedProofs[proofID] = IGreenProof.Proof(isRevoked, isRetired, proofID, block.timestamp, amount, dataHash, generator);
        issuer.dataToCertificateID[dataHash] = proofID;
        issuer.voteToCertificates[voteID][dataHash] = proofID;
    }

    function _isCertified(bytes32 _data) internal view returns (bool) {
        IssuerStorage storage issuer = _getStorage();

        return issuer.dataToCertificateID[_data] != 0;
    }

    function _getStorage() internal pure returns (IssuerStorage storage _issuerStorage) {
        bytes32 position = ISSUER_STORAGE_POSITION;

        assembly {
            _issuerStorage.slot := position
        }
    }

    function _getAmountHash(uint256 volume) internal pure returns (bytes32 volumeHash) {
        string memory volumeString = UintUtils.toString(volume);
        volumeHash = keccak256(abi.encodePacked("volume", volumeString));
    }
}
