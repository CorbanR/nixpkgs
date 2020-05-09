const Router = require('./router')

addEventListener('fetch', event => {
  event.passThroughOnException();
  event.respondWith(handleRequest(event.request))
})


async function proxyRequest(url, request) {
  // Only pass through a subset of request headers
  let init = {
    method: request.method,
    headers: {}
  };

  const proxyHeaders = ["Accept",
    "Accept-Encoding",
    "Accept-Language",
    "Referer",
    "User-Agent"];

  for (let name of proxyHeaders) {
    let value = request.headers.get(name);
    if (value) {
      init.headers[name] = value;
    }
  }

  const clientAddr = request.headers.get('cf-connecting-ip');

  if (clientAddr) {
    init.headers['X-Forwarded-For'] = clientAddr;
  }

  // Only include a strict subset of response headers
  const response = await fetch(url, init);

  if (response) {
    const responseHeaders = ["Content-Type",
      "Cache-Control",
      "Expires",
      "Accept-Ranges",
      "Date",
      "Last-Modified",
      "ETag"];
    let responseInit = {status: response.status,
      statusText: response.statusText,
      headers: {}};
    for (let name of responseHeaders) {
      let value = response.headers.get(name);
      if (value) {
        responseInit.headers[name] = value;
      }
    }

    const newResponse = new Response(response.body, responseInit);
    return newResponse;
  }

  return response;
}

// proxy requsts to https://media.githubusercontent.com, wich is where github serves gitlfs content.
// Example: https://media.githubusercontent.com/media/CorbanR/nixpkgs/gh-pages/cache/nar
async function handleRequest(request) {
  const url = new URL(request.url);
  const proxyUrl = 'https://media.githubusercontent.com/media/CorbanR/nixpkgs/gh-pages';

  const r = new Router()
  r.get('/cache/nar/.*', request => proxyRequest(proxyUrl + url.pathname + url.search, request))

  // Catch all to return the rest from origin
  // Although probably no necessary because route = "*nixpkgs.raunco.co/cache/*"
  r.get('.*', request => fetch(request))
  // Example custom response
  // r.get('.*', () => new Response('Hello! What in the world are you doing here?')) // return a default message for the root route

  const resp = await r.route(request)
  return resp
}
