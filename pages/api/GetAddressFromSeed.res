open Promise

type requestT = {seed: option<string>}
type responseT = {address: Mainnet.Types.address}

let default = (request: Vercel.request<requestT, _>, response: Vercel.response<responseT>) => {
  switch request.query.seed {
  | None => Vercel.sendError(response, 400, "Invalid seed")
  | Some(seed) =>
    Mainnet.testNetWallet
    ->Mainnet.fromSeed(seed->Mainnet.Types.Mnemonic)
    ->then(wallet => {
      response->Vercel.status(200)->Vercel.send(Ok({address: wallet.address}))->resolve
    })
    ->catch(Vercel.handleGatewayError(request, response))
  }
}
