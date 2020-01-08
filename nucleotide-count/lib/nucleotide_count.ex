defmodule NucleotideCount do

  @initial_histogram %{?A => 0, ?T => 0, ?C => 0, ?G => 0}

  defp update_histrogram(nucleotide, histogram) do
    %{ histogram | nucleotide => Map.get(histogram, nucleotide) + 1}
  end

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    strand
    |> Stream.filter(fn n -> n == nucleotide end)
    |> Enum.count()
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
    strand
    |> Enum.reduce(@initial_histogram, &update_histrogram/2)
  end
end
