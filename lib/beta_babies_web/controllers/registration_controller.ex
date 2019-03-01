defmodule BetaBabiesWeb.RegistrationController do
  use BetaBabiesWeb, :controller
  alias BetaBabies.{Authentication, Authentication.Account, Authentication.Guardian}
  require IEx

  def new(conn, _params) do
    conn |> render_new(account_changeset(%{}))
  end

  def create(conn, %{"account" => account}) do
    changeset = account_changeset(account)

    with {:ok, account} <- Authentication.validate_confirmation_password(changeset),
         {:ok, account} <- Authentication.create_account(account) do
      conn
      |> put_flash(:success, "Welcome to Beta Babies!")
      |> Guardian.Plug.sign_in(account)
      |> redirect(to: "/secret")
    else
      {:error, account} -> conn |> render_new(account)
    end
  end

  defp render_new(conn, changeset) do
    render(conn, "new.html", changeset: changeset)
  end

  defp account_changeset(account_attributes) do
    Authentication.Account.changeset(%Account{}, account_attributes)
  end
end
