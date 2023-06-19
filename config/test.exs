import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :line_reminder, LineReminder.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "line_reminder_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :line_reminder, LineReminderWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "uNF3TbsRG3hStmF1Tl2dbyMMVaSm9Z+dJW/MZwh2vEN1IR1Cp26lEOUYnmErURP/",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
