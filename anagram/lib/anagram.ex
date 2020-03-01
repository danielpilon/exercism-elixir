defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    normalized_base = base |> String.downcase()

    candidates
    |> Enum.filter(&anagram?(&1, normalized_base))
    |> Enum.uniq()
  end

  defp build_frequency_map(words) do
    words
    |> to_charlist()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  defp anagram?(candidate, base) do
    normalized_candidate = candidate |> String.downcase()
    candidate_frequency_map = normalized_candidate |> build_frequency_map
    base_frequency_map = base |> build_frequency_map

    base_frequency_map === candidate_frequency_map && base !== normalized_candidate
  end
end
