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

// process arguments private key
var args = process.argv.slice(2);
const privatekey = args[0]
// feature digest for SAVANNA
const savanna_digest = "cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"

// only works on local host
globalThis.fetch = fetch
const client = new APIClient({ url: "http://127.0.0.1:8888" })

//console.log("putting together multisig protocol activation action")
pushMultiSigActivate()
//console.log("finished pushing multisig protocol activation action to chain")

function sleep(ms) {
return new Promise(resolve => setTimeout(resolve, ms));
}

async function pushMultiSigActivate() {
  try {

    const info = await client.v1.chain.get_info()
    const header = info.getTransactionHeader()

    const schemaquery = await client.v1.chain.get_abi('eosio')

    const activateSavannaProtocol = {
      "account": "eosio",
      "name": "activate",
      "authorization": [{
          "actor": "eosio",
          "permission": "active"
      }],
      data: {
        "feature_digest": "cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"
      }
    }

    // build action
    const serializedProtocolActivationAction = Action.from(activateSavannaProtocol, schemaquery.abi)

    const proposedInput = {
      "proposer": "bpa",
      "proposal_name": "testfeatureb",
      "requested": [
        {"actor": "bpa","permission": "active"},
        {"actor": "bpb","permission": "active"},
        {"actor": "bpc","permission": "active"}
      ],
      "actions": [serializedProtocolActivationAction]
    }

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

    const result = await client.v1.chain.push_transaction(packedTransaction)
    // log the transaction id and block number
    console.log("trx id:"+result.processed.id)
    console.log("block num:"+result.processed.block_num)

  } catch (err) {
      console.log("Error is " + err);
  }
};
