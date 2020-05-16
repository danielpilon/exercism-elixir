defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    pattern = List.duplicate('\s', letter - ?A + 1)

    ?A..letter
    |> Enum.map(&fill_line(&1, pattern))
    |> mirror_diamond()
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp fill_line(letter, pattern),
    do:
      pattern
      |> List.replace_at(letter - ?A, letter)
      |> mirror_line()

  defp mirror_line(half),
    do:
      half
      |> tl()
      |> Enum.reverse()
      |> Enum.concat(half)

  defp mirror_diamond(half), do: half ++ (half |> Enum.reverse() |> tl())
end
