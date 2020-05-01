defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    string
    |> to_charlist()
    |> Enum.map(&(&1 - 48))
    |> Enum.reverse()
    |> do_to_decimal()
  end

  defp do_to_decimal(binary, counter \\ 1, acc \\ 0)
  defp do_to_decimal([], _counter, acc), do: acc
  defp do_to_decimal([0 | rest], counter, acc), do: do_to_decimal(rest, counter * 2, acc)

  defp do_to_decimal([digit | rest], counter, acc) when digit in [0, 1],
    do: do_to_decimal(rest, counter * 2, acc + counter)

  defp do_to_decimal(_binary, _counter, _acc), do: 0
end
