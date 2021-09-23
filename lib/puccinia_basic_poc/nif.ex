defmodule PucciniaBasicPoc.Nif do
  use Rustler, otp_app: :puccinia_basic_poc, crate: "pucciniabasicpoc_nif"

  # When your NIF is loaded, it will override this function.
  def say_hello(_name) do
    :erlang.nif_error(:nif_not_loaded)
  end
end
