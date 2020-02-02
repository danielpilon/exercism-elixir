defmodule Pangram do
  @alphabet ?a..?z |> Enum.to_list()

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
      |> is_pangram?()

  defp is_pangram?(chars), do: @alphabet -- chars == []
end
