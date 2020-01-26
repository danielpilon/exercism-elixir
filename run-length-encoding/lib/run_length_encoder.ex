defmodule RunLengthEncoder do
  @numbers ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string), do: encode(string, "", 1, "")

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    decode(string, "", "")
  end

  defp encode("", last, 1, acc), do: acc <> last
  defp encode("", last, count, acc), do: acc <> to_string(count) <> last

  defp encode(<<char::binary-size(1), rest::binary>>, prev_char, count, acc)
       when prev_char == char,
       do: encode(rest, char, count + 1, acc)

  defp encode(<<char::binary-size(1), rest::binary>>, prev_char, 1, acc),
    do: encode(rest, char, 1, acc <> prev_char)

  defp encode(<<char::binary-size(1), rest::binary>>, prev_char, count, acc),
    do: encode(rest, char, 1, acc <> to_string(count) <> prev_char)

  defp decode("", "", acc), do: acc

  defp decode(<<char::binary-size(1), rest::binary>>, count, acc) when char in @numbers,
    do: decode(rest, count <> char, acc)

  defp decode(<<char::binary-size(1), rest::binary>>, "", acc),
    do: decode(rest, "", acc <> char)

  defp decode(<<char::binary-size(1), rest::binary>>, count, acc),
    do: decode(rest, "", acc <> String.duplicate(char, String.to_integer(count)))
end
