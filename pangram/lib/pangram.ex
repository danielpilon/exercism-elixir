defmodule Pangram do
  @alphabet MapSet.new(?a..?z)
  @ascii_letters_size 26

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """
  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence),
    do:
      sentence
      |> String.downcase()
      |> to_charlist()
      |> MapSet.new()
      |> MapSet.intersection(@alphabet)
      |> MapSet.size() == @ascii_letters_size
end
