defmodule LineReminder.Repo.Migrations.AlterReceiversIndex do
  use Ecto.Migration

  def change do
    create index(:receivers, [:token], unique: true)
  end
end
