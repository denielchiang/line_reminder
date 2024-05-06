defmodule LineReminder.Repo.Migrations.CreateReceivers do
  use Ecto.Migration

  def change do
    create table(:receivers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :string, null: false
      add :group, :integer, null: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end
