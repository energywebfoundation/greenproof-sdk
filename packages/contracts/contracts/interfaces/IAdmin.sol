//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

interface IAdmin {
    /**********************************************************\
                      Events and Structs                         
    \**********************************************************/

    /**
     * @notice IssuerVersionUpdated - logs issuer role version updates
     * @param oldVersion - The value of the previous issuer role credential
     * @param newVersion - The value of the updated issuer role credential
     * @dev Event emitted when the version of the issuer role is updated
     */
    event IssuerVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);

    /**
     * @notice WorkerVersionUpdated - logs worker role version updates
     * @param oldVersion - The value of the previous worker role credential
     * @param newVersion - The value of the updated worker role credential
     * @dev Event emitted when the version of the worker role is updated
     */
    event WorkerVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);

    /**
     * @notice RevokerVersionUpdated - logs Revoker role version updates
     * @param oldVersion - The value of the previous revoker role credential
     * @param newVersion - The value of the updated revoker role credential
     * @dev Event emitted when the version of the revoker role is updated
     */
    event RevokerVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);

    /**
     * @notice ClaimerVersionUpdated - logs claimer role version updates
     * @param oldVersion - The value of the previous claimer role credential
     * @param newVersion - The value of the updated claimer role credential
     * @dev Event emitted when the version of the claimer role is updated
     */
    event ClaimerVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);

    /**
     * @notice ApproverVersionUpdated - logs Approver role version updates
     * @param oldVersion - The value of the previous approver role credential
     * @param newVersion - The value of the updated approver role credential
     * @dev Event emitted when the version of the approver role is updated
     */
    event ApproverVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);

    /**
     * @notice ClaimManagerUpdated - logs claim manager contract's address updates
     * @param oldAddress - The previous value of the claim manager contract address
     * @param newAddress - The updated value of the claim manager contract address
     * @dev Event emitted when the address of the claim manager contract is updated
     */
    event ClaimManagerUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @notice ClaimsRevocationRegistryUpdated - logs claim revocation registry's address updates
     * @param oldAddress - The previous value of the claim revocation registry address
     * @param newAddress - The updated value of claim revocation registry address
     * @dev Event emitted when the claim revocation registry address is updated
     */
    event ClaimsRevocationRegistryUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @notice ContractPaused - emitted when the contract gets paused
     * @param timestamp unix date and time recording when the contract was paused
     * @param operator - address of the operator who paused the contract
     */
    event ContractPaused(uint256 timestamp, address operator);

    /**
     * @notice ContractUnPaused - emitted when the contract gets paused
     * @param timestamp unix date and time recording when the contract was unpaused
     * @param operator - address of the operator who unpaused the contract
     */
    event ContractUnPaused(uint256 timestamp, address operator);

    /**
     * @notice AdminFunctionDeclared - emitted when a function is declared as an admin function
     * @param functionSignature - the signature of the function that is declared as an admin function
     * @param timestamp unix date and time recording when the function was declared as an admin function
     */
    event AdminFunctionDeclared(bytes4 indexed functionSignature, uint256 indexed timestamp);

    /**
     * @notice AdminFunctionsDeclared - emitted when multiple functions are declared as admin functions
     * @param functionSignatures - the signatures of the functions that are declared as admin functions
     * @param timestamp unix date and time recording when the functions were declared as admin functions
     */
    event AdminFunctionsDeclared(bytes4[] indexed functionSignatures, uint256 indexed timestamp);

    /**
     * @notice AdminFunctionDiscarded - emitted when a function is discarded as an admin function
     * @param functionSignature - the signature of the function that is discarded as an admin function
     * @param timestamp unix date and time recording when the function was discarded as an admin function
     */
    event AdminFunctionDiscarded(bytes4 indexed functionSignature, uint256 indexed timestamp);

    /**
     * @notice AdminFunctionsDiscarded - emitted when multiple functions are discarded as admin functions
     * @param functionSignatures - the signatures of the functions that are discarded as admin functions
     * @param timestamp unix date and time recording when the functions were discarded as admin functions
     */
    event AdminFunctionsDiscarded(bytes4[] indexed functionSignatures, uint256 indexed timestamp);

    /**********************************************************\
                        Custom Errors                              
    \**********************************************************/

    /**
     * @dev Error: Thrown when contract owner is trying to pause an already paused contract
     */
    error AlreadyPausedContract();

    /**
     * @dev Error: Thrown when contract owner is trying to unpause an already unpaused contract
     */
    error AlreadyUnpausedContract();

    /**********************************************************\
                      Updating Functions                    
    \**********************************************************/

    /**
     * @notice updateClaimManager
     * @param newAddress The new address of the claim manager
     * @dev Allows only the contract owner to update the claim manager address.
     * @dev This restriction is set on the internal `setClaimManagerAddress` function
     */
    function updateClaimManager(address newAddress) external;

    /**
     * @notice updateClaimRevocationRegistry
     * @param newAddress The new address of the claim revocation registry
     * @dev Allows only the contract owner to update the claim revocation registry address
     * @dev This restriction is set on the internal `setClaimRevocationRegistry` function
     */
    function updateClaimRevocationRegistry(address newAddress) external;

    /**
     * @notice updateIssuerVersion
     * @param newVersion The new version of the issuer role
     * @dev Allows only the contract owner to update the issuer version
     * @dev This restriction is set on the internal `setIssuerVersion` function
     */
    function updateIssuerVersion(uint256 newVersion) external;

    /**
     * @notice updateRevokerVersion
     * @param newVersion The new version of the revoker role
     * @dev Allows only the contract owner to update the revoker version
     * @dev This restriction is set on the internal `setRevokerVersion` function
     */
    function updateRevokerVersion(uint256 newVersion) external;

    /**
     * @notice updateWorkerVersion
     * @param newVersion The new version of the worker role
     * @dev Allows only the contract owner to update the worker version
     * @dev This restriction is set on the internal `setWorkerVersion` function
     */
    function updateWorkerVersion(uint256 newVersion) external;

    /**
     * @notice updateClaimerVersion
     * @param newVersion The new version of the claimer role
     * @dev Allows only the contract owner to update the claimer version
     * @dev This restriction is set on the internal `setClaimerVersion` function
     */
    function updateClaimerVersion(uint256 newVersion) external;

    /**
     * @notice updateApproverVersion
     * @param newVersion The new version of the claimer role
     * @dev Allows only the contract owner to update the claimer version
     * @dev This restriction is set on the internal `setApproverVersion` function
     */
    function updateApproverVersion(uint256 newVersion) external;

    /**********************************************************\
                      Circuit Breaker Functions                    
    \**********************************************************/

    /**
     * @notice pause - when called, this function prevents all calls of facet functions from being executed
     * @dev only the contract admistrator is allowed to execute this halting function
     * @dev if the system is already paused, a call to this function will revert with `AlreadyPausedContract` error
     */
    function pause() external;

    /**
     * @notice unPause - when called, this function reverts the pausing and unlocks facet function executions
     * @dev only the contract admistrator is allowed to execute this unlocking function
     * @dev if the system is already unpaused, a call to this function will revert with `AlreadyUnpausedContract` error
     */
    function unPause() external;

    /**
     * @notice isContractPaused - returns the current state of the contract
     * @dev if the system is paused, this function will return `true`
     * @dev if the system is unpaused, this function will return `false`
     */
    function isContractPaused() external view returns (bool);

    /**********************************************************\
                      Admin Functions Tracking
    \**********************************************************/

    /**
     * @notice declareSingleAdminFunction - when called, this function allows the contract owner to declare one single function is an admin functions
     * @dev only the contract owner is allowed to execute this function
     */
    function declareSingleAdminFunction(bytes4 functionSelector) external;

    /**
     * @notice declareBatchAdminFunctions - when called, this function allows the contract owner to declare which functions are admin functions
     * @dev only the contract owner is allowed to execute this function
     */
    function declareBatchAdminFunctions(bytes4[] calldata functionSelectors) external;

    /**
     * @notice removeSingleAdminFunction - when called, this function allows the contract owner to remove one single function from the admin functions list
     * @dev only the contract owner is allowed to execute this function
     */
    function removeSingleAdminFunction(bytes4 functionSelector) external;

    /**
     * @notice BatchAdminFunctions - when called, this function allows the contract owner to remove multiple admin functions
     * @dev only the contract owner is allowed to execute this function
     */
    function removeBatchAdminFunctions(bytes4[] calldata functionSelectors) external;
}
