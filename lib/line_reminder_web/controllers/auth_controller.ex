defmodule LineReminderWeb.AuthController do
  use LineReminderWeb, :controller

  alias LineReminder.Line

  @notify_auth_uri Application.compile_env!(:line_reminder, :line_notify_auth_uri)
  @notify_auth_token Application.compile_env!(:line_reminder, :line_notify_token_uri)
  @client_id Application.compile_env!(:line_reminder, :client_id)
  @client_secret Application.compile_env!(:line_reminder, :client_secret)
  @grant_type "authorization_code"
  @response_type "code"
  @scope "notify"
  @headers [{"Content-Type", "application/x-www-form-urlencoded"}]

  def request(conn, _params) do
    code_req_uri =
      @notify_auth_uri
      |> append_code_req()

    conn |> redirect(external: code_req_uri) |> halt()
  end

  def callback(conn, %{"code" => code}) do
    [
      url: @notify_auth_token,
      headers: @headers
    ]
    |> Req.new()
    |> Req.post(
      form: [
        grant_type: @grant_type,
        code: code,
        redirect_uri: url(~p"/auth/line/callback"),
        client_id: @client_id,
        client_secret: @client_secret
      ]
    )
    |> then(fn
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["access_token"]}
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "some errors"}
    end)
    |> then(fn
      {:ok, token} -> Line.send_to_group("\n您已訂閱一般組讀經進度小幫手🚀", token)
      other_msg -> other_msg
    end)

    redirect(conn, to: "/")
  end

  defp append_code_req(uri) do
    "#{uri}?response_type=#{@response_type}&client_id=#{@client_id}&scope=#{@scope}&state=#{get_csrf_token()}&redirect_uri=#{url(~p"/auth/line/callback")}"
  end
end
