defmodule AllYourBase do
  defguardp invalid_base(base) when base < 2
  defguardp invalid_digit(digit, base) when digit < 0 or digit >= base

  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: list
  def convert([], _base_a, _base_b), do: nil
  def convert(_digits, base_a, _base_b) when invalid_base(base_a), do: nil
  def convert(_digits, _base_a, base_b) when invalid_base(base_b), do: nil

  def convert(digits, base_a, base_b),
    do:
      digits
      |> Enum.reverse()
      |> Enum.with_index()
      |> from_base(base_a)
      |> to_base(base_b)

  defp from_base(digits, base, acc \\ 0)
  defp from_base([], _base, acc), do: acc

  defp from_base([{digit, _power} | _rest], base, _acc) when invalid_digit(digit, base),
    do: nil

  defp from_base([{digit, power} | rest], base, acc),
    do: from_base(rest, base, acc + digit * pow(base, power))

  defp to_base(number, base, acc \\ [])

  defp to_base(nil, _base, _acc), do: nil
  defp to_base(0, _base, acc) when length(acc) == 0, do: [0]
  defp to_base(0, _base, acc), do: acc

  defp to_base(number, base, acc) do
    to_base(div(number, base), base, [rem(number, base) | acc])
  end

  defp pow(n, k), do: pow(n, k, 1)
  defp pow(_, 0, acc), do: acc
  defp pow(n, k, acc), do: pow(n, k - 1, n * acc)
end
