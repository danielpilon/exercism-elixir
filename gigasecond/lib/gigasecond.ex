defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from(erl_date),
    do:
      NaiveDateTime.from_erl!(erl_date)
      |> NaiveDateTime.add(1_000_000_000)
      |> NaiveDateTime.to_erl()
end
