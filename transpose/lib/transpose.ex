defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    input
    |> String.split("\n")
    |> convert_to_graphemes()
    |> Enum.zip()
    |> Enum.map_join("\n", &join/1)
    |> String.trim()
  end

  defp convert_to_graphemes(input),
    do:
      {input,
       input
       |> longest()}
      |> adjust_sizes()
      |> Enum.map(&String.graphemes/1)

  defp longest(input),
    do:
      input
      |> Enum.map(&String.length/1)
      |> Enum.max()

  defp adjust_sizes({input, size}),
    do:
      input
      |> Enum.map(&String.pad_trailing(&1, size))

  defp join(string),
    do:
      Tuple.to_list(string)
      |> Enum.join()
end
