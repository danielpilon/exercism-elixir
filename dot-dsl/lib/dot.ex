defmodule Dot do
  defmacro graph(do: ast),
    do:
      ast
      |> to_lines
      |> Enum.reduce(%Graph{}, &process/2)
      |> sort()
      |> Macro.escape()

  defp to_lines({:__block__, _, lines}), do: lines
  defp to_lines(line), do: [line]

  defp process({:--, _, [{from, _, _}, {to, _, props}]}, graph),
    do: %Graph{graph | edges: [{from, to, parse_props(props)} | graph.edges]}

  defp process({:graph, _, props}, graph),
    do: %Graph{graph | attrs: parse_props(props) ++ graph.attrs}

  defp process({node, _, props}, graph) when is_atom(node),
    do: %Graph{graph | nodes: [{node, parse_props(props)} | graph.nodes]}

  defp process(_line, _graph), do: raise(ArgumentError)

  defp sort(graph),
    do: %Graph{
      nodes: Enum.sort(graph.nodes),
      edges: Enum.sort(graph.edges),
      attrs: Enum.sort(graph.attrs)
    }

  defp parse_props(nil), do: []

  defp parse_props([props]),
    do: if(Keyword.keyword?(props), do: props, else: raise(ArgumentError))

  defp parse_props(_props),
    do: raise(ArgumentError)
end
