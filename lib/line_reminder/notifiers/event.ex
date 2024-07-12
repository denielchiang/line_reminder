defmodule LineReminder.Notifiers.Event do
  @moduledoc """
  Event table that store reminders name and date
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :date, :date
    field :name, :string
    field :group, Ecto.Enum, values: [general: 1, advanced: 2, companion: 3, companion2h: 4]

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :group])
    |> validate_required([:name, :date, :group])
  end
end
