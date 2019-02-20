defmodule BetaBabiesWeb.PageController do
  use BetaBabiesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def secret(conn, _) do
    account = Guardian.Plug.current_resource(conn)
    render(conn, "secret.html", current_account: account)
  end
end
