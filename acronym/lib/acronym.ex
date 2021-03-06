defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    String.split(string, ~r/\s|_|-|[a-z](?=[A-Z])/)
    |> Enum.map(&String.at(&1, 0))
    |> Enum.filter(&(!is_nil(&1)))
    |> to_string()
    |> String.upcase()
  end
end
