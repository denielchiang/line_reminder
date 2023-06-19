defmodule LineReminder.Repo do
  use Ecto.Repo,
    otp_app: :line_reminder,
    adapter: Ecto.Adapters.Postgres
end
