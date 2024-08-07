defmodule LineReminderWeb.CSPHeader do
  @moduledoc """
  CSP definition for websocket
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_resp_header(conn, "content-security-policy", csp(conn))
  end

  defp csp(conn) do
    "default-src 'self'; \
    connect-src 'self' #{ws_url(conn)} #{ws_url(conn, "wss")}; \
    script-src 'self' 'unsafe-inline' 'unsafe-eval' #{cloudflare_insight_url()} #{vimeo_url()}; \
    frame-src 'self' 'unsafe-inline' 'unsafe-eval'  #{vimeo_url()}; \
    style-src 'self' 'unsafe-inline' 'unsafe-eval'; \
    font-src 'self' data:; \
    img-src 'self' data:;"
  end

  defp ws_url(conn, protocol \\ "ws") do
    endpoint = Phoenix.Controller.endpoint_module(conn)
    %{endpoint.struct_url | scheme: protocol} |> URI.to_string()
  end

  defp cloudflare_insight_url(), do: "static.cloudflareinsights.com"
  defp vimeo_url(), do: "player.vimeo.com"
end
