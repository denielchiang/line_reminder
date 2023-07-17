defmodule LineReminder.Line do
  @moduledoc """
  Line http client wrapper
  """
  @doc """
  Send passing message to particular line group

  ## Examples

  iex> send_to_group("abc")
  {:ok, message}
  """
  @spec send_to_group(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg) do
    [
      url: "https://notify-api.line.me/api/notify",
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}],
      auth: {:bearer, Application.fetch_env!(:line_reminder, :line_token)}
    ]
    |> Req.new()
    |> then(&Req.post!(&1, form: [message: msg]).body["message"])
    |> handle_resp()
  end

  defp handle_resp("ok"), do: {:ok, "Topic already be sent"}
  defp handle_resp(message), do: {:error, message}
end
