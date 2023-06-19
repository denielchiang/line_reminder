defmodule LineReminder.Reminders.Event do
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
    # "set" -> "sent"
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :status])
    |> validate_required([:name, :date, :status])
  end
end
