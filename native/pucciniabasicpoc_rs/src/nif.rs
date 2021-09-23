use crate::logic;

#[rustler::nif]
fn say_hello(name: String) -> String {
    logic::say_hello(name)
}

rustler::init!("Elixir.PucciniaBasicPoc.Nif", [say_hello]);
