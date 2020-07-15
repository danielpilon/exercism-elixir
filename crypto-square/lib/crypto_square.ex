defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(str), do: str |> normalize |> to_graphemes_and_size |> to_square

  defp normalize(str), do: str |> String.replace(~r/[\W_]+/, "") |> String.downcase()

  defp to_graphemes_and_size(str), do: str |> String.graphemes() |> with_column_size()

  defp with_column_size(enumerable),
    do:
      {enumerable,
       enumerable
       |> length()
       |> :math.sqrt()
       |> Float.ceil()
       |> trunc}

  defp to_square({enumerable, column_size}),
    do:
      enumerable
      |> Enum.chunk_every(column_size, column_size, Stream.cycle([""]))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.join(" ")
end
