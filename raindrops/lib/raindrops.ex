defmodule Raindrops do
  @words [
    {3, "Pling"},
    {5, "Plang"},
    {7, "Plong"}
  ]

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    @words
    |> Enum.map(&convert(number, &1))
    |> Enum.filter(&(!is_nil(&1)))
    |> sound(number)
  end

  defp convert(number, {factor, word}) when rem(number, factor) == 0, do: word
  defp convert(number, _), do: nil

  defp sound([], number), do: number |> to_string()
  defp sound(sounds, _), do: Enum.join(sounds)
end
