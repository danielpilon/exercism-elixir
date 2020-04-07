defmodule Frame do
  @type result :: :open | :spare | :strike
  @type roll :: :none | :first | :second | :finished
  @type t :: %Frame{
          first_roll: integer(),
          second_roll: integer(),
          bonus: integer(),
          result: result,
          roll: roll
        }
  defstruct first_roll: 0,
            second_roll: 0,
            bonus: 0,
            result: :open,
            roll: :none

  @max_pins 10

  @doc """
    Records the number of pins knocked down on a single roll.
  """
  @spec roll(Frame.t(), integer) :: any
  def roll(_frame, pins) when pins < 0, do: {:error, "Negative roll is invalid"}

  def roll(_frame, pins) when pins > @max_pins, do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :none} = frame, @max_pins),
    do: {:ok, %Frame{frame | first_roll: @max_pins, result: :strike, roll: :first}}

  def roll(%Frame{roll: :none} = frame, pins),
    do: {:ok, %Frame{frame | first_roll: pins, roll: :first}}

  def roll(%Frame{roll: :first, result: :strike} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :second}}

  def roll(%Frame{roll: :first, first_roll: first_roll}, pins)
      when first_roll + pins > @max_pins,
      do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :first, first_roll: first_roll} = frame, pins)
      when first_roll + pins == @max_pins,
      do: {:ok, %Frame{frame | second_roll: pins, result: :spare, roll: :second}}

  def roll(%Frame{roll: :first} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :finished}}

  def roll(%Frame{roll: :second, result: :strike, second_roll: second_roll}, pins)
      when second_roll < @max_pins and second_roll + pins > @max_pins,
      do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Frame{roll: :second, result: :strike} = frame, pins),
    do: {:ok, %Frame{frame | bonus: pins, roll: :finished}}

  def roll(%Frame{roll: :second, result: :spare} = frame, pins),
    do: {:ok, %Frame{frame | bonus: pins, roll: :finished}}

  def roll(%Frame{roll: :second} = frame, pins),
    do: {:ok, %Frame{frame | second_roll: pins, roll: :finished}}

  def roll(frame, _pins), do: {:ok, frame}

  def score(%Frame{
        first_roll: first_roll,
        second_roll: second_roll,
        bonus: bonus
      }),
      do: first_roll + second_roll + bonus
end

defmodule Bowling do
  @type t :: %Bowling{frames: [Frame.t()]}
  defstruct frames: []

  @max_frames 10

  defguardp round_finished(result, roll) when result in [:spare, :strike] or roll == :finished
  defguardp last_frame_reached(frames) when length(frames) == @max_frames

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
  def roll(%Bowling{frames: [%Frame{roll: :finished} | _rest] = frames}, _roll)
      when last_frame_reached(frames),
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
  def score(%Bowling{frames: [%Frame{roll: :finished} | _rest] = frames})
      when last_frame_reached(frames),
      do: frames |> Enum.map(&Frame.score(&1)) |> Enum.sum()

  def score(_game), do: {:error, "Score cannot be taken until the end of the game"}

  defp switch_round(%Bowling{frames: frames} = game) when last_frame_reached(frames), do: game

  defp switch_round(
         %Bowling{frames: [%Frame{result: result, roll: roll} | _rest] = frames} = game
       )
       when round_finished(result, roll),
       do: %Bowling{game | frames: [%Frame{} | frames]}

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
