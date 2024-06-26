defmodule LineReminder.Events do
  @moduledoc """
  The Reminders context.
  """

  import Ecto.Query, warn: false
  alias LineReminder.Repo

  alias LineReminder.Notifiers.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Get event by date

  ## Examples
  %Event{}

  iex> get_event_by_date(~D[1970-01-01])
  nil

  iex> get_event_by_date(~D[2024-04-15])
  [
  %LineReminder.Notifiers.Event{
    __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
    id: "29ba0605-3dd9-46f5-a69d-c7bf9c068915",
    date: ~D[2024-04-15],
    name: "士師記7-8",
    group: :general,
    inserted_at: ~N[2024-03-12 16:58:21],
    updated_at: ~N[2024-03-12 16:58:21]
  }
  ]
  """
  def get_events_by_date(date) do
    query = from e in Event, where: e.date == ^date
    Repo.all(query)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def has_events_with_2024? do
    query = from e in Event, where: fragment("?::date >= ?", e.date, ^~D[2024-01-01])

    Repo.exists?(query)
  end
end
