defmodule Prime do
  defguard is_even(number) when number > 1 and rem(number, 2) === 0

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count < 1, do: raise("Number out of bounds")

  def nth(count) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.filter(&is_prime?/1)
    |> Stream.take(count)
    |> Enum.to_list()
    |> List.last()
  end

  defp is_prime?(2), do: true
  defp is_prime?(number) when is_even(number), do: false
  defp is_prime?(number), do: is_prime?(number, 3)

  defp is_prime?(number, divisor) when number < divisor * divisor, do: true
  defp is_prime?(number, divisor) when rem(number, divisor) === 0, do: false
  defp is_prime?(number, divisor), do: is_prime?(number, divisor + 2)
end
