defmodule BetaBabies.AuthenticationTest do
  use BetaBabies.DataCase

  alias BetaBabies.{Repo, Authentication, Authentication.Account}

  alias BetaBabies.Authentication.Account

  @valid_password "password"
  @valid_email "test@example.com"
  @valid_attrs %{password: @valid_password, email: @valid_email}

  @updated_email "updated@example.com"
  @updated_password "new password"
  @update_attrs %{password: @updated_password, email: @updated_email}

  @invalid_attrs %{password: nil, email: nil}

  def account_fixture() do
    {:ok, account} =
      %Account{}
      |> Account.changeset(@valid_attrs)
      |> Repo.insert()

    account
  end

  describe "list_accounts/0" do
    test "returns all accounts" do
      account = account_fixture()
      assert Authentication.list_accounts() == [account]
    end
  end

  describe "get_account/1" do
    test "returns the account with given id" do
      account = account_fixture()
      assert Authentication.get_account!(account.id) == account
    end
  end

  describe "create_account/1" do
    test "with valid data creates a account" do
      assert {:ok, %Account{} = account} = Authentication.create_account(@valid_attrs)
      assert is_bitstring(account.password)
      assert account.email == @valid_email
    end

    test "with invalid data returns error changeset" do
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

    test "with existing email address returns an error changeset" do
      account_fixture()

      {status, %{errors: [email: {email_error, _}]}} = Authentication.create_account(@valid_attrs)

      assert status == :error
      assert email_error == "has already been taken"
    end
  end

  describe "update_account/2" do
    test "with valid data updates the account" do
      account = account_fixture()
      %{password: existing_password} = account

      {status, updated_account} = Authentication.update_account(account, @update_attrs)

      assert status == :ok
      assert updated_account.id == account.id
      assert updated_account.email == @updated_email
      assert updated_account.password != existing_password
    end

    test "with invalid data returns error changeset" do
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
  end

  describe "delete_account/1" do
    test "deletes the account" do
      account = account_fixture()
      {status, %Account{}} = Authentication.delete_account(account)

      assert status == :ok
      assert length(Repo.all(Account)) == 0
    end
  end

  describe "validate_confirmation_password/2" do
    test "with matching passwords returns succes tuple with an account changeset" do
      account =
        Account.changeset(%Account{}, %{
          "email" => @valid_email,
          "password" => @valid_password,
          "password_confirmation" => @valid_password
        })

      assert {:ok,
              %{
                email: @valid_email,
                password: @valid_password,
                password_confirmation: @valid_password
              }} = Authentication.validate_confirmation_password(account)
    end

    test "with mismatched passwords returns an error tuple" do
      account =
        Account.changeset(%Account{}, %{
          "email" => @valid_email,
          "password" => @valid_password,
          "password_confirmation" => "mismatched password"
        })

      {:error, changeset} = Authentication.validate_confirmation_password(account)

      assert changeset.errors == [password: {"passwords do not match", []}]
    end
  end
end
