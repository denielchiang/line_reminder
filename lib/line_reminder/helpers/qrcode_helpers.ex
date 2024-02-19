defmodule LineReminder.QrcodeHelpers do
  @moduledoc """
  QR Code Helpers

  This module provides functions to generate QR codes for subscribing to different groups.

  ## Example

      LineReminder.QrcodeHelpers.gen_qrcodes()

  This will generate QR codes for subscribing to each group defined in `@groups`.

  """
  alias QRCode.Render.SvgSettings

  @groups ["general", "advanced", "companion"]
  @qrcode_color {79, 70, 229}

  @spec gen_qrcodes() :: [String.t()]
  def gen_qrcodes() do
    @groups
    |> Enum.map(&gen_subscribe_url/1)
    |> Enum.map(&gen_qr_code/1)
  end

  @spec gen_subscribe_url(String.t()) :: String.t()
  defp gen_subscribe_url(group) do
    "#{LineReminderWeb.Endpoint.url()}/subscribe/#{group}"
  end

  @spec gen_qr_code(String.t()) :: String.t() | {:error, String.t()}
  defp gen_qr_code(url) do
    svg_settings =
      %SvgSettings{
        qrcode_color: @qrcode_color,
        image: nil,
        structure: :readable
      }

    url
    |> gen_base64_code(svg_settings)
    |> case do
      {:ok, image} ->
        image

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
end
