defmodule Connect do
  @moves [{0, -1}, {1, -1}, {1, 0}, {0, 1}, {-1, 1}, {-1, 0}]

  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    hex = board |> hex()

    cond do
      black_wins?(hex) -> :black
      white_wins?(hex) -> :white
      true -> :none
    end
  end

  defp hex(board) do
    hex = %{
      blacks: %{},
      whites: %{},
      height: board |> length |> Kernel.-(1),
      width: board |> hd |> String.length() |> Kernel.-(1)
    }

    board
    |> Stream.with_index()
    |> Stream.flat_map(&coordinates/1)
    |> build_hex(hex)
  end

  defp coordinates({row, row_index}),
    do:
      row
      |> to_charlist()
      |> Stream.with_index()
      |> Stream.map(fn {char, column_index} -> {{row_index, column_index}, char} end)

  defp build_hex(coordinates, hex),
    do: coordinates |> vertices(hex) |> white_adjacents() |> black_adjacents()

  defp vertices(coordinates, hex),
    do: coordinates |> Enum.reduce(hex, &put_vertex/2)

  defp white_adjacents(%{whites: whites} = hex),
    do: %{hex | whites: Map.new(whites, fn {key, _value} -> {key, adjacents(key, whites)} end)}

  defp black_adjacents(%{blacks: blacks} = hex),
    do: %{hex | blacks: Map.new(blacks, fn {key, _value} -> {key, adjacents(key, blacks)} end)}

  defp adjacents({x, y}, whites) do
    @moves
    |> Stream.map(fn {move_x, move_y} -> {move_x + x, move_y + y} end)
    |> Stream.filter(&Map.has_key?(whites, &1))
  end

  defp put_vertex({coordinate, ?X}, %{blacks: blacks} = hex),
    do: %{hex | blacks: Map.put(blacks, coordinate, [])}

  defp put_vertex({coordinate, ?O}, %{whites: whites} = hex),
    do: %{hex | whites: Map.put(whites, coordinate, [])}

  defp put_vertex(_coordinate, hex), do: hex

  defp black_wins?(%{blacks: blacks, width: width}) do
    blacks
    |> Stream.filter(fn {{_, y}, _} -> y == 0 end)
    |> Stream.flat_map(fn {start, _edges} -> end_of_path(start, blacks) end)
    |> Enum.any?(fn {_, y} -> y == width end)
  end

  defp white_wins?(%{whites: whites, height: height}) do
    whites
    |> Stream.filter(fn {{x, _}, _} -> x == 0 end)
    |> Stream.flat_map(fn {start, _edges} -> end_of_path(start, whites) end)
    |> Enum.any?(fn {x, _} -> x == height end)
  end

  defp end_of_path(vertex, graph, seen \\ []) do
    Enum.reduce(graph[vertex], [vertex | seen], fn v, acc ->
      case Enum.member?(acc, v) do
        true -> acc
        false -> end_of_path(v, graph, acc)
      end
    end)
  end
end
