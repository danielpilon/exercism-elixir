defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    la = length(a)
    lb = length(b)

    cond do
      la == lb and same_sequence?(a, b) -> :equal
      lb > la and sublist?(a, b) -> :sublist
      la > lb and sublist?(b, a) -> :superlist
      true -> :unequal
    end
  end

  def sublist?(_, []), do: false
  def sublist?(a, b = [_ | bt]), do: same_sequence?(a, b) || sublist?(a, bt)

  def same_sequence?([], _), do: true
  def same_sequence?(_, []), do: false
  def same_sequence?([ah | at], [bh | bt]) when ah === bh, do: same_sequence?(at, bt)
  def same_sequence?(_, _), do: false
end
