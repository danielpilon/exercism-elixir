defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num),
    do:
      [1]
      |> Stream.iterate(&[1 | next_row(&1)])
      |> Enum.take(num)

  defp next_row(triangle),
    do:
      triangle
      |> Stream.chunk_every(2, 1)
      |> Enum.map(&Enum.sum/1)
end
