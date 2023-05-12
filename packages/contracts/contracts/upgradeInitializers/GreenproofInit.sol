// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {ERC165Storage} from "@solidstate/contracts/introspection/ERC165.sol";
import {IVoting} from "../interfaces/IVoting.sol";
import {LibIssuer} from "../libraries/LibIssuer.sol";
import {MetaToken} from "../dependencies/MetaToken.sol";
import {IGreenProof} from "../interfaces/IGreenProof.sol";
import {LibMetaToken} from "../libraries/LibMetaToken.sol";
import {IProofManager} from "../interfaces/IProofManager.sol";
import {IClaimManager} from "../interfaces/IClaimManager.sol";

/**
 * @title GreenproofInit - Initialization contract
 * @author EnergyWeb Foundation
 * @notice This contract is the initialization contract for the Greenproof smart contract.
 * @dev The contract sets the supported interfaces for the Greenproof contract and allows for the initialization of state variables.
 * @dev It is expected that this contract is customized if you want to deploy your greenProof diamond with data from a deployment script.
 * @dev Use the init function to initialize state variables of your proxy.
 * @dev Add parameters to the init funciton if you need to.
 */
contract GreenproofInit {
    /**
     * @dev Using the ERC165Storage library for the ERC165Storage.Layout struct
     */
    using ERC165Storage for ERC165Storage.Layout;

    struct TokenInfos {
        string name;
        string symbol;
    }

    /**
     * @notice Initialization function for setting the supported interfaces and initializing state variables.
     * @dev This function is called during contract deployment or upgrades to accordingly setinterfaces
     * @dev You can add parameters to this function in order to pass in data to set your own state variables.
     */
    function init(
        address proxy,
        TokenInfos memory certificateInfos,
        TokenInfos memory metaCertificateInfos
    ) external {
        /**
         * @dev Setting the supported interfaces for the Greenproof contract.
         */
        ERC165Storage.Layout storage erc165 = ERC165Storage.layout();
        erc165.setSupportedInterface(type(IClaimManager).interfaceId, true);
        erc165.setSupportedInterface(type(IGreenProof).interfaceId, true);
        erc165.setSupportedInterface(type(IProofManager).interfaceId, true);
        erc165.setSupportedInterface(type(IVoting).interfaceId, true);

        // add your own state variables
        LibIssuer.getStorage().name = certificateInfos.name;
        LibIssuer.getStorage().symbol = certificateInfos.symbol;
        // Deployment of an autonomous contract - the meta token
        // In order to allow meta-certificate issuance only from the GreenProof system, the main proxy contract is set as the admin of the meta token
        MetaToken metaToken = new MetaToken(proxy, metaCertificateInfos.name, metaCertificateInfos.symbol);
        LibMetaToken.getStorage().metaTokenAddress = address(metaToken);
        // EIP-2535 specifies that the `diamondCut` function takes two optional
        // arguments: address _init and bytes calldata _calldata
        // These arguments are used to execute an arbitrary function using delegatecall
        // in order to set state variables in the diamond during deployment or an upgrade
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface
    }
}
