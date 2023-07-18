defmodule LineReminder.Line do
  @moduledoc """
  Line http client wrapper
  """
  @doc """
  Send passing message to particular line group

  ## Examples

  iex> send_to_group("abc")
  {:ok, Topic already be sent}

  iex> send_to_group("abcdef")
  {:error, reason}
  """
  @spec send_to_group(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg) do
    [
      url: "https://notify-api.line.me/api/notify",
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}],
      auth: {:bearer, Application.fetch_env!(:line_reminder, :line_token)}
    ]
    |> Req.new()
    |> Req.post(form: [message: msg])
    |> then(fn
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, handle_body_message(body["message"])}
      {:ok, %Req.Response{body: body}} -> {:error, handle_body_message(body["message"])}
      {:error, _others} -> {:error, "connection failure happen"}
    end)
  end

  defp handle_body_message("ok"), do: "Topic already be sent"
  defp handle_body_message(message), do: message
end
