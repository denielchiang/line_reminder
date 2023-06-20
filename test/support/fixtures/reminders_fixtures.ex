defmodule LineReminder.RemindersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LineReminder.Reminders` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-06-18],
        name: "some name",
        status: "some satus"
      })
      |> LineReminder.Reminders.create_event()

    event
  end
end
