defmodule PucciniaBasicPocWeb.PageController do
  use PucciniaBasicPocWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
