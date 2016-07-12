import 'whatwg-fetch';

const namespace = '/api'

const urlFor = (path) => {
  return `${namespace}${path}`;
}

const get = (path) => {
  const url = urlFor(path);
  return fetch(url)
    .then((response) => { return response.json() })
    .then((json) => { return json.data });
}

const post = (path, params) => {
  const url = urlFor(path);
  return fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(params)
  })
  .then((response) => { return response.json() })
  .then((json) => { return json.data });
}

export { get, post }
