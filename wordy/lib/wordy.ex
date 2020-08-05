defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer("What is " <> sentence),
    do:
      sentence
      |> String.split(~r/[^-?0-9]+|\?/, trim: true, include_captures: true)
      |> Enum.map(&parse_term/1)
      |> eval()

  def answer(_sentence), do: raise(ArgumentError)

  defp parse_term("?"), do: ""
  defp parse_term(" plus "), do: fn x, y -> x + y end
  defp parse_term(" minus "), do: fn x, y -> x - y end
  defp parse_term(" multiplied by "), do: fn x, y -> x * y end
  defp parse_term(" divided by "), do: fn x, y -> div(x, y) end
  defp parse_term(digit), do: digit |> String.to_integer()

  defp eval([initial | rest]),
    do:
      rest
      |> Enum.chunk_every(2, 2, :discard)
      |> Enum.reduce(initial, fn [op, number], acc -> op.(acc, number) end)
end
