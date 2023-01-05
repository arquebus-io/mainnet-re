open Promise

type queryT = {
  mnemonic: option<string>,
  recipient: option<string>,
  amount: option<string>,
  commitment: option<string>,
  value: option<string>,
}
type bodyT = Mainnet.CashTokens.tokenGenesisInfo

let default = (request: Vercel.request<queryT, _>, response: Vercel.response<bodyT>) => {
  open Mainnet.Types
  let {mnemonic, recipient, amount, commitment, value} = request.query
  switch (
    mnemonic,
    amount->Belt.Option.flatMap(Belt.Int.fromString),
    value->Belt.Option.flatMap(Belt.Int.fromString),
  ) {
  | (Some(mnemonic), Some(amount), Some(value)) => {
      let opts: Mainnet.CashTokens.opts = {
        cashaddr: recipient->Belt.Option.map(x => Cashaddr(x)),
        amount: amount->Satoshi,
        commitment: commitment->Belt.Option.map(x => CommitmentMsg(x)),
        capability: Mainnet.CashTokens.nftCapability.none,
        value: value->Satoshi,
      }
      Mainnet.testNetWallet
      ->Mainnet.fromSeed(mnemonic->Mnemonic)
      ->then(wallet => wallet->Mainnet.CashTokens.tokenGenesis(opts))
      ->then(tokenGenesisInfo => {
        response->Vercel.status(200)->Vercel.send(Ok(tokenGenesisInfo))->resolve
      })
      ->catch(Vercel.handleGatewayError(request, response))
    }
  | (_, _, _) => Vercel.sendError(response, 400, "Insufficient parameters provider")
  }
}
