defmodule Say do
  @said_numbers %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety",
    100 => "hundred",
    1_000 => "thousand",
    1_000_000 => "million",
    1_000_000_000 => "billion"
  }

  defguard in_range(number) when number >= 0 and number <= 999_999_999_999

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(0), do: {:ok, "zero"}
  def in_english(number) when in_range(number), do: {:ok, number |> in_full}
  def in_english(number), do: {:error, "number is out of range"}

  defp in_full(number) when number < 20, do: @said_numbers[number]

  defp in_full(number) when number < 100 do
    rem = rem(number, 10)
    current = number - rem

    case rem do
      0 -> "#{@said_numbers[current]}"
      rem -> "#{@said_numbers[current]}-#{@said_numbers[rem]}"
    end
  end

  defp in_full(number) when number >= 100 and number < 1_000, do: in_full(number, 100)
  defp in_full(number) when number >= 1_000 and number < 1_000_000, do: in_full(number, 1_000)

  defp in_full(number) when number >= 1_000_000 and number < 1_000_000_000,
    do: in_full(number, 1_000_000)

  defp in_full(number) when number >= 1_000_000_000 and number < 1_000_000_000_000,
    do: in_full(number, 1_000_000_000)

  defp in_full(number, divisor) do
    rem = rem(number, divisor)
    current = div(number - rem, divisor)

    "#{in_full(current)} #{@said_numbers[divisor]} #{in_full(rem)}" |> String.trim()
  end
end
