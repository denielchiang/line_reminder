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
    |> Req.post(form: [message: msg])
    |> then(fn
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["message"]}
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "connection failure happen"}
    end)
    |> then(fn
      {:ok, "ok"} -> {:ok, "Topic already be sent"}
      {:error, reason} -> {:error, reason}
    end)
  end
end
