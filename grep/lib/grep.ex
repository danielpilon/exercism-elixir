defmodule Grep do
  @flag_to_modifiers %{
    "-n" => :line_numbers,
    "-l" => :only_names,
    "-i" => :case_insensitive,
    "-v" => :invert,
    "-x" => :entire_line
  }

  defstruct files: [], matcher: nil, modifiers: MapSet.new(), matches: []

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files), do: pattern |> init(files, flags) |> match() |> print()

  defp init(pattern, file_names, flags) do
    modifiers =
      flags |> Enum.map(&to_modifier/1) |> Enum.into(MapSet.new()) |> with_single_file(file_names)

    matcher = pattern |> build_matcher(modifiers)

    %Grep{files: file_names, modifiers: modifiers, matcher: matcher}
  end

  defp with_single_file(modifiers, [_single]), do: modifiers |> MapSet.put(:single_file)
  defp with_single_file(modifiers, _multiple), do: modifiers

  defp match(%Grep{files: files, matcher: matcher} = grep) do
    matches = files |> Stream.flat_map(&match(&1, matcher))
    %Grep{grep | matches: matches}
  end

  defp match(file_name, matcher) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.with_index(1)
    |> Stream.filter(fn {line, _} -> matcher.(line) end)
    |> Stream.map(&to_match(&1, file_name))
  end

  defp to_match({line, number}, file_name), do: %{name: file_name, line: line, number: number}

  defp to_modifier(flag), do: @flag_to_modifiers[flag]

  defp build_matcher(pattern, flags) do
    pattern = if flags |> MapSet.member?(:entire_line), do: "^#{pattern}$", else: pattern
    opts = if flags |> MapSet.member?(:case_insensitive), do: [:caseless], else: []

    regex = Regex.compile!(pattern, opts)

    if flags |> MapSet.member?(:invert) do
      fn line -> not Regex.match?(regex, line) end
    else
      fn line -> Regex.match?(regex, line) end
    end
  end

  defp print(%Grep{matches: matches, modifiers: modifiers}) do
    lines =
      cond do
        MapSet.member?(modifiers, :only_names) ->
          matches |> Stream.map(&[&1.name]) |> Stream.uniq()

        MapSet.member?(modifiers, :line_numbers) ->
          matches |> Stream.map(&print_line_number(&1, modifiers))

        true ->
          matches |> Stream.map(&print_line(&1, modifiers))
      end

    lines |> Enum.map_join(&(Enum.join(&1, ":") <> "\n"))
  end

  defp print_line_number(%{line: line, name: name, number: number}, modifiers) do
    if MapSet.member?(modifiers, :single_file) do
      [number, line]
    else
      [name, number, line]
    end
  end

  defp print_line(%{line: line, name: name}, modifiers) do
    if MapSet.member?(modifiers, :single_file) do
      [line]
    else
      [name, line]
    end
  end
end
