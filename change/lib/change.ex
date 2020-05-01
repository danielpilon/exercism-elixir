defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """
  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_coins, 0), do: {:ok, []}

  def generate(coins, target) do
    coins
    |> Enum.filter(&Kernel.<=(&1, target))
    |> do_generate(target)
  end

  def do_generate(coins, target) do
    1..target
    |> Enum.reduce(%{0 => []}, &do_generate(coins, &1, &2))
    |> determine_change(target)
  end

  defp do_generate(coins, target, changes) do
    coins
    |> Enum.filter(&changes[target - &1])
    |> Enum.map(&[&1 | changes[target - &1]])
    |> Enum.min_by(&length(&1), fn -> nil end)
    |> update_changes(target, changes)
  end

  defp update_changes(nil, _target, changes), do: changes
  defp update_changes(coins, target, changes), do: Map.put(changes, target, coins)

  defp determine_change(changes, target) when is_map_key(changes, target),
    do: {:ok, changes[target]}

  defp determine_change(_changes, _target), do: {:error, "cannot change"}
end
