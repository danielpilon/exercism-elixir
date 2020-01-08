defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna('G'), do: 'C'
  def to_rna('C'), do: 'G'
  def to_rna('T'), do: 'A'
  def to_rna('A'), do: 'U'

  def to_rna(dna) do
    dna
    |> Enum.map(fn l -> RnaTranscription.to_rna([l]) end)
    |> List.to_charlist()
  end
end
