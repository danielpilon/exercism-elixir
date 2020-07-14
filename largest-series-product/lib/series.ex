defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, 0), do: 1

  def largest_product(number_string, size) when byte_size(number_string) < size or size < 0,
    do: raise(ArgumentError)

  def largest_product(number_string, size),
    do:
      number_string
      |> to_integers()
      |> Stream.chunk_every(size, 1, :discard)
      |> Stream.map(&multiply/1)
      |> Enum.max()

  defp to_integers(number_string),
    do:
      number_string
      |> String.graphemes()
      |> Stream.map(&String.to_integer/1)

  defp multiply(enumerable),
    do:
      enumerable
      |> Enum.reduce(1, fn x, acc -> x * acc end)
end
