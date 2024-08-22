## Steps to Create Multi Sigs for Jungle Switch

### summary
need to accomplish two things
1) Apply new Savanna protocol feature
2) update system contracts

### Protocol Features
 Without an MSIG it is simply
 ```
 # Depends on all other protocol features
 cleos --url $ENDPOINT push action eosio activate '["cbe0fafc8fcc6cc998395e9b6de6ebd94644467b1b4a97ec126005df07013c52"]' -p eosio
 ```

### Update System Contracts
We need to set both code and abi on chain.
1) Download and Build CDT v4.1.0-rc2
    - Follow the notes here https://github.com/AntelopeIO/cdt/tree/release/4.1
    - Install the CDT binaries
2) Dowload and Build EOS System Contract v3.6.0-rc1
    - Follow the notes here https://github.com/eosnetworkfoundation/eos-system-contracts/tree/release/3.6
    - Expected SHA256SUM
       - `04a9f28eb30bcc81432823266dac98272d4996fa7b41ef112191c2a8609ac262`  eosio.system.abi
       - `e6b292aff2b4387a509dbe67b9abdda1867c8c4146bb93d2f5695108e1fda110`  eosio.system.wasm
       - `d525e21c69f8439e27e5fa6f020a1a9fbdd1d36baa3a4c839d6d6ea4a1b2cdfc`  eosio.system.wasm
       - `0a34e6f8b6d6809a90144dc87ea9c05a8fb23ed5c2198a3882670cae3aff69a4`  eosio.system.wasm
3) Apply contract settting code and abi
```
cleos --url $ENDPOINT set contract eosio "$CONTRACT_DIR"/eosio.system
```
