defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekdays %{
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6,
    :sunday => 7
  }

  @schedule %{
    :first => 7,
    :second => 14,
    :third => 21,
    :fourth => 28,
    :teenth => 19
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule),
    do:
      find(
        %Date{
          year: year,
          month: month,
          day: @schedule[schedule] || :calendar.last_day_of_the_month(year, month)
        },
        @weekdays[weekday]
      )

  defp find(date, day_of_week) do
    case Date.day_of_week(date) do
      ^day_of_week -> date
      _ -> find(Date.add(date, -1), day_of_week)
    end
  end
end
