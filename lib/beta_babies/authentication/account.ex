defmodule BetaBabies.Authentication.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "accounts" do
    field :password, :string
    field :email, :string
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
