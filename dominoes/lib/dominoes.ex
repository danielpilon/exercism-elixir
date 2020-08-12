defmodule Dominoes do
  def chain?([]), do: true
  def chain?([stone | stones]), do: chain?(stone, stone, stones)

  defp chain?({half, _}, {_, half}, []), do: true

  defp chain?(first_stone, {_, curr_half}, rest) do
    Enum.any?(rest, fn
      {^curr_half, next_half} = next_stone ->
        chain?(first_stone, {curr_half, next_half}, List.delete(rest, next_stone))

      {next_half, ^curr_half} = next_stone ->
        chain?(first_stone, {curr_half, next_half}, List.delete(rest, next_stone))

      _next_stone ->
        false
    end)
  end
end
