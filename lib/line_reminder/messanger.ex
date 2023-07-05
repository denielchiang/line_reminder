defmodule LineReminder.Messanger do
  @moduledoc """
  Messanger that send message
  """
  require Logger

  alias LineReminder.{Reminders, DateHelpers, Line}

  @status_sent Reminders.event_status_sent()
  @doc """
  Send today's reading book and charpter to Line group chat

  ## Examples

  iex> send()
  {:ok,"Topic already be sent"}
  """
  @spec send() :: :ok | :error
  def send do
    DateHelpers.taiwan_today()
    |> Reminders.get_event_by_date()
    |> List.wrap()
    |> Enum.reject(fn event -> event.status == @status_sent end)
    |> List.first()
    |> send_to_line()
  end

  @skip_msg "Today has no more topic to send"
  @success_msg "Topic already be sent"
  @error_msg "Message sent failed"

  @spec send_to_line(%{:name => binary()}) :: :ok | :error
  defp send_to_line(%{name: reading_topic} = event) do
    with {:ok, msg} <- make_complete_sentence(reading_topic),
         {:ok, result} <- Line.send_to_group(msg),
         {:ok, _} <- Reminders.update_event(event, %{status: @status_sent}) do
      Logger.info("Today #{DateHelpers.taiwan_today()} " <> @success_msg)
      Logger.info("Sending result: #{result}")
    else
      {:error, reason} ->
        Logger.error(@error_msg <> ": #{reason}")
    end
  end

  defp send_to_line(event) when is_nil(event) or event == [], do: Logger.info(@skip_msg)

  @spec make_complete_sentence(binary()) :: {:ok, binary()} | {:error, binary()}
  defp make_complete_sentence(msg) when is_nil(msg), do: {:error, "no content to organize"}

  defp make_complete_sentence(msg) do
    {:ok,
     ("\n今天的讀經進度是\n📣" <> msg <> "📣")
     |> String.replace("[", "第")
     |> String.replace("]", "章")}
  end
end
