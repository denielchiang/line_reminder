# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :line_reminder,
  ecto_repos: [LineReminder.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :line_reminder, LineReminderWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: LineReminderWeb.ErrorHTML, json: LineReminderWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LineReminder.PubSub,
  live_view: [signing_salt: "+rl3/Ikt"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use TZ for global setting
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :line_reminder,
  notify_auth_uri: System.get_env("LINE_NOTIFY_AUTH_URI"),
  notify_auth_token: System.get_env("LINE_NOTIFY_TOKEN_URI")

# Avif format serving
config :mime, :types, %{
  "image/avif" => ["avif"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
