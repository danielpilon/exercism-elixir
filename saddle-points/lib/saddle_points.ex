defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> rows_stream()
    |> Enum.to_list()
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> columns_stream()
    |> Enum.to_list()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    mins = str |> rows_stream() |> min_by_rows()
    maxs = str |> columns_stream() |> max_by_columns()

    MapSet.intersection(mins, maxs) |> Enum.to_list()
  end

  defp min_by_rows(rows) do
    rows
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index()
    |> Stream.flat_map(&max_in_row/1)
    |> MapSet.new()
  end

  defp max_by_columns(columns) do
    columns
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index()
    |> Stream.flat_map(&min_in_column/1)
    |> MapSet.new()
  end

  defp rows_stream(str) do
    str
    |> String.split("\n")
    |> Stream.map(&to_numbers/1)
  end

  defp columns_stream(str) do
    str
    |> rows()
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
  end

  defp max_in_row({numbers, row}) do
    {max, _column} =
      numbers
      |> Enum.max_by(&extract_number/1)

    numbers
    |> Stream.filter(&(extract_number(&1) === max))
    |> Stream.map(fn {_number, column} -> {row, column} end)
  end

  defp min_in_column({numbers, column}) do
    {min, _row} =
      numbers
      |> Enum.min_by(&extract_number/1)

    numbers
    |> Stream.filter(&(extract_number(&1) === min))
    |> Stream.map(fn {_number, row} -> {row, column} end)
  end

  defp extract_number({number, _}), do: number

  defp to_numbers(str) do
    str
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end
