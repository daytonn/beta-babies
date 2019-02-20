defmodule BetaBabiesWeb.RegistrationController do
  use BetaBabiesWeb, :controller
  alias BetaBabies.{Authentication, Authentication.Account, Authentication.Guardian}

  def new(conn, _params) do
    conn |> render_new(%{})
  end

  def create(conn, %{"account" => account}) do
    %{
      "password" => password,
      "password_confirmation" => password_confirmation
    } = account

    if password == password_confirmation do
      case Authentication.create_account(account) do
        {:ok, account} ->
          conn
          |> put_flash(:success, "Welcome to Beta Babies!")
          |> Guardian.Plug.sign_in(account)
          |> redirect(to: "/secret")

        {:error, account} ->
          conn |> render_new(account)
      end
    else
      conn |> render_new(account)
    end
  end

  defp render_new(conn, account) do
    render(conn, "new.html", changeset: account_changeset(account))
  end

  defp account_changeset(account) do
    Authentication.Account.changeset(%Account{}, account)
  end
end
