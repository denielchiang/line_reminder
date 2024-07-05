defmodule LineReminder.ExcelHelper do
  @moduledoc """
  This module provides functionality to import data from Excel files, specifically targeting
  certain sheet types defined by the `@sheet_types` module attribute.

  The imported data is transformed and filtered based on various conditions, such as the
  presence of `NaiveDateTime` values and the number of `nil` values in each row. The resulting
  data is returned as a list of maps, where each map represents a row from the Excel sheet with
  keys for the name, date, and group.

  ## Examples

      iex> LineReminder.ExcelHelper.import_all("path/to/file.xlsx")
      [
        %{name: "Chapter1", date: ~N[2023-05-01 00:00:00], group: 1},
        %{name: "Chapter2", date: ~N[2023-05-02 00:00:00], group: 2},
        %{name: "Chapter3", date: ~N[2023-05-03 00:00:00], group: 3}
      ]
  """
  require Logger

  @typedoc """
  A map representing the sheet types and their corresponding integer values.
  """
  @type sheet_types_map :: %{
          general: 0,
          advanced: 1,
          companion: 2,
          companion2h: 3
        }
  @sheet_types %{
    general: 0,
    advanced: 1,
    companion: 2,
    companion2h: 3
  }

  @doc """
  Imports data from all sheet types defined in `@sheet_types`.

  ## Parameters

    - `file_path`: A string representing the path to the Excel file.

  ## Returns

    - A list of maps, where each map represents a row from the Excel sheet with keys for the name, date, and group.
  """
  @spec import_all(String.t()) :: [map()]
  def import_all(file_path) do
    @sheet_types
    |> Enum.map(&import_sheet(file_path, &1))
    |> List.flatten()
  end

  @doc """
  Imports data from a specific sheet type in the Excel file.

  ## Parameters

    - `file_path`: A string representing the path to the Excel file.
    - `{group, sheet_idx}`: A tuple containing the sheet type atom (`:general`, `:advanced`, or `:companion`) and the sheet index.

  ## Returns

    - A list of maps, where each map represents a row from the specified sheet with keys for the name, date, and group.
    - `{:error, reason}` if there was an error importing the sheet.
  """
  @spec import_sheet(String.t(), {atom(), non_neg_integer()}) ::
          [map()] | {:error, String.t()}
  def import_sheet(file_path, {group, sheet_idx}) do
    with {:ok, tid} <- extract_sheet(file_path, sheet_idx),
         {:xlsxir, sheet} <- {:xlsxir, Xlsxir.get_list(tid)},
         {:ets, :ok} <- {:ets, Xlsxir.close(tid)} do
      sheet
      |> Stream.map(&Stream.map(&1, fn cell -> if is_nil(cell), do: 1, else: 0 end))
      |> Stream.map(&Enum.sum/1)
      |> Enum.to_list()
      |> then(&Stream.zip(sheet, &1))
      |> Stream.reject(&incorrect_nil_counts/1)
      |> Stream.filter(&valuable_data?/1)
      |> Stream.map(&reshaping/1)
      |> Stream.map(&trim_cell/1)
      |> Stream.flat_map(& &1)
      |> Stream.chunk_every(2)
      |> Enum.to_list()
      |> Enum.map(&build_map(&1, group))
    else
      {:error, reason} ->
        Logger.error("Import excel failed: #{reason}")
        {:error, reason}
    end
  end

  def build_map([date, chapter], group) do
    %{
      name: chapter,
      date: date,
      group: fit_structs_group(group)
    }
  end

  def fit_structs_group(group) do
    case group do
      :general -> 1
      :advanced -> 2
      :companion -> 3
      :companion2h -> 4
    end
  end

  def extract_sheet(nil, _idx), do: {:parser, {:error, "path is nil"}}

  def extract_sheet(file_path, idx) do
    if File.exists?(file_path) do
      Xlsxir.multi_extract(file_path, idx, false, max_rows: 200)
    else
      {:error, "file is not exist"}
    end
  end

  @invalid_nil_count 24
  defp incorrect_nil_counts({_row, count}), do: count == @invalid_nil_count

  defp valuable_data?({row, _count}), do: Enum.any?(row, &naive?/1)

  defp naive?(%NaiveDateTime{}), do: true
  defp naive?(_), do: false

  defp reshaping({row, _count}), do: Enum.reject(row, &is_nil(&1))

  defp trim_cell(row), do: Enum.map(row, &trim_value/1)

  defp trim_value(%NaiveDateTime{} = dt), do: dt

  defp trim_value(chapter) do
    chapter
    |> String.split(" ", trim: true)
    |> Enum.join("")
  end
end
