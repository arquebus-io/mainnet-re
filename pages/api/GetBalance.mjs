// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Vercel from "../../src/bindings/Vercel.mjs";
import * as Mainnet from "../../src/bindings/Mainnet.mjs";
import * as $$Promise from "@ryyppy/rescript-promise/src/Promise.mjs";
import * as MainnetJs from "mainnet-js";

function $$default(request, response) {
  console.log(MainnetJs.DefaultProvider.servers);
  Mainnet.init(undefined);
  var address = request.query.address;
  if (address !== undefined) {
    return $$Promise.$$catch(MainnetJs.TestNetWallet.watchOnly(address).then(function (wallet) {
                      return wallet.getBalance();
                    }).then(function (balance) {
                    return Promise.resolve(response.status(200).send({
                                    TAG: /* Ok */0,
                                    _0: {
                                      balance: balance
                                    }
                                  }));
                  }), (function (param) {
                  return Vercel.handleGatewayError(request, response, param);
                }));
  } else {
    return Vercel.sendError(response, 400, "No Address provided");
  }
}

export {
  $$default ,
  $$default as default,
  
}
/* Mainnet Not a pure module */
