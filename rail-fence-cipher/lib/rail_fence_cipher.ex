defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails),
    do:
      str
      |> String.graphemes()
      |> cipher(rails)
      |> Enum.join()

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str

  def decode(str, rails),
    do:
      str
      |> String.graphemes()
      |> decipher(rails)
      |> Enum.map_join(fn {_, char} -> char end)

  defp cipher(graphemes, rails),
    do:
      for(
        rail <- 1..rails,
        {^rail, char} <-
          rails
          |> zig_zag_pattern()
          |> Stream.zip(graphemes),
        do: char
      )

  defp decipher(graphemes, rails),
    do:
      rails
      |> indexes(length(graphemes))
      |> Stream.zip(graphemes)
      |> Enum.sort()

  defp indexes(rails, length),
    do:
      for(
        rail <- 1..rails,
        {^rail, index} <-
          rails
          |> zig_zag_pattern()
          |> Stream.with_index()
          |> Stream.take(length),
        do: index
      )

  defp zig_zag_pattern(rails),
    do:
      1..(rails - 1)
      |> Stream.concat(rails..2)
      |> Stream.cycle()
end
