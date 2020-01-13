defmodule Bob do
  def hey(input) do
    string = String.trim(input)

    cond do
      nothing?(string) ->
        "Fine. Be that way!"

      asking_yelling?(string) ->
        "Calm down, I know what I'm doing!"

      asking?(string) ->
        "Sure."

      yelling?(string) ->
        "Whoa, chill out!"

      true ->
        "Whatever."
    end
  end

  defp nothing?(string), do: string == ""
  defp yelling?(string), do: string == String.upcase(string) and string != String.downcase(string)
  defp asking?(string), do: String.ends_with?(string, "?")
  defp asking_yelling?(string), do: yelling?(string) && asking?(string)
end
