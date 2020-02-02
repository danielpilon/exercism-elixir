defmodule Isogram do
  @alphabet MapSet.new(?a..?z)

  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.downcase()
    |> to_charlist()
    |> Enum.filter(&MapSet.member?(@alphabet, &1))
    |> uniq?()
  end

  defp uniq?(chars), do: Enum.uniq(chars) == chars
end
