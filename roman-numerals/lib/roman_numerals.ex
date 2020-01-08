defmodule RomanNumerals do
  @symbols [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]
  defp roman_sequence(roman, times), do: String.duplicate(roman, times)
  defp symbols_less_than(number), do: Enum.filter(@symbols, &(&1 > number))

  defp numeral(_, [], result), do: result

  defp numeral(number, [{arabic, roman} | _], result) when number == arabic,
    do: result <> roman

  defp numeral(number, [{arabic, _} | tail], result) when arabic > number,
    do: numeral(number, tail, result)

  defp numeral(number, [{arabic, roman} | tail], result),
    do: numeral(rem(number, arabic), tail, result <> roman_sequence(roman, div(number, arabic)))

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    numeral(number, symbols_less_than(number), "")
  end
end
