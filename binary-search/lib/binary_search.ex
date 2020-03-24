defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    size = numbers |> tuple_size()
    numbers |> Tuple.to_list() |> do_search(key, 0, size)
  end

  defp do_search(_, _, start, finish) when finish < start, do: :not_found

  defp do_search(numbers, key, start, finish) do
    mid = Kernel.+(finish, start) |> div(2)

    case Enum.at(numbers, mid) do
      ^key -> {:ok, mid}
      n when key < n -> numbers |> do_search(key, 0, mid - 1)
      n when key > n -> numbers |> do_search(key, mid + 1, finish)
    end
  end
end
