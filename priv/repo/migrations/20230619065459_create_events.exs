defmodule LineReminder.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :date, :date, null: false
      add :status, :string, null: false

      timestamps()
    end
  end
end
