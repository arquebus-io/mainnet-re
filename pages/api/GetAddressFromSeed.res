open Promise

type request = {seed: option<string>}
type response = {price: string}

let default = (request: Vercel.request<request, _>, response: Vercel.response) => {
  switch request.query.seed {
  | None => Vercel.sendError(response, 400, "Invalid seed")
  | Some(seed) =>
    Mainnet.testNetWallet
    ->Mainnet.fromSeed(seed->Mainnet.Types.Mnemonic)
    ->then(wallet => {
      response->Vercel.status(200)->Vercel.send(Ok(wallet.address))->resolve
    })
    ->catch(Vercel.handleGatewayError(request, response))
  }
}
