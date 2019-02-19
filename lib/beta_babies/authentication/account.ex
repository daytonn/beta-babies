defmodule BetaBabies.Authentication.Account do
  use Ecto.Schema
  import Ecto.Changeset


  schema "accounts" do
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end
