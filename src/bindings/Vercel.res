type apiConfig = {bodyParser: bool}
type config = {api: apiConfig}

type request<'queryT, 'bodyT> = {
  body: 'bodyT,
  query: 'queryT,
  cookies: Js.Dict.t<string>,
}

type data
type response = {
  status: int,
  statusText: string,
  data: data,
}

@send external status: (response, int) => response = "status"
@send external send: (response, 't) => response = "send"

@get external getResponse: Js.Exn.t => option<response> = "response"

let sendError = (response, statusCode, statusText) =>
  response->status(statusCode)->send(Error(statusText))->Promise.resolve

let handleGatewayError = (_request: request<'queryT, 'bodyT>, response: response, e) => {
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
