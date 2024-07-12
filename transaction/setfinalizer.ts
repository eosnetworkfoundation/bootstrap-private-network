import {
  Action,
  APIClient,
  PackedTransaction,
  PrivateKey,
  SignedTransaction,
  Transaction
} from "@wharfkit/antelope"
import fetch from 'node-fetch';
import { promises as fs } from 'fs';

// process arguments file, key
// example: node transfer.js /bigata1/savanna/setfinalizer.json 5KByz.......
var args = process.argv.slice(2);
const setfinalizerfile = args[0]
const privatekey = args[1]

// only works on local host
globalThis.fetch = fetch
const client = new APIClient({ url: "http://127.0.0.1:8888" })

//console.log("putting together setfinalizer action")
pushSetFinalizer()
//console.log("finished pushing setfinalizer action to chain")

function sleep(ms) {
return new Promise(resolve => setTimeout(resolve, ms));
}

async function pushSetFinalizer() {
  try {

    const info = await client.v1.chain.get_info()
    const header = info.getTransactionHeader()

    const schemaquery = await client.v1.chain.get_abi('eosio')
    //for (const struct of schemaquery.abi.structs) {
    //  if (struct.name == "finalizer_policy" ||
    //      struct.name == "finalizer_authority" ||
    //      struct.name == "finalizers"
    //  ) {
    //    console.log(struct.name+' ABI:'+JSON.stringify(struct))
    //  }
    //}


    /*
     *** SETFINALIZER EXAMPLE STRUCTURE
     {
      "finalizer_policy": {
        "threshold": 3,
        "finalizers": [
          {
            "description": "blockproducerA",
            "weight": 1,
            "public_key": "PUB_BLS_hidden...",
            "pop": "SIG_BLS_hidden..."
          },
          {
            "description": "blockproducerD",
            "weight": 1,
            "public_key": "PUB_BLS_hidden...",
            "pop": "SIG_BLS_hidden..."
          },
          {
            "description": "blockproducerC",
            "weight": 1,
            "public_key": "PUB_BLS_hidden...",
            "pop": "SIG_BLS_hidden..."
          },
          {
            "description": "blockproducerD",
            "weight": 1,
            "public_key": "PUB_BLS_hidden...",
            "pop": "SIG_BLS_hidden..."
          }
        ]
      }
    }
    */

    var untypedAction = ""

    const setfinalizerjson = await fs.readFile(setfinalizerfile, 'utf-8')

    untypedAction = {
      authorization: [
        { actor: "eosio", permission: "active" },
      ],
      account: "eosio",
      name: "setfinalizer",
      data: JSON.parse(setfinalizerjson)
    }

    // build action and transaction
    const action = Action.from(untypedAction, schemaquery.abi)
    const trx = Transaction.from({
      ...header,
      actions: [action],
      transaction_extensions: [],
    })

    // sign transaction
    const privateKey = PrivateKey.from(privatekey)
    const signatureBPA = privateKey.signDigest(trx.signingDigest(info.chain_id))
    const signedTransaction = SignedTransaction.from({
      ...trx,
      signatures: [signatureBPA],
    })

    // pack the transaction
    const packedTransaction = PackedTransaction.fromSigned(signedTransaction)

    // sleep to create some time
    await sleep(700);

    const result = await client.v1.chain.push_transaction(packedTransaction)
    // log the transaction id and block number
    console.log("trx id:"+result.processed.id)
    console.log("block num:"+result.processed.block_num)

  } catch (err) {
      console.log("Error is " + err);
  }
};
