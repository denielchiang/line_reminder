defmodule LineReminder.Line do
  @moduledoc """
  Line http client wrapper
  """
  @spec init() :: Req.Request.t()
  defp init() do
    Req.new(
      url: "https://notify-api.line.me/api/notify",
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}],
      auth: {:bearer, Application.fetch_env!(:line_reminder, :line_token)}
    )
  end

  @doc """
  Send passing message to particular line group

  ## Examples

  iex> send_to_group("abc")
  {:ok, message}
  """
  @spec send_to_group(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg) do
    init()
    |> Req.post(form: [message: msg])
    |> case do
      {:ok, %Req.Response{status: 200}} ->
        {:ok, "Topic already be sent"}

      {:ok, _others} ->
        {:error, "connected but something going wrong"}

      {:error, _others} ->
        {:error, "connection failure happen"}
    end
  end
end
