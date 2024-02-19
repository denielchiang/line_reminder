defmodule LineReminder.Line do
  @moduledoc """
  Line HTTP client wrapper

  This module provides functions to send messages to Line groups using the Line Notify API.

  ## Examples

      iex> LineReminder.Line.send_to_group("abc")
      {:ok, "Topic already sent"}

      iex> LineReminder.Line.send_to_group("abcdef")
      {:error, "reason"}

  """

  import OK, only: [~>: 2]

  @doc """
  Sends a message to a Line group.

  ## Examples

      iex> send_to_group("abc")
      {:ok, "Topic already sent"}

  """
  @spec send_to_group(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg) do
    send_to_group(msg, Application.fetch_env!(:line_reminder, :line_token))
  end

  @spec send_to_group(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg, token) do
    [
      url: "https://notify-api.line.me/api/notify",
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}],
      auth: {:bearer, token}
    ]
    |> Req.new()
    |> Req.post(form: [message: msg])
    |> then(fn
      # status 200
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["message"]}
      # status 400, 401, 500, Other
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "connection failure happen"}
    end)
    ~> then(fn
      "ok" -> "Topic already be sent"
      other_body_message -> other_body_message
    end)
  end
end
