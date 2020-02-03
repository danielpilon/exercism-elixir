defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list

  def flatten(list), do: flatten(list, [])

  defp flatten([], acc), do: acc

  defp flatten([[] | r], acc), do: flatten(r, acc)

  defp flatten([nil | r], acc), do: flatten(r, acc)

  defp flatten([h | r], acc) when is_list(h), do: flatten(h, flatten(r, acc))

  defp flatten([h | r], acc), do: [h | flatten(r, acc)]
end
