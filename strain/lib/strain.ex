defmodule Strain do
  defp filter([head | tail], predicate) do
    case predicate.(head) do
      true ->
        [head | filter(tail, predicate)]

      false ->
        filter(tail, predicate)
    end
  end

  defp filter([], _predicate), do: []

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun), do: filter(list, &fun.(&1))

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun), do: filter(list, &(!fun.(&1)))
end
