defmodule LineReminder.Notifiers.Receiver do
  @moduledoc """
  Receiver table that store group and receiver token
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "receivers" do
    field :group, Ecto.Enum, values: [general: 1, advanced: 2, companion: 3]
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(receiver, attrs) do
    receiver
    |> cast(attrs, [:token, :group])
    |> validate_required([:token, :group])
    |> unique_constraint(:token)
  end
end
