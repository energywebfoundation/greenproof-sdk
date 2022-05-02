/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  Certificate,
  CertificateInterface,
} from "../../../contracts/Certificate.sol/Certificate";

const _abi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    name: "matches",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "matchInput",
        type: "string",
      },
      {
        internalType: "string",
        name: "matchResult",
        type: "string",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b50610596806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806332ac752b1461003b5780638aa0fdad1461006b575b600080fd5b6100556004803603810190610050919061027f565b610087565b60405161006291906103ad565b60405180910390f35b610085600480360381019061008091906102c0565b61013d565b005b60008180516020810182018051848252602083016020850120818352809550505050505060009150905080546100bc9061048e565b80601f01602080910402602001604051908101604052809291908181526020018280546100e89061048e565b80156101355780601f1061010a57610100808354040283529160200191610135565b820191906000526020600020905b81548152906001019060200180831161011857829003601f168201915b505050505081565b8060008360405161014e9190610396565b9081526020016040518091039020908051906020019061016f929190610174565b505050565b8280546101809061048e565b90600052602060002090601f0160209004810192826101a257600085556101e9565b82601f106101bb57805160ff19168380011785556101e9565b828001600101855582156101e9579182015b828111156101e85782518255916020019190600101906101cd565b5b5090506101f691906101fa565b5090565b5b808211156102135760008160009055506001016101fb565b5090565b600061022a610225846103f4565b6103cf565b90508281526020810184848401111561024257600080fd5b61024d84828561044c565b509392505050565b600082601f83011261026657600080fd5b8135610276848260208601610217565b91505092915050565b60006020828403121561029157600080fd5b600082013567ffffffffffffffff8111156102ab57600080fd5b6102b784828501610255565b91505092915050565b600080604083850312156102d357600080fd5b600083013567ffffffffffffffff8111156102ed57600080fd5b6102f985828601610255565b925050602083013567ffffffffffffffff81111561031657600080fd5b61032285828601610255565b9150509250929050565b600061033782610425565b6103418185610430565b935061035181856020860161045b565b61035a8161054f565b840191505092915050565b600061037082610425565b61037a8185610441565b935061038a81856020860161045b565b80840191505092915050565b60006103a28284610365565b915081905092915050565b600060208201905081810360008301526103c7818461032c565b905092915050565b60006103d96103ea565b90506103e582826104c0565b919050565b6000604051905090565b600067ffffffffffffffff82111561040f5761040e610520565b5b6104188261054f565b9050602081019050919050565b600081519050919050565b600082825260208201905092915050565b600081905092915050565b82818337600083830152505050565b60005b8381101561047957808201518184015260208101905061045e565b83811115610488576000848401525b50505050565b600060028204905060018216806104a657607f821691505b602082108114156104ba576104b96104f1565b5b50919050565b6104c98261054f565b810181811067ffffffffffffffff821117156104e8576104e7610520565b5b80604052505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f830116905091905056fea26469706673582212201e52f057b157d67f49c2d168536ce1f5e2539e797f53500f87c2319de639eb3364736f6c63430008040033";

type CertificateConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: CertificateConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Certificate__factory extends ContractFactory {
  constructor(...args: CertificateConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<Certificate> {
    return super.deploy(overrides || {}) as Promise<Certificate>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): Certificate {
    return super.attach(address) as Certificate;
  }
  override connect(signer: Signer): Certificate__factory {
    return super.connect(signer) as Certificate__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): CertificateInterface {
    return new utils.Interface(_abi) as CertificateInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Certificate {
    return new Contract(address, _abi, signerOrProvider) as Certificate;
  }
}
