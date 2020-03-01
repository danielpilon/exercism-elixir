defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m),
    do:
      m
      |> String.split("\n")
      |> Enum.map_join(&process(&1))
      |> enclose_li
      |> enclose_strong
      |> enclose_em

  defp process("#" <> t), do: parse_header(t)
  defp process("* " <> t), do: "<li>" <> t <> "</li>"
  defp process(t), do: "<p>" <> t <> "</p>"

  defp parse_header(t, h \\ 1)
  defp parse_header(" " <> t, h), do: "<h#{h}>#{t}</h#{h}>"
  defp parse_header("#" <> t, h), do: parse_header(t, h + 1)

  defp enclose_strong(t), do: t |> String.replace(~r/__(.*?)__/, "<strong>\\1</strong>")
  defp enclose_em(t), do: t |> String.replace(~r/_(.*?)_/, "<em>\\1</em>")
  defp enclose_li(t), do: t |> String.replace(~r/(<li>.*<\/li>)/, "<ul>\\1</ul>")
end
