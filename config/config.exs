# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :beta_babies,
  ecto_repos: [BetaBabies.Repo]

# Configures the endpoint
config :beta_babies, BetaBabiesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vIryJ04KIZ1ut4sjdwXCdxwfSoig4rsE7Mnn8vHmTQzs+aGFjq/0PISUVW7lCkDo",
  render_errors: [view: BetaBabiesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BetaBabies.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :beta_babies, BetaBabies.Authentication.Guardian,
  issuer: "beta_babies",
  secret_key: "s8EwD4gZxbONxPrEHJPz6jhOsiKxU4XPwgTRz9w7GG3x5zFEQGF14EGqVjYv6kru"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
