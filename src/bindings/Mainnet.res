type t
module Types = {
  @unboxed type txId = TxId(string)
  @unboxed type tokenId = TokenId(string)
  @unboxed type satoshi = Satoshi(int)
  @unboxed type bitcoin = Bitcoin(int)
  @unboxed type usd = USD(int)
  @unboxed type derivationPath = DerivationPath(string)
  @unboxed type parentDerivationPath = ParentDerivationPath(string)
  type network = [#testnet]
  type walletType = [#seed | #watch]
  type networkPrefix = [#bchtest]
  @unboxed type mnemonic = Mnemonic(string)
  @unboxed type parentXPubKey = ParentXPubKey(string)
  @unboxed type privateKey = PrivateKey(Js.TypedArray2.Uint8Array.t)
  @unboxed type publicKey = PublicKey(Js.TypedArray2.Uint8Array.t)
  @unboxed type publicKeyHash = PublicKeyHash(Js.TypedArray2.Uint8Array.t)
  @unboxed type publicKeyCompressed = PublicKeyCompressed(Js.TypedArray2.Uint8Array.t)
  @unboxed type privateKeyWif = PrivateKeyWif(string)
  @unboxed type cashaddr = Cashaddr(string)
  @unboxed type tokenaddr = Tokenaddr(string)
  @unboxed type address = Address(string)
  @unboxed type subscriptions = Subscriptions(int)
  @unboxed type commitmentMsg = CommitmentMsg(string)
  type mutex
  @unboxed type blockHeight = BlockHeight(int)
  type electrumClient

  type electrumNetworkProvider = {
    network: network,
    manualConnectionManagement: bool,
    subscriptions: subscriptions,
    mutex: mutex,
    blockHeight: blockHeight,
    electrum: electrumClient,
    connectPromise: Promise.t<unit>,
  }

  type balanceObject = {
    bch: bitcoin,
    sat: satoshi,
    usd: usd,
  }

  type servers = {mutable testnet: array<string>}
  type defaultProvider = {servers: servers}
  type wallet = {
    derivationPath: derivationPath,
    parentDerivationPath: parentDerivationPath,
    name: string,
    network: network,
    walletType: walletType,
    provider: electrumNetworkProvider,
    isTestnet: bool,
    _slpAware: bool,
    _slpSemiAware: bool,
    networkPrefix: networkPrefix,
    mnemonic: mnemonic,
    parentXPubKey: parentXPubKey,
    privateKey: privateKey,
    publicKey: publicKey,
    publicKeyCompressed: publicKeyCompressed,
    privateKeyWif: privateKeyWif,
    cashaddr: cashaddr,
    tokenaddr: tokenaddr,
    address: address,
    publicKeyHash: publicKeyHash,
  }

  type readonlyWallet
}
open Types

@module("mainnet-js") external testNetWallet: t = "TestNetWallet"
@module("mainnet-js") external defaultProvider: defaultProvider = "DefaultProvider"
@send external newRandom: (t, unit) => Promise.t<wallet> = "newRandom"
@send external fromSeed: (t, mnemonic) => Promise.t<wallet> = "fromSeed"
@send
external fromSeedAndDerivationPath: (t, mnemonic, derivationPath) => Promise.t<wallet> = "fromSeed"
@send external fromWIF: (t, privateKeyWif) => Promise.t<wallet> = "fromWIF"
@send external watchOnly: (t, address) => Promise.t<readonlyWallet> = "watchOnly"
@send external getBalance: (wallet, unit) => Promise.t<Types.satoshi> = "getBalance"
@send
external getBalanceFromRO: (readonlyWallet, unit) => Promise.t<Types.satoshi> = "getBalance"

//Cashtokens
module CashTokens = {
  type nftCapabilityType
  type nftCapability = {
    none: nftCapabilityType,
    @as("mutable") mutable_: nftCapabilityType,
    minting: nftCapabilityType,
  }

  type opts = {
    cashaddr: option<Types.cashaddr>,
    amount: satoshi,
    commitment: option<commitmentMsg>,
    capability: nftCapabilityType,
    value: satoshi,
  }

  @module("mainnet-js") external nftCapability: nftCapability = "NFTCapability"

  type tokenBalance
  type tokenGenesisInfo = {
    txId: txId,
    balance: tokenBalance,
    explorerUrl: string,
    tokenIds: array<tokenId>,
  }
  @send external tokenGenesis: (wallet, opts) => Promise.t<tokenGenesisInfo> = "tokenGenesis"

  @send external getAllTokenBalance: (wallet, unit) => Promise.t<'a> = "getAllTokenBalances"
  @send
  external getAllTokenBalanceFromRO: (readonlyWallet, unit) => Promise.t<'a> = "getAllTokenBalances"
  @send external getTokenBalance: (wallet, tokenId) => Promise.t<'a> = "getTokenBalance"
  @send
  external getTokenBalanceFromRO: (readonlyWallet, tokenId) => Promise.t<'a> = "getTokenBalance"
}

// Setting CHIPNet parameters
let init = _ => {
  defaultProvider.servers.testnet = ["wss://chipnet.imaginary.cash:50004"]
}
init()
