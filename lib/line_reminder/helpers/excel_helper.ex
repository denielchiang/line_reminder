defmodule LineReminder.ExcelHelper do
  @sheet_types %{
    general: 0,
    advanced: 1,
    companion: 2
  }

  def import_all(file_path) do
    @sheet_types
    |> Enum.map(&import_sheet(file_path, &1))
    |> List.flatten()
  end

  def import_sheet(file_path, {group, sheet_idx}) do
    with {:parser, {:ok, tid}} <- {:parser, extract_sheet(file_path, sheet_idx)} do
      sheet = Xlsxir.get_list(tid)
      Xlsxir.close(tid)

      sheet
      |> Enum.map(&Enum.count(&1, fn cell -> is_nil(cell) end))
      |> then(&Enum.zip(sheet, &1))
      |> Enum.reject(&incorrect_nil_counts/1)
      |> Enum.filter(&valuable_data?/1)
      |> Enum.map(&reshaping/1)
      |> Enum.map(&trim_cell/1)
      |> List.flatten()
      |> Enum.chunk_every(2)
      |> Enum.map(&build_map(&1, group))
    end
  end

  defp build_map([date, chapter], group) do
    %{
      name: chapter,
      date: date,
      group: fit_structs_group(group)
    }
  end

  defp fit_structs_group(group) do
    case group do
      :general -> 1
      :advanced -> 2
      :companion -> 3
    end
  end

  defp extract_sheet(nil, _idx), do: {:parser, {:error, "path is nil"}}

  defp extract_sheet(file_path, idx) do
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
