defmodule LineReminderWeb.AuthController do
  use LineReminderWeb, :controller

  alias LineReminder.Line

  @notify_auth_uri Application.compile_env!(:line_reminder, :line_notify_auth_uri)
  @client_id Application.compile_env!(:line_reminder, :client_id)
  @client_secret Application.compile_env!(:line_reminder, :client_secret)

  def request(conn, _params) do
    code_req_uri =
      @notify_auth_uri
      |> append_code_req()

    conn |> redirect(external: code_req_uri) |> halt()
  end

  def callback(conn, %{"code" => code}) do
    [
      url: "https://notify-bot.line.me/oauth/token",
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}]
    ]
    |> Req.new()
    |> Req.post(
      form: [
        grant_type: "authorization_code",
        code: code,
        redirect_uri: url(~p"/auth/line/callback"),
        client_id: @client_id,
        client_secret: @client_secret
      ]
    )
    |> tap(&IO.inspect/1)
    |> then(fn
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["access_token"]}
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "some errors"}
    end)
    |> tap(&IO.inspect/1)
    |> then(fn
      {:ok, token} -> Line.send_to_group("\n您已訂閱一般組讀經進度小幫手🚀", token)
      other_msg -> other_msg
    end)

    redirect(conn, to: "/home")
  end

  defp append_code_req(uri) do
    "#{uri}?response_type=code&client_id=G7Dl2c8gXLWtgtytnVnQFC&scope=notify&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/auth/line/callback")}"
  end
end
