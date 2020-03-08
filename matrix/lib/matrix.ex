defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input), do: input |> String.split("\n") |> Enum.map(&row_to_integer/1)

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix), do: matrix |> Enum.map_join("\n", &row_to_string/1)

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix), do: matrix

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index), do: matrix |> Enum.at(index)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix), do: matrix |> List.zip() |> Enum.map(&Tuple.to_list/1)

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index), do: matrix |> Enum.map(&cell_at(&1, index))

  defp row_to_integer(row), do: row |> String.split() |> Enum.map(&String.to_integer/1)
  defp row_to_string(row), do: row |> Enum.map_join(" ", &Integer.to_string/1)
  defp cell_at(row, index), do: row |> Enum.at(index)
end
