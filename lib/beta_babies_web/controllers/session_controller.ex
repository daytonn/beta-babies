defmodule BetaBabiesWeb.SessionController do
  use BetaBabiesWeb, :controller
  alias BetaBabies.{Authentication, Authentication.Account, Authentication.Guardian}

  def new(conn, _) do
    changeset = Authentication.change_account(%Account{})
    maybe_account = Guardian.Plug.current_resource(conn)

    if maybe_account do
      redirect(conn, to: "/secret")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"account" => %{"username" => username, "password" => password}}) do
    Authentication.authenticate_account(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, account}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(account)
    |> redirect(to: "/secret")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
