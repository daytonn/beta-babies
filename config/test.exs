use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :beta_babies, BetaBabiesWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :beta_babies, BetaBabies.Repo,
  username: "postgres",
  password: "password",
  database: "beta_babies_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
