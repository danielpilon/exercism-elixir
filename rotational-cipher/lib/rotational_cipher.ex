defmodule RotationalCipher do
  defp rotate_char(char_code, shift) when char_code >= ?a and char_code <= ?z do
    rem(char_code + shift - ?a, 26) + ?a
  end

  defp rotate_char(char_code, shift) when char_code >= ?A and char_code <= ?Z do
    rem(char_code + shift - ?A, 26) + ?A
  end

  defp rotate_char(char_code, _) do
    char_code
  end

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    String.to_charlist(text)
    |> Enum.map(&rotate_char(&1, shift))
    |> List.to_string()
  end
end
