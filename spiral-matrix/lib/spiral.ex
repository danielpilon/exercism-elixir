defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(dimension), do: spiral(1, dimension, dimension)

  defp spiral(_start, _row, 0), do: [[]]

  defp spiral(start, row, column) do
    top = start..(start + column - 1) |> Enum.to_list()
    bottom = spiral(start + column, column, row - 1) |> rotate
    [top | bottom]
  end

  defp rotate(matrix), do: matrix |> Enum.reverse() |> transpose()

  defp transpose(matrix), do: matrix |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
end
