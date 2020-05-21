defmodule Hexadecimal do
  use Bitwise

  @conversion %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "a" => 10,
    "b" => 11,
    "c" => 12,
    "d" => 13,
    "e" => 14,
    "f" => 15
  }
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex),
    do:
      hex
      |> String.downcase()
      |> String.graphemes()
      |> do_to_decimal()

  defp do_to_decimal(digits, acc \\ 0)
  defp do_to_decimal([], acc), do: acc

  defp do_to_decimal([digit | rest], acc) when is_map_key(@conversion, digit),
    do: do_to_decimal(rest, acc <<< 4 ||| @conversion[digit])

  defp do_to_decimal(_digits, _acc), do: 0
end
