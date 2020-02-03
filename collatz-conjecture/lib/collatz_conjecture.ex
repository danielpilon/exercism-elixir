defmodule CollatzConjecture do
  import Integer

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input), do: calc(input, 0)
  defp calc(input, _) when not is_number(input) or input <= 0, do: raise(FunctionClauseError)
  defp calc(1, steps), do: steps
  defp calc(input, steps) when is_even(input), do: calc(div(input, 2), steps + 1)
  defp calc(input, steps), do: calc(3 * input + 1, steps + 1)
end
