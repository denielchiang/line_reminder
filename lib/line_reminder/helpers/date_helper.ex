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

  @doc """
    Checks if a given date is after today.

    ## Parameters

      - `date`: A `Date` struct representing the date to check.

    ## Returns

      - `true` if `date` is after today.
      - `false` otherwise.

    ## Examples

        iex> date_after_today?(~D[2099-01-01])
        true

        iex> date_after_today?(~D[2000-01-01])
        false

  """
  def date_after_today?(date) do
    today = taiwan_today()
    Date.compare(date, today) == :gt
  end

  def is_today?(date) do
    today = taiwan_today() |> Date.add(1)
    Date.compare(date, today) == :eq
  end
end
