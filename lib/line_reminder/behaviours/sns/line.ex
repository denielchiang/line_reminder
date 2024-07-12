defmodule LineReminder.Sns.Line do
  @moduledoc """
  Module for sending Line messages using Line Notify API.
  """
  import OK, only: [~>: 2]

  @behaviour LineReminder.SnsBehaviour

  @api_header [{"Content-Type", "application/x-www-form-urlencoded"}]
  @congrats_sticker_package 11_537
  @congrats_sticker_id 52_002_734

  defp notify_api_uri, do: Application.get_env(:line_reminder, :line_notify_api)

  @doc """
  Sends a congratulatory message to a Line group.

  Params:
    - token: The Line Notify API token for authentication.

  ## Example:
    iex> LineReminder.Line.send_congrats("Congratulations on your achievement!", "your_line_notify_token")
    {:ok, "Message sent successfully"}

  Returns:
    - {:ok, "Message sent successfully"} on success.
    - {:error, reason} on failure.
  """
  @impl true
  def send_congrats(token, group) do
    %{
      stickerPackageId: @congrats_sticker_package,
      stickerId: @congrats_sticker_id,
      message: choose_msg(group)
    }
    |> send_to_group(token)
  end

  defp choose_msg("general"), do: "\n您已訂閱[一般組]讀經進度小幫手\n🚀🚀🚀🚀🚀🚀"
  defp choose_msg("advanced"), do: "\n您已訂閱[速讀組]讀經進度小幫手\n🚀🚀🚀🚀🚀🚀"
  defp choose_msg("companion"), do: "\n您已訂閱[陪讀組]讀經進度小幫手\n🚀🚀🚀🚀🚀🚀"
  defp choose_msg("companion2H"), do: "\n您已訂閱[陪讀半年組組]讀經進度小幫手\n🚀🚀🚀🚀🚀🚀"

  # https://developers.line.biz/en/docs/messaging-api/sticker-list/#sticker-definitions
  @progress_sticker_package [
    52_002_768,
    52_002_764,
    52_002_752,
    52_002_745,
    52_002_735,
    52_002_738,
    52_002_739,
    52_002_748
  ]

  defp get_daliy_sticker() do
    @progress_sticker_package
    |> Enum.random()
  end

  @progress_sticker_id 52_002_768

  @doc """
  Sends a progress update message to a Line group.

  Params:
    - msg: The reading task message to send.
    - token: The Line Notify API token for authentication.

  ## Example:
    iex> LineReminder.Line.send_progress("Matthew 6:9 NIV", "your_line_notify_token")
    {:ok, "Message sent successfully"}

  Returns:
    - {:ok, "Message sent successfully"} on success.
    - {:error, reason} on failure.
  """
  @impl true
  def send_progress(msg, token) do
    %{
      stickerPackageId: get_daliy_sticker(),
      stickerId: @progress_sticker_id,
      message: msg
    }
    |> send_to_group(token)
  end

  @impl true
  def send_to_group(request, token) do
    [
      url: notify_api_uri(),
      headers: @api_header,
      auth: {:bearer, token}
    ]
    |> Req.new()
    |> Req.post(
      form: [
        stickerPackageId: request.stickerPackageId,
        stickerId: request.stickerId,
        message: request.message
      ]
    )
    |> then(fn
      # status 200
      {:ok, %Req.Response{body: body, status: 200}} -> {:ok, body["message"]}
      # status 400, 401, 500, Other
      {:ok, %Req.Response{body: body}} -> {:error, body["message"]}
      {:error, _others} -> {:error, "connection failure happen"}
    end)
    ~> then(fn
      "ok" -> "Message sent successfully"
      other_body_message -> other_body_message
    end)
  end
end
