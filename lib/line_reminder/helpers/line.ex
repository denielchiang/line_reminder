defmodule LineReminder.Line do
  @moduledoc """
  Line http client wrapper
  """

  @content_type_key "Content-Type"
  @content_type_value "application/x-www-form-urlencoded"
  @line_notify_url "https://notify-api.line.me/api/notify"

  defp init() do
    Req.new()
    |> Req.Request.put_header(@content_type_key, @content_type_value)
  end

  @doc """
  Send passing message to particular line group

  ## Examples

  iex> send_to_group("abc")
  {:ok, res}
  """
  def send_to_group(msg) do
    init()

    {:ok, _res} =
      Req.post(
        @line_notify_url,
        auth: {:bearer, Application.fetch_env!(:line_reminder, :line_token)},
        form: [message: msg]
      )
  end
end
