use crate::logic;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn say_hello(name: String) -> String {
  logic::say_hello(name)
}