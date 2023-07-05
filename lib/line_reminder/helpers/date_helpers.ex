defmodule LineReminder.DateHelpers do
  @taiwan_tz "Asia/Taipei"

  @moduledoc """
  Return today's Date

  ## Examples

  iex> taiwan_today()
  ~D[2023-11-12]
  """
  @spec taiwan_today() :: Date.t()
  def taiwan_today() do
    DateTime.now!(@taiwan_tz)
    |> DateTime.to_date()
  end
end
