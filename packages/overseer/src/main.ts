import { join } from 'path';
import { config } from 'dotenv';
import { start } from '.';
config({ path: join(__dirname, '..', '.env') });

const port = process.env.PORT || 3000;
const blockchainConfig = {
  rpcHost: process.env.RPC_HOST!,
  contractAddress: process.env.CONTRACT_ADDRESS!,
  overseerPrivateKey: process.env.OVERSEER_PRIVATE_KEY!,
};

start({
  blockchainConfig,
  listeners: {},
  getLastHandledBlockNumber: () => { return 0; },
}, Number(port));
