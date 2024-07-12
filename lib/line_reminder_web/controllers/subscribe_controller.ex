defmodule LineReminderWeb.SubscribeController do
  use LineReminderWeb, :controller

  require Logger

  alias LineReminder.Receivers
  alias LineReminder.Sns.Line

  @grant_type "authorization_code"
  @response_type "code"
  @scope "notify"
  @headers [{"Content-Type", "application/x-www-form-urlencoded"}]

  # Line API token
  defp notify_auth_uri, do: Application.get_env(:line_reminder, :line_notify_auth_uri)
  defp notify_auth_token_uri, do: Application.get_env(:line_reminder, :line_notify_auth_token_uri)

  # Line bot credential for general notifier
  defp general_client_id, do: Application.get_env(:line_reminder, :general_client_id)
  defp general_client_secret, do: Application.get_env(:line_reminder, :general_client_secret)

  # Line bot credential for advanced notifier
  defp advanced_client_id, do: Application.get_env(:line_reminder, :advanced_client_id)
  defp advanced_client_secret, do: Application.get_env(:line_reminder, :advanced_client_secret)

  # Line bot credential for companion notifier
  defp companion_client_id, do: Application.get_env(:line_reminder, :companion_client_id)
  defp companion_client_secret, do: Application.get_env(:line_reminder, :companion_client_secret)

  # Line bot credential for companion 2h notifier
  defp companion2h_client_id, do: Application.get_env(:line_reminder, :companion2h_client_id)

  defp companion2h_client_secret,
    do: Application.get_env(:line_reminder, :companion2h_client_secret)

  def request(conn, %{"program" => program}) do
    code_req_uri =
      notify_auth_uri()
      |> append_code_req(program)

    conn |> redirect(external: code_req_uri) |> halt()
  end

  def callback(conn, %{"program" => program, "code" => code}) do
    [
      url: notify_auth_token_uri(),
      headers: @headers
    ]
    |> Req.new()
    |> Req.post(
      form: [
        grant_type: @grant_type,
        code: code,
        redirect_uri: url(~p"/subscribe/#{program}/callback"),
        client_id: get_client_id(program),
        client_secret: get_client_secret(program)
      ]
    )
    |> then(fn
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["access_token"]}
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "some errors"}
    end)
    |> then(fn
      {:ok, token} ->
        %{group: Receivers.get_group_code(program), token: token}
        |> Receivers.create_receiver()

      other_msg ->
        other_msg
    end)
    |> then(fn
      {:ok, receiver} ->
        Line.send_congrats(receiver.token, program)

        conn
        |> put_flash(:info, "Subscriber created successfully.")
        |> redirect(to: "/")

      {:error, msg} ->
        Logger.error(msg)

        conn
        |> put_flash(:error, "Failed to create subscriber.")
        |> redirect(to: "/")
    end)
  end

  defp append_code_req(uri, "general") do
    "#{uri}?response_type=#{@response_type}&client_id=#{general_client_id()}&scope=#{@scope}&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/subscribe/general/callback")}"
  end

  defp append_code_req(uri, "advanced") do
    "#{uri}?response_type=#{@response_type}&client_id=#{advanced_client_id()}&scope=#{@scope}&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/subscribe/advanced/callback")}"
  end

  defp append_code_req(uri, "companion") do
    "#{uri}?response_type=#{@response_type}&client_id=#{companion_client_id()}&scope=#{@scope}&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/subscribe/companion/callback")}"
  end

  defp append_code_req(uri, "companion2H") do
    "#{uri}?response_type=#{@response_type}&client_id=#{companion_client_id()}&scope=#{@scope}&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/subscribe/companion2H/callback")}"
  end

  defp get_client_id("general"), do: general_client_id()
  defp get_client_id("advanced"), do: advanced_client_id()
  defp get_client_id("companion"), do: companion_client_id()
  defp get_client_id("companion2H"), do: companion2h_client_id()

  defp get_client_secret("general"), do: general_client_secret()
  defp get_client_secret("advanced"), do: advanced_client_secret()
  defp get_client_secret("companion"), do: companion_client_secret()
  defp get_client_secret("companion2H"), do: companion2h_client_secret()
end
