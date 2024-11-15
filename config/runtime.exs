import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/line_reminder start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :line_reminder, LineReminderWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  # maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :line_reminder, LineReminder.Repo,
    ssl: false,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: [:inet6]

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :line_reminder, LineReminderWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    check_origin: ["//alertime.room3327.net", "//alertime-app.fly.dev"],
    secret_key_base: secret_key_base

  config :line_reminder,
    line_notify_api: System.get_env("LINE_API_URI"),
    line_notify_auth_uri: System.get_env("LINE_NOTIFY_AUTH_URI"),
    line_notify_auth_token_uri: System.get_env("LINE_NOTIFY_AUTH_TOKEN_URI"),
    general_client_id: System.get_env("GENERAL_CLIENT_ID"),
    general_client_secret: System.get_env("GENERAL_CLIENT_SECRET"),
    advanced_client_id: System.get_env("ADVANCED_CLIENT_ID"),
    advanced_client_secret: System.get_env("ADVANCED_CLIENT_SECRET"),
    companion_client_id: System.get_env("COMPANION_CLIENT_ID"),
    companion_client_secret: System.get_env("COMPANION_CLIENT_SECRET"),
    companion2h_client_id: System.get_env("COMPANION_2H_CLIENT_ID"),
    companion2h_client_secret: System.get_env("COMPANION_2H_CLIENT_SECRET")

  config :line_reminder, LineReminder.Scheduler,
    timezone: "Asia/Taipei",
    overlap: false,
    run_strategy: Quantum.RunStrategy.Local,
    jobs: [
      bible_remind: [
        schedule: {:cron, "0 5 * * 1-6"},
        task: {LineReminder.Apostle, :send, []}
      ]
    ]

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :line_reminder, LineReminderWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :line_reminder, LineReminderWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.
end
