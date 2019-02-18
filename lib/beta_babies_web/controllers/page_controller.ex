defmodule BetaBabiesWeb.PageController do
  use BetaBabiesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
