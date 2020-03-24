defmodule IsbnVerifier do
  @valid_chars ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn),
    do:
      isbn
      |> String.replace(~r/[[:punct:]]/, "")
      |> do_isbn?()

  defp do_isbn?(isbn, multiplier \\ 10, acc \\ 0)
  defp do_isbn?(isbn, _, _) when length(isbn) != 10, do: false

  defp do_isbn?("", _, acc), do: rem(acc, 11) == 0

  defp do_isbn?("X", multiplier, acc), do: do_isbn?("", multiplier, acc + 10 * multiplier)

  defp do_isbn?(<<digit::binary-size(1), rest::binary>>, multiplier, acc)
       when digit in @valid_chars,
       do: do_isbn?(rest, multiplier - 1, acc + String.to_integer(digit) * multiplier)

  defp do_isbn?(_, _, _), do: false
end
