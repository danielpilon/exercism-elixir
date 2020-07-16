defmodule Atbash do
  @plain 'abcdefghijklmnopqrstuvwxyz'
  @cipher 'zyxwvutsrqponmlkjihgfedcba'
  @plain_to_cipher @plain |> Enum.zip(@cipher) |> Enum.into(%{})
  @cipher_to_plain @cipher |> Enum.zip(@plain) |> Enum.into(%{})

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext),
    do: plaintext |> transform(@plain_to_cipher) |> Enum.chunk_every(5) |> Enum.join(" ")

  @spec decode(String.t()) :: String.t()
  def decode(cipher), do: cipher |> transform(@cipher_to_plain) |> List.to_string()

  defp transform(text, char_map),
    do: text |> normalize() |> to_charlist() |> Enum.map(&(char_map[&1] || &1))

  defp normalize(text), do: text |> String.replace(~r/[\W_]+/, "") |> String.downcase()
end
