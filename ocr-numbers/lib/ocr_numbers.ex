defmodule OcrNumbers do
  @numbers %{
    {
      " _ ",
      "| |",
      "|_|",
      "   "
    } => "0",
    {
      "   ",
      "  |",
      "  |",
      "   "
    } => "1",
    {
      " _ ",
      " _|",
      "|_ ",
      "   "
    } => "2",
    {
      " _ ",
      " _|",
      " _|",
      "   "
    } => "3",
    {
      "   ",
      "|_|",
      "  |",
      "   "
    } => "4",
    {
      " _ ",
      "|_ ",
      " _|",
      "   "
    } => "5",
    {
      " _ ",
      "|_ ",
      "|_|",
      "   "
    } => "6",
    {
      " _ ",
      "  |",
      "  |",
      "   "
    } => "7",
    {
      " _ ",
      "|_|",
      "|_|",
      "   "
    } => "8",
    {
      " _ ",
      "|_|",
      " _|",
      "   "
    } => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, charlist()}
  def convert(input) when rem(length(input), 4) > 0, do: {:error, 'invalid line count'}

  def convert([first | _rest]) when rem(byte_size(first), 3) > 0,
    do: {:error, 'invalid column count'}

  def convert(input), do: {:ok, do_convert(input)}

  defp do_convert(input),
    do:
      input
      |> Enum.chunk_every(4)
      |> Enum.map_join(",", &convert_to_numbers/1)

  defp convert_to_numbers(input),
    do:
      input
      |> Enum.map(&split_every_3/1)
      |> Enum.zip()
      |> Enum.map(&conver_to_number/1)
      |> to_number("")

  defp split_every_3(string), do: Regex.scan(~r/.../, string) |> List.flatten()

  defp to_number([], acc), do: acc
  defp to_number([number | rest], acc), do: to_number(rest, acc <> number)

  defp conver_to_number(input), do: @numbers[input] || "?"
end
