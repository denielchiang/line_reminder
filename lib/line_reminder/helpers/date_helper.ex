defmodule LineReminder.DateHelper do
  @moduledoc false

  @taiwan "Asia/Taipei"

  defp today(timezone) do
    timezone
    |> DateTime.now!()
    |> DateTime.to_date()
  end

  @doc """
  Return taiwan today's Date

  ## Examples

  iex> taiwan_today()
  ~D[2023-11-12]
  """
  @spec taiwan_today() :: Date.t()
  def taiwan_today(), do: today(@taiwan)
end
