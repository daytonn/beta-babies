defmodule BetaBabiesWeb.RegistrationControllerTest do
  use BetaBabiesWeb.ConnCase
  alias BetaBabies.Authentication

  @valid_email "test@example.com"
  @valid_password "password"
  @missmatched_password "different password"

  @valid_params %{
    "email" => @valid_email,
    "password" => @valid_password,
    "password_confirmation" => @valid_password
  }

  @invalid_params %{
    "email" => @valid_email,
    "password" => @valid_password,
    "password_confirmation" => @missmatched_password
  }

  describe "new/2" do
    test "it responds with a 200 status", %{conn: conn} do
      conn = get(conn, "/signup")
      assert conn.status == 200
    end
  end

  describe "create/2" do
    test "with valid params, it redirects to the secret page", %{conn: conn} do
      conn = post(conn, "/signup", %{"account" => @valid_params})
      assert conn.status == 302
    end

    test "with valid params, it creates an account", %{conn: conn} do
      post(conn, "/signup", %{"account" => @valid_params})

      found_emails =
        Authentication.list_accounts()
        |> Enum.map(fn account -> account.email end)
        |> Enum.filter(fn email -> email == @valid_email end)

      assert length(found_emails) == 1
    end

    test "with invalid params, it renders the new template with errors", %{conn: conn} do
      conn = post(conn, "/signup", %{"account" => @invalid_params})

      assert conn == conn
    end
  end
end
