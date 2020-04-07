defmodule Frame do
  @type result :: :open | :spare | :strike
  @type roll :: :none | :first | :second | :finished
  @type t :: %Frame{
          first_roll: integer(),
          second_roll: integer(),
          first_bonus: integer(),
          second_bonus: integer(),
          result: result,
          roll: roll
        }
  defstruct first_roll: 0,
            second_roll: 0,
            first_bonus: 0,
            second_bonus: 0,
            result: :open,
            roll: :none

  @doc """
    Records the number of pins knocked down on a single roll.
  """
  @spec roll(Frame.t(), integer) :: any
  def roll(_, pins) when pins < 0, do: {:error, "Negative roll is invalid"}

  def roll(_, pins) when pins > 10, do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :none} = frame, 10),
    do: {:ok, %Frame{frame | first_roll: 10, result: :strike, roll: :first}}

  def roll(%Frame{roll: :none} = frame, pins),
    do: {:ok, %Frame{frame | first_roll: pins, roll: :first}}

  def roll(%Frame{roll: :first, result: :strike} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :second}}

  def roll(%Frame{roll: :first, first_roll: first_roll}, pins)
      when first_roll + pins > 10,
      do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :first, first_roll: first_roll} = frame, pins)
      when first_roll + pins == 10,
      do: {:ok, %Frame{frame | second_roll: pins, result: :spare, roll: :second}}

  def roll(%Frame{roll: :first} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :finished}}

  def roll(%Frame{roll: :second, result: :strike, second_roll: second_roll}, pins)
      when second_roll < 10 and second_roll + pins > 10,
      do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :second, result: :strike} = frame, pins),
    do: {:ok, %Frame{frame | first_bonus: pins, roll: :finished}}

  def roll(%Frame{roll: :second, result: :spare} = frame, pins),
    do: {:ok, %Frame{frame | first_bonus: pins, roll: :finished}}

  def roll(%Frame{roll: :second} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :finished}}

  def roll(frame, _pins), do: {:ok, frame}

  def score(%Frame{
        first_roll: first_roll,
        second_roll: second_roll,
        first_bonus: first_bonus,
        second_bonus: second_bonus
      }),
      do: first_roll + second_roll + first_bonus + second_bonus
end

defmodule Bowling do
  @type t :: %Bowling{frames: [Frame.t()], round: integer()}
  defstruct frames: [], round: 1

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  def start, do: %Bowling{}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(%Bowling{frames: [%Frame{roll: :finished} | _rest], round: 10}, _roll),
    do: {:error, "Cannot roll after game is over"}

  def roll(%Bowling{frames: []} = game, roll) do
    with({:ok, frame} <- Frame.roll(%Frame{}, roll)) do
      %Bowling{game | frames: [frame]}
      |> adjust_bonus(roll)
      |> switch_round()
    else
      err -> err
    end
  end

  def roll(%Bowling{frames: [frame | rest]} = game, roll) do
    with({:ok, updated} <- Frame.roll(frame, roll)) do
      %Bowling{game | frames: [updated | rest]}
      |> adjust_bonus(roll)
      |> switch_round()
    else
      err -> err
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(%Bowling{frames: [%Frame{roll: :finished} | _rest] = frames, round: 10}),
    do: frames |> Enum.map(&Frame.score(&1)) |> Enum.sum()

  def score(_game), do: {:error, "Score cannot be taken until the end of the game"}

  defp switch_round(%Bowling{round: 10} = game), do: game

  defp switch_round(
         %Bowling{frames: [%Frame{result: result, roll: roll} | _rest] = frames, round: round} =
           game
       )
       when result in [:spare, :strike] or roll == :finished,
       do: %Bowling{game | round: round + 1, frames: [%Frame{} | frames]}

  defp switch_round(game), do: game

  defp adjust_bonus(%Bowling{frames: [current, p, p1 | rest]} = game, roll) do
    with(
      {:ok, p_updated} <- Frame.roll(p, roll),
      {:ok, p1_updated} <- Frame.roll(p1, roll)
    ) do
      %Bowling{game | frames: [current, p_updated, p1_updated | rest]}
    else
      err -> err
    end
  end

  defp adjust_bonus(%Bowling{frames: [current, p | rest]} = game, roll) do
    with({:ok, p_updated} <- Frame.roll(p, roll)) do
      %Bowling{game | frames: [current, p_updated | rest]}
    else
      err -> err
    end
  end

  defp adjust_bonus(game, _roll), do: game
end
