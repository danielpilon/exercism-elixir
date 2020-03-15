defmodule Phone do
  @invalid "0000000000"
  @invalid_exchange_first_digits ["0", "1"]

  defguard valid_exchange_first_digit(exchange)
           when exchange not in @invalid_exchange_first_digits

  defguard valid_length(number) when byte_size(number) == 10
  defguard valid_length_with_country_code(number) when byte_size(number) == 11

  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw), do: raw |> extract_number() |> apply_validations()

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw), do: raw |> number |> String.slice(0, 3)

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw), do: raw |> number |> prettyfy

  defp apply_validations(number) do
    cond do
      invalid_chars?(number) -> @invalid
      true -> number |> validate
    end
  end

  defp prettyfy(<<area::binary-size(3), exchange::binary-size(3), number::binary>>),
    do: "(#{area}) #{exchange}-#{number}"

  defp extract_number(raw), do: raw |> String.replace(~r/[\s+()-.]/, "")

  defp invalid_chars?(number), do: String.match?(number, ~r/[^0-9]/)

  defp validate(raw = "1" <> number) when valid_length_with_country_code(raw),
    do: validate(number)

  defp validate(raw) when valid_length_with_country_code(raw) == 11, do: @invalid

  defp validate(raw = "0" <> _) when valid_length(raw), do: @invalid
  defp validate(raw = "1" <> _) when valid_length(raw), do: @invalid

  defp validate(raw = <<_::binary-size(3), first_exchange::binary-size(1), _::binary>>)
       when valid_length(raw) and valid_exchange_first_digit(first_exchange),
       do: raw

  defp validate(_), do: @invalid
end
