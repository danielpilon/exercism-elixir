defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) === length(strand2) do
    count =
      strand1
      |> Enum.zip(strand2)
      |> Enum.filter(&is_mutation?/1)
      |> Enum.count()

    {:ok, count}
  end

  def hamming_distance(_, _), do: {:error, "Lists must be the same length"}

  defp is_mutation?({nucleotide1, nucleotide2}), do: nucleotide1 !== nucleotide2
end
