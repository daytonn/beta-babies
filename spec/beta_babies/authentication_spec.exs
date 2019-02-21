defmodule AuthenticationSpec do
  use ESpec, async: false
  alias BetaBabies.{Repo, Authentication, Authentication.Account}

  describe "Authentication" do
    let(:valid_email, do: "test@example.com")
    let(:valid_password, do: "password")
    let(:valid_attrs, do: %{email: valid_email(), password: valid_password()})

    let(:updated_password, do: "updated password")
    let(:updated_email, do: "updated@example.com")
    let(:update_attrs, do: %{email: updated_email(), password: updated_password()})

    let(:invalid_attrs, do: %{password: nil, email: nil})

    finally(do: Repo.delete_all(Account))

    let :account do
      {:ok, account} =
        %Account{}
        |> Account.changeset(valid_attrs())
        |> Repo.insert()

      account
    end

    describe "list_accounts/0" do
      it "returns a list of accounts" do
        account()
        expect(Authentication.list_accounts() |> to(eq([account()])))
      end
    end

    describe "get_account/1" do
      it "returns the account with the given id" do
        account()
        expect(Authentication.get_account!(account().id)) |> to(eq(account()))
      end
    end

    describe "create_account/1" do
      context "with valid data" do
        it "creates an account" do
          {:ok, account} = Authentication.create_account(valid_attrs())

          expect(account.email) |> to(eq(valid_email()))
          expect(is_bitstring(account.password)) |> to(be_true())
        end
      end

      context "with invalid data" do
        it "returns an error changeset" do
          {status,
           %{
             errors: [
               email: {email_error, _},
               password: {password_error, _}
             ]
           }} = Authentication.create_account(invalid_attrs())

          expect(status) |> to(eq(:error))
          expect(email_error) |> to(eq("can't be blank"))
          expect(password_error) |> to(eq("can't be blank"))
        end
      end
    end

    describe "update_account/2" do
      context "with valid data" do
        it "updates the account" do
          %{password: existing_password, id: id} = account()
          {status, updated_account} = Authentication.update_account(account(), update_attrs())

          expect(status) |> to(eq(:ok))
          expect(updated_account.id) |> to(eq(id))
          expect(updated_account.email) |> to(eq(updated_email()))
          expect(updated_account.password) |> not_to(eq(existing_password))
        end
      end

      context "with invalid data" do
        it "returns an error changeset" do
          account()

          {status,
           %{
             errors: [
               email: {email_error, _},
               password: {password_error, _}
             ]
           }} = Authentication.update_account(account(), invalid_attrs())

          expect(status) |> to(eq(:error))
          expect(email_error) |> to(eq("can't be blank"))
          expect(password_error) |> to(eq("can't be blank"))
        end
      end
    end

    describe "delete_account/1" do
      it "deletes the account" do
        account()
        {status, %Account{}} = Authentication.delete_account(account())

        expect(status) |> to(eq(:ok))
        expect(Repo.all(Account)) |> to(be_empty())
      end
    end
  end
end
