defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1),
    do:
      min_factor..max_factor
      |> Stream.flat_map(&products(&1, &1..max_factor))
      |> Stream.filter(&palindrome?/1)
      |> Enum.group_by(
        fn {product, _factors} -> product end,
        fn {_product, factors} -> factors end
      )

  defp products(factor, range),
    do:
      range
      |> Stream.map(fn n -> {factor * n, [factor, n]} end)

  defp palindrome?({product, _factors}) do
    digits = Integer.digits(product)
    digits == Enum.reverse(digits)
  end
end
