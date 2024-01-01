defmodule LineReminder.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :line_reminder

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  def seeds(year \\ Date.utc_today().year()) do
    Application.load(@app)

    seeds_path = seeds_path(year)

    case File.read(seeds_path) do
      {:ok, _content} ->
        {:ok, _, _} =
          Ecto.Migrator.with_repo(LineReminder.Repo, fn _repo ->
            Code.eval_file(seeds_path)
          end)

      {:error, reason} ->
        IO.puts("Error reading seeds file: #{reason}")
    end
  end

  defp seeds_path(year) do
    Path.join(:code.priv_dir(@app), "repo/seeds_#{year}.exs")
  end
end
