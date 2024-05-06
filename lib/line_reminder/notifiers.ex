defmodule LineReminder.Notifiers do
  @moduledoc """
  The Notifiers context provides functions for managing events and sending progress notifications.
  """
  import Ecto.Query, warn: false

  alias LineReminder.Receivers
  alias LineReminder.Events

  @typedoc """
  A map representing events, with optional keys `:general`, `:advanced`, and `:companion`,
  where the values are lists of strings (representing module names).
  """
  @type event_map :: %{
          optional(:general) => list(String.t()),
          optional(:advanced) => list(String.t()),
          optional(:companion) => list(String.t())
        }

  @typedoc """
  A map representing progress messages, with optional keys `:general`, `:advanced`, and `:companion`,
  where the values are lists of strings (representing messages).
  """
  @type progress_map :: %{
          optional(:general) => list(String.t()),
          optional(:advanced) => list(String.t()),
          optional(:companion) => list(String.t())
        }

  @typedoc """
  A map representing a receiver, with keys `:group` (one of `:general`, `:advanced`, or `:companion`)
  and `:token` (a string representing the token).
  """
  @type receiver :: %{
          group: :general | :advanced | :companion,
          token: String.t()
        }

  @doc """
  Retrieves events for a given date.

  ## Parameters

  - `date`: A `Date` struct representing the date for which to retrieve events.

  ## Returns

  - An `event_map` containing the events grouped by group (`:general`, `:advanced`, `:companion`).
  """
  @spec get_events(Date.t()) :: event_map()
  def get_events(date) when is_struct(date, Date) do
    date
    |> Events.get_events_by_date()
    |> Enum.group_by(& &1.group)
    |> Enum.map(fn {group, modules} ->
      {group, Enum.map(modules, & &1.name)}
    end)
    |> Enum.into(%{})
  end

  @doc """
  Sends progress notifications based on the provided events.

  ## Parameters

  - `progress_today`: An `event_map` containing the events for today.

  ## Returns

  - A list of maps containing the message and token for each receiver.
  """
  @spec send_progress(event_map()) :: list(map)
  def send_progress(progress_today) when is_map(progress_today) do
    with receivers <- Receivers.list_receivers_to_send() do
      receivers
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&choose_msg(&1, progress_today))
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
    end
  end

  defp choose_msg(%{group: :general, token: token}, %{general: msgs}) when is_list(msgs),
    do: Enum.map(msgs, &%{msg: &1, token: token})

  defp choose_msg(%{group: :advanced, token: token}, %{advanced: msgs}) when is_list(msgs),
    do: Enum.map(msgs, &%{msg: &1, token: token})

  defp choose_msg(%{group: :companion, token: token}, %{companion: msgs}) when is_list(msgs),
    do: Enum.map(msgs, &%{msg: &1, token: token})

  defp choose_msg(_receiver, _msg_code), do: nil
end
