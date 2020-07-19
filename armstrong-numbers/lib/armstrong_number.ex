defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number), do: number |> armstrong() == number

  defp armstrong(number) do
    digits = number |> Integer.digits()
    length = digits |> length
    digits |> Enum.reduce(0, &pow_sum(&1, length, &2))
  end

  defp pow_sum(number, exp, sum), do: number |> :math.pow(exp) |> trunc() |> Kernel.+(sum)
end
