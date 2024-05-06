defmodule LineReminder.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LineReminder.Reminders` context.
  """

  alias LineReminder.Events

  @doc """
  Generate events.
  """
  def event_fixture(), do: event_fixture(%{})

  @doc """
  Generate events.
  """
  def event_fixture(attr) when is_nil(attr), do: event_fixture(%{})

  def event_fixture(attrs) when is_list(attrs) do
    Enum.reduce(attrs, [], fn event, acc ->
      [acc | event_fixture(event)]
    end)
  end

  def event_fixture(attrs) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-06-18],
        name: "some name",
        group: 1
      })
      |> Events.create_event()

    event
  end
end
