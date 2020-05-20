defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&build_frequency/1, max_concurrency: workers)
    |> Enum.reduce(%{}, fn {:ok, map}, acc -> Map.merge(acc, map, fn _k, x, y -> x + y end) end)
  end

  defp build_frequency(text) do
    text
    |> String.replace(~r/\P{L}+/u, "")
    |> String.downcase()
    |> String.graphemes()
    |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn x -> x + 1 end))
  end
end
