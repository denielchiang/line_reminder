defmodule LineReminder.Apostle do
  @moduledoc """
  The `LineReminder.Apostle` module handles sending reminders and notifications via the Line messaging platform.
  """

  require Logger

  alias LineReminder.Sns.Line
  alias LineReminder.DateHelper
  alias LineReminder.Notifiers
  alias LineReminder.Receivers

  @doc """
  Sends Line reminders and notifications for today's events.

  This function sends Line reminders and notifications for today's events to users. It first retrieves today's date in the Taiwan timezone (`Asia/Taipei`) using `DateHelpers.today/1`. Then, it retrieves today's events using `Notifiers.get_events/1`, sends progress notifications using `Notifiers.send_progress/1`, and asynchronously sends Line messages for each event using `Line.send_progress/2`.

  ## Returns
  - `:ok` if the reminders and notifications are sent successfully.
  - `:error` if there is an error during the process.
  """
  @spec send() :: :ok | :error
  def send do
    with date <- DateHelper.taiwan_today(),
         events <- Notifiers.get_events(date),
         progress <- Notifiers.send_progress(events),
         tasks <-
           Task.async_stream(progress, &Line.send_progress(&1.msg, &1.token),
             ordered: false,
             max_concurrency: 50
           ),
         :ok <- wait_for_tasks(tasks),
         :ok <- update_receivers_time(progress) do
      :ok
    else
      error -> error
    end
  end

  defp wait_for_tasks(tasks_stream) when is_function(tasks_stream) do
    tasks_stream
    |> Stream.map(&handle_task_result/1)
    |> Enum.all?(&(&1 == :ok))
    |> if do
      :ok
    else
      :error
    end
  end

  defp handle_task_result({:ok, {:ok, _message}}), do: :ok
  defp handle_task_result(_), do: :error

  defp update_receivers_time(progress) do
    with tokens <- Enum.map(progress, & &1.token),
         {count, _} <- Receivers.update_receivers(tokens) do
      Logger.info("Total updated #{count} receivers account!")
      :ok
    else
      _ -> :error
    end
  end
end
