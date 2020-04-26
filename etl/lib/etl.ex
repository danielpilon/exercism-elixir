defmodule ETL do
  import String, only: [downcase: 1]

  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input),
    do:
      input
      |> Enum.reduce(%{}, &transform/2)

  defp transform({key, values}, acc),
    do:
      acc
      |> put(key, values)

  defp put(acc, _key, []), do: acc

  defp put(acc, key, [value | rest]),
    do:
      acc
      |> Map.put(value |> downcase(), key)
      |> put(key, rest)
end
