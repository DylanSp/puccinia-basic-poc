defmodule PucciniaBasicPocWeb.PageView do
  use PucciniaBasicPocWeb, :view

  import PucciniaBasicPoc.Nif

  def get_greeting_message() do
    say_hello("Dylan")
  end
end
