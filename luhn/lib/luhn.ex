defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number),
    do:
      number
      |> String.graphemes()
      |> parse_number()
      |> do_valid?()

  defp do_valid?({:error, _numbers}), do: false
  defp do_valid?({:ok, numbers}) when length(numbers) <= 1, do: false

  defp do_valid?({:ok, numbers}),
    do:
      numbers
      |> double_numbers()
      |> checksum()

  def parse_number(numbers, acc \\ [])
  def parse_number([], acc), do: {:ok, acc}

  def parse_number([char | rest], acc) when char == " ",
    do: parse_number(rest, acc)

  def parse_number([char | rest], acc) do
    with {number, _rest} <- Integer.parse(char) do
      parse_number(rest, [number | acc])
    else
      err -> {err, []}
    end
  end

  defp double_numbers([first, second | numbers]),
    do: [first, double_number(second) | double_numbers(numbers)]

  defp double_numbers(numbers), do: numbers

  defp double_number(number) when number > 4, do: number * 2 - 9
  defp double_number(number), do: number * 2

  defp checksum(numbers),
    do:
      numbers
      |> Enum.sum()
      |> rem(10)
      |> Kernel.==(0)
end
