defmodule WordCount do
  defp update_word_count(word, word_count) do
    Map.put(word_count, word, Map.get(word_count, word, 0) + 1)
  end

  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.split(~r/([^\w\-]|_)+/u, trim: true)
    |> Enum.reduce(%{}, &update_word_count/2)
  end
end
