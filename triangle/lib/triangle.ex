defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  defguard triangle_inequality(a, b, c) when a + b <= c or a + c <= b or b + c <= a
  defguard negative_side(a, b, c) when a <= 0 or b <= 0 or c <= 0
  defguard equal_sides(a, b, c) when a == b and b == c

  defguard two_equal_sides(a, b, c)
           when (a == b and b != c) or (a == c and c != b) or (b == c and c != a)

  defguard no_equal_sides(a, b, c) when a != b and b != c

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when negative_side(a, b, c), do: {:error, "all side lengths must be positive"}

  def kind(a, b, c) when triangle_inequality(a, b, c),
    do: {:error, "side lengths violate triangle inequality"}

  def kind(a, b, c) when equal_sides(a, b, c), do: {:ok, :equilateral}
  def kind(a, b, c) when two_equal_sides(a, b, c), do: {:ok, :isosceles}
  def kind(a, b, c) when no_equal_sides(a, b, c), do: {:ok, :scalene}
end
