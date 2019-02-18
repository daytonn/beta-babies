defmodule BetaBabies.Repo do
  use Ecto.Repo,
    otp_app: :beta_babies,
    adapter: Ecto.Adapters.Postgres
end
