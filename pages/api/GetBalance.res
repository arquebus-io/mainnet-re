open Promise

type queryT = {address: option<string>}
type bodyT = {balance: Mainnet.Types.satoshi}

let default = (request: Vercel.request<queryT, _>, response: Vercel.response<bodyT>) => {
  switch request.query.address {
  | None => Vercel.sendError(response, 400, "No Address provided")
  | Some(address) =>
    Mainnet.testNetWallet
    ->Mainnet.watchOnly(address->Mainnet.Types.Address)
    ->then(wallet => wallet->Mainnet.getBalanceFromReadOnly())
    ->then(balance => {
      response->Vercel.status(200)->Vercel.send(Ok({balance: balance}))->resolve
    })
    ->catch(Vercel.handleGatewayError(request, response))
  }
}
