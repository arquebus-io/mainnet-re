open Promise

type queryT = {address: option<string>, tokenId: option<string>}
type bodyT = {balance: Mainnet.Types.satoshi}

let default = (request: Vercel.request<queryT, _>, response: Vercel.response<bodyT>) => {
  switch (request.query.address, request.query.tokenId) {
  | (None, _) => Vercel.sendError(response, 400, "No address provided")
  | (Some(address), None) =>
    Mainnet.testNetWallet
    ->Mainnet.watchOnly(address->Mainnet.Types.Address)
    ->then(wallet => wallet->Mainnet.CashTokens.getAllTokenBalanceFromRO())
    ->then(balance => {
      response->Vercel.status(200)->Vercel.send(Ok({balance: balance}))->resolve
    })
  | (Some(address), Some(tokenId)) =>
    Mainnet.testNetWallet
    ->Mainnet.watchOnly(address->Mainnet.Types.Address)
    ->then(wallet =>
      wallet->Mainnet.CashTokens.getTokenBalanceFromRO(tokenId->Mainnet.Types.TokenId)
    )
    ->then(balance => {
      response->Vercel.status(200)->Vercel.send(Ok({balance: balance}))->resolve
    })
    ->catch(Vercel.handleGatewayError(request, response))
  }
}
