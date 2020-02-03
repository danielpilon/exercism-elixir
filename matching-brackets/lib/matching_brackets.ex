defmodule MatchingBrackets do
  @closing_brackets [?}, ?], ?)]

  @opening_brackets %{
    ?{ => ?},
    ?[ => ?],
    ?( => ?)
  }

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> to_charlist()
    |> check_brackets([])
  end

  defp check_brackets([], s), do: length(s) == 0

  defp check_brackets([h | t], [hs | ts]) when h in @closing_brackets and h == hs,
    do: check_brackets(t, ts)

  defp check_brackets([h | _], _) when h in @closing_brackets, do: false

  defp check_brackets([h | t], s) when is_map_key(@opening_brackets, h),
    do: check_brackets(t, [Map.get(@opening_brackets, h) | s])

  defp check_brackets([_ | t], s), do: check_brackets(t, s)
end
