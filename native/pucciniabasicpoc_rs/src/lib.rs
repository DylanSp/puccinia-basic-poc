mod logic;

#[cfg(not(target_family = "wasm"))]
mod nif;

#[cfg(target_family = "wasm")]
mod wasm;
