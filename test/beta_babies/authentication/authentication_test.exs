defmodule BetaBabies.AuthenticationTest do
  use BetaBabies.DataCase

  alias BetaBabies.{Repo, Authentication, Authentication.Account}

  describe "accounts" do
    alias BetaBabies.Authentication.Account

    @valid_password "password"
    @valid_email "test@example.com"
    @valid_attrs %{password: @valid_password, email: @valid_email}

    @updated_email "updated@example.com"
    @updated_password "password"
    @update_attrs %{password: @updated_password, email: @updated_email}

    @invalid_attrs %{password: nil, email: nil}

    def account_fixture() do
      {:ok, account} =
        %Account{}
        |> Account.changeset(@valid_attrs)
        |> Repo.insert()

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
      assert account.email == @valid_email
    end

    test "create_account/1 with invalid data returns error changeset" do
      {status,
       %{
         errors: [
           email: {email_error, _},
           password: {password_error, _}
         ]
       }} = Authentication.create_account(@invalid_attrs)

      assert status == :error
      assert email_error == "can't be blank"
      assert password_error == "can't be blank"
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      %{password: existing_password} = account

      {status, updated_account} = Authentication.update_account(account, @update_attrs)

      assert status == :ok
      assert updated_account.id == account.id
      assert updated_account.email == @updated_email
      assert updated_account.password != existing_password
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()

      {status,
       %{
         errors: [
           email: {email_error, _},
           password: {password_error, _}
         ]
       }} = Authentication.update_account(account, @invalid_attrs)

      assert status == :error
      assert email_error == "can't be blank"
      assert password_error == "can't be blank"
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      {status, %Account{}} = Authentication.delete_account(account)

      assert status == :ok
      assert length(Repo.all(Account)) == 0
    end
  end
end
