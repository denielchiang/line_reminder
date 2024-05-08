defmodule LineReminder.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :line_reminder

  def migrate(opts \\ [all: true]) do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, opts))
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


# TODO: migrate to use new way
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

  @doc """
  Print the migration status for configured Repos' migrations.
  """
  def migration_status do
    for repo <- repos(), do: print_migrations_for(repo)
  end

  defp print_migrations_for(repo) do
    paths = repo_migrations_path(repo)

    {:ok, repo_status, _} =
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.migrations(&1, paths), mode: :temporary)

    IO.puts(
      """
      Repo: #{inspect(repo)}
        Status    Migration ID    Migration Name
      --------------------------------------------------
      """ <>
        Enum.map_join(repo_status, "\n", fn {status, number, description} ->
          "  #{pad(status, 10)}#{pad(number, 16)}#{description}"
        end) <> "\n"
    )
  end

  defp repo_migrations_path(repo) do
    config = repo.config()
    priv = config[:priv] || "priv/#{repo |> Module.split() |> List.last() |> Macro.underscore()}"
    config |> Keyword.fetch!(:otp_app) |> Application.app_dir() |> Path.join(priv)
  end

  defp pad(content, pad) do
    content
    |> to_string
    |> String.pad_trailing(pad)
  end
end
