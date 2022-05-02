/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { ethers } from "ethers";
import {
  FactoryOptions,
  HardhatEthersHelpers as HardhatEthersHelpersBase,
} from "@nomiclabs/hardhat-ethers/types";

import * as Contracts from ".";

declare module "hardhat/types/runtime" {
  interface HardhatEthersHelpers extends HardhatEthersHelpersBase {
    getContractFactory(
      name: "Ownable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Ownable__factory>;
    getContractFactory(
      name: "Certificate",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Certificate__factory>;
    getContractFactory(
      name: "ICertificate",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ICertificate__factory>;
    getContractFactory(
      name: "MatchVoting",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.MatchVoting__factory>;

    getContractAt(
      name: "Ownable",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.Ownable>;
    getContractAt(
      name: "Certificate",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.Certificate>;
    getContractAt(
      name: "ICertificate",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.ICertificate>;
    getContractAt(
      name: "MatchVoting",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.MatchVoting>;

    // default types
    getContractFactory(
      name: string,
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<ethers.ContractFactory>;
    getContractFactory(
      abi: any[],
      bytecode: ethers.utils.BytesLike,
      signer?: ethers.Signer
    ): Promise<ethers.ContractFactory>;
    getContractAt(
      nameOrAbi: string | any[],
      address: string,
      signer?: ethers.Signer
    ): Promise<ethers.Contract>;
  }
}
