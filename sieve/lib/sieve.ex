defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit),
    do:
      2..limit
      |> Enum.to_list()
      |> sieve()

  defp sieve(candidates, primes \\ [])
  defp sieve([], primes), do: primes |> Enum.reverse()

  defp sieve([prime | next], primes),
    do:
      next
      |> Enum.filter(&multiple?(&1, prime))
      |> sieve([prime | primes])

  defp multiple?(number, multiple), do: rem(number, multiple) > 0
end
