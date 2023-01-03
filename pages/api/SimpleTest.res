open Promise

type response = {price: string}

let default = (request: Vercel.request<_, _>, response: Vercel.response) => {
  Mainnet.testNetWallet
  ->Mainnet.newRandom()
  ->then(wallet => {
    response->Vercel.status(200)->Vercel.send(Ok(wallet.mnemonic))->resolve
  })
  ->catch(Vercel.handleGatewayError(request, response))
}
