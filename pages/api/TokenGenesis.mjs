// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Vercel from "../../src/bindings/Vercel.mjs";
import * as $$Promise from "@ryyppy/rescript-promise/src/Promise.mjs";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as MainnetJs from "mainnet-js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function $$default(request, response) {
  var match = request.query;
  var mnemonic = match.mnemonic;
  var match$1 = Belt_Option.flatMap(match.amount, Belt_Int.fromString);
  var match$2 = Belt_Option.flatMap(match.value, Belt_Int.fromString);
  if (mnemonic === undefined) {
    return Vercel.sendError(response, 400, "Insufficient parameters provider");
  }
  if (match$1 === undefined) {
    return Vercel.sendError(response, 400, "Insufficient parameters provider");
  }
  if (match$2 === undefined) {
    return Vercel.sendError(response, 400, "Insufficient parameters provider");
  }
  var opts_cashaddr = Belt_Option.map(match.recipient, (function (x) {
          return x;
        }));
  var opts_commitment = Belt_Option.map(match.commitment, (function (x) {
          return x;
        }));
  var opts_capability = MainnetJs.NFTCapability.none;
  var opts = {
    cashaddr: opts_cashaddr,
    amount: match$1,
    commitment: opts_commitment,
    capability: opts_capability,
    value: match$2
  };
  return $$Promise.$$catch(MainnetJs.TestNetWallet.fromSeed(mnemonic).then(function (wallet) {
                    return wallet.tokenGenesis(opts);
                  }).then(function (tokenGenesisInfo) {
                  return Promise.resolve(response.status(200).send({
                                  TAG: /* Ok */0,
                                  _0: tokenGenesisInfo
                                }));
                }), (function (param) {
                return Vercel.handleGatewayError(request, response, param);
              }));
}

export {
  $$default ,
  $$default as default,
  
}
/* mainnet-js Not a pure module */