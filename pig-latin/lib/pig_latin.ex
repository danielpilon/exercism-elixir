defmodule PigLatin do
  @vowels ["a", "e", "i", "o", "u"]
  @may_sound_like_vowel ["y", "x"]
  @may_sound_like_single_consonant ["qu", "squ"]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&translate_word(&1, ""))
    |> Enum.join(" ")
  end

  defp translate_word(<<first::binary-size(1), rest::binary>>, word) when first in @vowels,
    do: first <> rest <> word <> "ay"

  defp translate_word(<<first::binary-size(1), second::binary-size(1), rest::binary>>, word)
       when first in @may_sound_like_vowel and second not in @vowels,
       do: first <> second <> rest <> word <> "ay"

  defp translate_word(<<start::binary-size(3), rest::binary>>, word)
       when start in @may_sound_like_single_consonant,
       do: translate_word(rest, word <> start)

  defp translate_word(<<start::binary-size(2), rest::binary>>, word)
       when start in @may_sound_like_single_consonant,
       do: translate_word(rest, word <> start)

  defp translate_word(<<start::binary-size(1), rest::binary>>, word),
    do: translate_word(rest, word <> start)
end
