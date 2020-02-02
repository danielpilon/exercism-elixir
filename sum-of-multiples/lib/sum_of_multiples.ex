defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.reduce(0, &sum_multiples(&1, factors, &2))
  end

  defp sum_multiples(_, [], sum), do: sum
  defp sum_multiples(number, [head | _], sum) when rem(number, head) == 0, do: sum + number
  defp sum_multiples(number, [_ | tail], sum), do: sum_multiples(number, tail, sum)
end
