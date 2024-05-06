defmodule LineReminder.Repo.Migrations.AlterEventsRemovedDate do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :group, :integer, null: false
      remove :status
    end
  end
end
