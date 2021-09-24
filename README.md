# PucciniaBasicPoc

## Dependencies

Aside from Elixir, you'll need Rust, Node.js >= 16, and wasm-pack.

## Running

`mix phx.server` should work out of the box. WASM assets are built using the `assets/build.mjs` script, which calls `wasm-pack`, then copies the output into `assets/js/pkg`, where it can be imported from `assets/js/app.js`.
