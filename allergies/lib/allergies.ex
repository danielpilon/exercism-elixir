defmodule Allergies do
  use Bitwise

  @allergies %{
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags), do: do_list(flags)

  defp do_list(flags, next \\ 1, acc \\ [])
  defp do_list(_flags, 256, acc), do: acc |> Enum.reverse()

  defp do_list(flags, next, acc) when (flags &&& next) > 0,
    do: do_list(flags, next <<< 1, [@allergies[next] | acc])

  defp do_list(flags, next, acc), do: do_list(flags, next <<< 1, acc)

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item), do: list(flags) |> Enum.member?(item)
end
