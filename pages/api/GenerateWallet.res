open Promise

type bodyT = {mnemonic: Mainnet.Types.mnemonic}

let default = (request: Vercel.request<_, _>, response: Vercel.response<'bodyT>) => {
  Mainnet.testNetWallet
  ->Mainnet.newRandom()
  ->then(wallet => {
    response->Vercel.status(200)->Vercel.send(Ok({mnemonic: wallet.mnemonic}))->resolve
  })
  ->catch(Vercel.handleGatewayError(request, response))
}
