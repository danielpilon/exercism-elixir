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
      |> Enum.map_join(&process/1)
      |> enclose_li
      |> enclose_strong
      |> enclose_em

  defp process("#" <> text), do: parse_header(text)
  defp process("* " <> text), do: "<li>#{text}</li>"
  defp process(text), do: "<p>#{text}</p>"

  defp parse_header(header, level \\ 1)
  defp parse_header(" " <> rest, level), do: "<h#{level}>#{rest}</h#{level}>"
  defp parse_header("#" <> rest, level), do: parse_header(rest, level + 1)

  defp enclose_strong(text), do: text |> String.replace(~r/__(.*?)__/, "<strong>\\1</strong>")
  defp enclose_em(text), do: text |> String.replace(~r/_(.*?)_/, "<em>\\1</em>")
  defp enclose_li(text), do: text |> String.replace(~r/(<li>.*<\/li>)/, "<ul>\\1</ul>")
end
