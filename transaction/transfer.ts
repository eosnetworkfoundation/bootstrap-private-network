import {
  Action,
  APIClient,
  PackedTransaction,
  PrivateKey,
  SignedTransaction,
  Transaction
} from "@wharfkit/antelope"
import fetch from 'node-fetch';

// Just a test , simple transfer
// easier to test with to validate things work

// process arguments from, to, key
// example: node transfer.js bpa bpb 5KByz.......
var args = process.argv.slice(2);
const from = args[0]
const to = args[1]
const key = args[2]

// only works on local host
globalThis.fetch = fetch
const client = new APIClient({ url: "http://127.0.0.1:8888" })

console.log("building transfer action")
pushTransferAction()
console.log("finished building: ")

async function pushTransferAction() {
  try {

    const info = await client.v1.chain.get_info()
    const header = info.getTransactionHeader()

    const abi = {
      structs: [
        {
          base: "",
          name: "transfer",
          fields: [
            { name: "from", type: "name" },
            { name: "to", type: "name" },
            { name: "quantity", type: "asset" },
            { name: "memo", type: "string" },
          ],
        },
      ],
      actions: [
        { name: "transfer", type: "transfer", ricardian_contract: "" },
      ],
    }

    const untypedAction = {
      authorization: [
        { actor: "bpa", permission: "active" },
      ],
      account: "eosio.token",
      name: "transfer",
      data: {
        from: from,
        to: to,
        memo: "test trans",
        quantity: "1.0000 EOS",
      },
    }

    const action = Action.from(untypedAction, abi)

    const trx = Transaction.from({
      ...header,
      actions: [action],
      transaction_extensions: [],
    })

    const privateKey = PrivateKey.from(key)

    const signatureBPA = privateKey.signDigest(trx.signingDigest(info.chain_id))
    const signedTransaction = SignedTransaction.from({
      ...trx,
      signatures: [signatureBPA],
    })

    const packedTransaction = PackedTransaction.fromSigned(signedTransaction)
    const result = await client.v1.chain.push_transaction(packedTransaction)
    console.log("trx id:"+result.processed.id)
    console.log("block num:"+result.processed.block_num)

  } catch (err) {
      console.log("Error is " + err);
  }
};
