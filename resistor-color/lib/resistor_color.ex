defmodule ResistorColor do
  @moduledoc false

  @resistor_colors_codes %{
    "black" => 0,
    "brown" => 1,
    "red" => 2,
    "orange" => 3,
    "yellow" => 4,
    "green" => 5,
    "blue" => 6,
    "violet" => 7,
    "grey" => 8,
    "white" => 9
  }

  @spec colors() :: list(String.t())
  def colors do
    Enum.to_list(@resistor_colors_codes)
    |> Enum.sort(fn {_, v1}, {_, v2} -> v1 < v2 end)
    |> Enum.map(fn {k, _} -> k end)
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    Map.get(@resistor_colors_codes, color)
  end
end
