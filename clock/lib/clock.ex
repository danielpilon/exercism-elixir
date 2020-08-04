defmodule Clock do
  @hours 0..23
  @minutes 0..59
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    {carry_hours, minutes} = adjust_minutes(minute)
    hours = adjust_hours(hour + carry_hours)
    %Clock{hour: hours, minute: minutes}
  end

  @doc """
  Adds two clock times:s

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute), do: new(hour, minute + add_minute)

  def adjust_minutes(minute) when minute in @minutes, do: {0, minute}
  def adjust_minutes(minute), do: {minute |> Integer.floor_div(60), minute |> Integer.mod(60)}

  def adjust_hours(hour) when hour in @hours, do: hour
  def adjust_hours(hour), do: hour |> Integer.mod(24)
end

defimpl String.Chars, for: Clock do
  def to_string(%Clock{hour: hour, minute: minute}),
    do: "#{format(hour)}:#{format(minute)}"

  defp format(frame), do: :io_lib.format("~2..0B", [frame]) |> IO.iodata_to_binary()
end
