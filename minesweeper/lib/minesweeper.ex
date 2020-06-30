defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate([]), do: []

  def annotate(board) do
    board
    |> Stream.with_index()
    |> Stream.flat_map(&coordinates/1)
    |> Enum.into(%{})
    |> annotate_mines
    |> to_board()
  end

  defp to_board(coordinates) do
    coordinates
    |> Enum.group_by(fn {{row, _}, _} -> row end, fn {_, value} -> value end)
    |> Enum.map(fn {_, row} -> row |> to_string end)
  end

  defp annotate_mines(coordinates) do
    coordinates
    |> Enum.reduce(coordinates, &adjacent_bombs/2)
  end

  defp adjacent_bombs({_, ?*}, coordinates), do: coordinates

  defp adjacent_bombs({{row, column} = coordinate, _value}, coordinates) do
    coordinates
    |> Map.get(coordinate)
    |> step(coordinates[{row - 1, column}])
    |> step(coordinates[{row - 1, column + 1}])
    |> step(coordinates[{row - 1, column - 1}])
    |> step(coordinates[{row, column - 1}])
    |> step(coordinates[{row, column + 1}])
    |> step(coordinates[{row + 1, column - 1}])
    |> step(coordinates[{row + 1, column}])
    |> step(coordinates[{row + 1, column + 1}])
    |> update_coordinates(coordinates, coordinate)
  end

  defp step(?\s, ?*), do: ?1
  defp step(bombs, ?*), do: bombs + 1
  defp step(bombs, _), do: bombs

  defp update_coordinates(bombs, coordinates, coordinate),
    do: Map.put(coordinates, coordinate, bombs)

  defp coordinates({row, row_index}) do
    row
    |> to_charlist()
    |> Stream.with_index()
    |> Stream.map(fn {char, column_index} -> {{row_index, column_index}, char} end)
  end
end
