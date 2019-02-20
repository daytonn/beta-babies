defmodule BetaBabies.AuthenticationTest do
  use BetaBabies.DataCase

  alias BetaBabies.Authentication

  describe "accounts" do
    alias BetaBabies.Authentication.Account

    @valid_attrs %{password: "some password", email: "test@example.com"}
    @update_attrs %{password: "some updated password", email: "updated@example.com"}
    @invalid_attrs %{password: nil, email: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Authentication.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Authentication.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Authentication.create_account(@valid_attrs)
      assert is_bitstring(account.password)
      assert account.email == "test@example.com"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Authentication.update_account(account, @update_attrs)
      assert is_bitstring(account.password)
      assert account.email == "updated@example.com"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_account(account, @invalid_attrs)
      assert account == Authentication.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Authentication.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Authentication.change_account(account)
    end
  end
end
