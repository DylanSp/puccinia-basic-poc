#[rustler::nif]
fn say_hello(name: String) -> String {
    format!("Hello, {}!", name)
}

rustler::init!("Elixir.PucciniaBasicPoc.Nif", [say_hello]);
