//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {OwnableStorage} from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import {IClaimManager} from "../interfaces/IClaimManager.sol";

library LibClaimManager {
    struct Role {
        bytes32 name;
        uint256 version;
    }

    struct ClaimManagerStorage {
        address claimManagerAddress;
        address claimsRevocationRegistry;
        Role workerRole;
        Role issuerRole;
        Role revokerRole;
        Role claimerRole;
    }

    bytes32 private constant CLAIM_MANAGER_STORAGE_POSITION = keccak256("ewc.greenproof.claimManager.diamond.storage");

    modifier onlyOwner() {
        require(OwnableStorage.layout().owner == msg.sender, "Greenproof: ClaimManager facet: Must be contract owner");
        _;
    }

    function init(
        address claimManagerAddress,
        bytes32 issuerRole,
        bytes32 revokerRole,
        bytes32 workerRole,
        bytes32 claimerRole,
        address claimsRevocationRegistry
    ) internal {
        ClaimManagerStorage storage claimStore = getStorage();

        claimStore.claimManagerAddress = claimManagerAddress;
        claimStore.claimsRevocationRegistry = claimsRevocationRegistry;
        claimStore.issuerRole = Role({name: issuerRole, version: 1});
        claimStore.revokerRole = Role({name: revokerRole, version: 1});
        claimStore.workerRole = Role({name: workerRole, version: 1});
        claimStore.claimerRole = Role({name: claimerRole, version: 1});
    }

    function setIssuerVersion(uint256 _newVersion) internal onlyOwner returns (uint256 oldRoleVersion) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(claimStore.issuerRole.version != _newVersion, "Same version");
        oldRoleVersion = claimStore.issuerRole.version;

        claimStore.issuerRole.version = _newVersion;
    }

    function setWorkerVersion(uint256 _newVersion) internal onlyOwner returns (uint256 oldRoleVersion) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(claimStore.workerRole.version != _newVersion, "Same version");
        oldRoleVersion = claimStore.workerRole.version;

        claimStore.workerRole.version = _newVersion;
    }

    function setRevokerVersion(uint256 _newVersion) internal onlyOwner returns (uint256 oldRoleVersion) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(claimStore.revokerRole.version != _newVersion, "Same version");
        oldRoleVersion = claimStore.revokerRole.version;

        claimStore.revokerRole.version = _newVersion;
    }

    function setClaimerVersion(uint256 _newVersion) internal onlyOwner returns (uint256 oldRoleVersion) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(claimStore.claimerRole.version != _newVersion, "Same version");
        oldRoleVersion = claimStore.claimerRole.version;

        claimStore.claimerRole.version = _newVersion;
    }

    function setClaimManagerAddress(address _newAddress) internal onlyOwner returns (address oldAddress) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(_newAddress != address(0), "Cannot update to null address");
        require(claimStore.claimManagerAddress != _newAddress, "Same address");

        oldAddress = claimStore.claimManagerAddress;

        claimStore.claimManagerAddress = _newAddress;
    }

    function setClaimRevocationRegistry(address newAddress) internal onlyOwner returns (address oldAddress) {
        ClaimManagerStorage storage claimStore = getStorage();

        require(newAddress != address(0), "Revocation Registry: null address");
        require(claimStore.claimsRevocationRegistry != newAddress, "Revocation Registry: Same address");

        oldAddress = claimStore.claimsRevocationRegistry;
        claimStore.claimsRevocationRegistry = newAddress;
    }

    function isEnrolledIssuer(address operator) internal view returns (bool) {
        ClaimManagerStorage storage claimStore = getStorage();

        return hasRole(operator, claimStore.issuerRole.name, claimStore.issuerRole.version);
    }

    function isEnrolledRevoker(address operator) internal view returns (bool) {
        ClaimManagerStorage storage claimStore = getStorage();

        return hasRole(operator, claimStore.revokerRole.name, claimStore.revokerRole.version);
    }

    function isEnrolledClaimer(address operator) internal view returns (bool) {
        ClaimManagerStorage storage claimStore = getStorage();

        return hasRole(operator, claimStore.claimerRole.name, claimStore.claimerRole.version);
    }

    function isEnrolledWorker(address operator) internal view returns (bool) {
        ClaimManagerStorage storage claimStore = getStorage();

        return hasRole(operator, claimStore.workerRole.name, claimStore.workerRole.version);
    }

    function hasRole(address _subject, bytes32 _role, uint256 _version) internal view returns (bool) {
        ClaimManagerStorage storage claimStore = getStorage();

        // ExtCall : Contract deployed and managed by EnergyWeb Foundation
        bool isSubjectEnrolled = IClaimManager(claimStore.claimManagerAddress).hasRole(_subject, _role, _version);
        bool isRoleRevoked = IClaimManager(claimStore.claimsRevocationRegistry).isRevoked(_role, _subject);

        return (isSubjectEnrolled && !isRoleRevoked);
    }

    function getStorage() internal pure returns (ClaimManagerStorage storage ClaimStore) {
        bytes32 position = CLAIM_MANAGER_STORAGE_POSITION;
        assembly {
            ClaimStore.slot := position
        }
    }
}
