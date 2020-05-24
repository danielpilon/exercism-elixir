defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(number),
    do:
      div(number, 2)
      |> aliquot_sum(number)
      |> classify(number)

  defp classify(aliquot_sum, number) when aliquot_sum < number, do: {:ok, :deficient}
  defp classify(aliquot_sum, number) when aliquot_sum > number, do: {:ok, :abundant}
  defp classify(_aliquot_sum, _number), do: {:ok, :perfect}

  defp aliquot_sum(factor, number, sum \\ 0)

  defp aliquot_sum(0, _number, sum), do: sum

  defp aliquot_sum(factor, number, sum) when rem(number, factor) == 0,
    do: aliquot_sum(factor - 1, number, sum + factor)

  defp aliquot_sum(factor, number, sum), do: aliquot_sum(factor - 1, number, sum)
end
