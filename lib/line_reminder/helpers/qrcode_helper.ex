defmodule LineReminder.QrcodeHelper do
  @moduledoc """
  QR Code Helpers

  This module provides functions to generate QR codes for subscribing to different groups.

  ## Example

      LineReminder.QrcodeHelpers.gen_qrcodes()

  This will generate QR codes for subscribing to each group defined in `@groups`.

  """
  alias QRCode.Render.SvgSettings

  @groups ["general", "advanced", "companion", "companion2h"]
  @qrcode_color {79, 70, 229}
  @prepend_header "data:image/svg+xml;base64,"

  @spec gen_qrcodes() :: [String.t()]
  def gen_qrcodes() do
    @groups
    |> Enum.map(&gen_subscribe_url/1)
    |> Enum.map(&gen_qr_code/1)
  end

  def gen_qrcode(group) when group in @groups do
    group
    |> gen_subscribe_url()
    |> gen_qr_code()
  end

  def gen_qrcode(_group),
    do: {:error, "Parameter can be only [general, advanced, companion, companion2h]"}

  def get_groups(), do: @groups

  @spec gen_subscribe_url(String.t()) :: String.t()
  defp gen_subscribe_url(group) do
    "#{LineReminderWeb.Endpoint.url()}/subscribe/#{group}"
  end

  @spec gen_qr_code(String.t()) :: {:ok, {String.t(), String.t()}} | {:error, String.t()}
  defp gen_qr_code(url) do
    svg_settings =
      %SvgSettings{
        qrcode_color: @qrcode_color,
        image: nil,
        structure: :readable
      }

    url
    |> gen_base64_code(svg_settings)
    |> prepend_base64_preifx()
    |> case do
      {:ok, image} ->
        {:ok, {image, url}}

      {:error, _reason} ->
        {:error, "QR Code generation failed!"}
    end
  end

  defp gen_base64_code(url, svg_settings) do
    url
    |> QRCode.create()
    |> QRCode.render(:svg, svg_settings)
    |> QRCode.to_base64()
  end

  defp prepend_base64_preifx({:ok, url}), do: {:ok, @prepend_header <> url}
  defp prepend_base64_preifx(error), do: error
end
