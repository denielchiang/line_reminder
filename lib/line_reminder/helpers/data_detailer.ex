defmodule LineReminder.DataDetailer do
  @moduledoc """
  Module for transforming data from a file into a specific format.

  This module provides functions to read a file, transform its content, and build a list
  of maps suitable for further processing or insertion into a database.

  ## Examples

      iex> file_path = "path/to/your/file.txt"
      iex> data = LineReminder.DataDetailer.transform(file_path)

  """

  @doc """
  Transforms the content of a file into a list of maps.

  ## Examples

      iex> file_path = "path/to/your/file.txt"
      iex> data = LineReminder.DataDetailer.transform(file_path)

  """
  @spec transform(String.t()) :: {:ok, [map()]} | {:error, String.t()}
  def transform(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.replace("\uFEFF", "")
        |> String.split("\n", trim: true)
        |> Enum.map(&to_map/1)

      {:error, reason} ->
        {:error, "Error reading file: #{reason}"}
    end
  end

  defp to_map(line) do
    line
    |> String.replace("\r", "")
    |> String.split("\t")
    |> Enum.chunk_every(2)
    |> Enum.map(&build_map/1)
  end

  defp build_map([date, chapter]) do
    %{
      name: chapter,
      date: parse_date(date),
      status: "set"
    }
  end

  defp parse_date(date_str) do
    [year, month, day] =
      date_str
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    Date.new!(year, month, day)
  end
end
