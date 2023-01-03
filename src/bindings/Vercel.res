type apiConfig = {bodyParser: bool}
type config = {api: apiConfig}

type request<'queryT, 'bodyT> = {
  body: 'bodyT,
  query: 'queryT,
  cookies: Js.Dict.t<string>,
}

type data
type response<'bodyT> = {
  status: int,
  statusText: string,
  data: data,
  body: result<'bodyT, string>,
}

@send external status: (response<'bodyT>, int) => response<'bodyT> = "status"
@send external send: (response<'bodyT>, result<'bodyT, string>) => response<'bodyT> = "send"

@get external getResponse: Js.Exn.t => option<response<'body>> = "response"

let sendError = (response: response<'body>, statusCode: int, statusText: string) => {
  response->status(statusCode)->send(Error(statusText))->Promise.resolve
}

let handleGatewayError = (_request: request<'queryT, 'bodyT>, response: response<'body>, e) => {
  Js.log(e)
  open Promise
  let (statusCode, statusText) = switch e {
  | JsError(obj) =>
    switch obj->getResponse {
    | Some(response) => (response.status, `Gateway responded: ${response.statusText}`)
    | None => (502, "Gateway responded with an unparseable resonse")
    }
  | _ => (502, "Some unknown gateway error")
  }
  response->sendError(statusCode, statusText)
}
