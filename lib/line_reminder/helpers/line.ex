defmodule LineReminder.Line do
  @moduledoc """
  Line http client wrapper
  """

  @content_type_key "Content-Type"
  @content_type_value "application/x-www-form-urlencoded"
  @line_notify_url "https://notify-api.line.me/api/notify"

  @spec init() :: Req.Request.t()
  defp init() do
    Req.new(url: @line_notify_url)
    |> Req.Request.put_header(@content_type_key, @content_type_value)
  end

  @doc """
  Send passing message to particular line group

  ## Examples

  iex> send_to_group("abc")
  {:ok, res}
  """
  @spec send_to_group(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_to_group(msg) do
    init()
    |> Req.post(
      auth: {:bearer, Application.fetch_env!(:line_reminder, :line_token)},
      form: [message: msg]
    )
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
