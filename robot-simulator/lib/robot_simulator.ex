defmodule RobotSimulator do
  defstruct [:direction, :position]

  @moves %{
    :north => {:west, :east, {0, 1}},
    :south => {:east, :west, {0, -1}},
    :west => {:south, :north, {-1, 0}},
    :east => {:north, :south, {1, 0}}
  }

  @directions Map.keys(@moves)

  defguard is_valid_position(x, y) when is_integer(x) and is_integer(y)
  defguard is_valid_direction(direction) when direction in @directions

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, postion \\ {0, 0})

  def create(direction, {x, y} = position)
      when is_valid_position(x, y) and is_valid_direction(direction),
      do: %RobotSimulator{direction: direction, position: position}

  def create(_, {x, y}) when is_valid_position(x, y), do: {:error, "invalid direction"}
  def create(_, _), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions), do: move(instructions, robot)

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position

  defp move("", robot), do: robot

  defp move(<<move::binary-size(1), next::binary>>, robot) when move == "L" do
    {left, _, _} = @moves[robot.direction]
    move(next, %{robot | direction: left})
  end

  defp move(<<move::binary-size(1), next::binary>>, robot) when move == "R" do
    {_, right, _} = @moves[robot.direction]
    move(next, %{robot | direction: right})
  end

  defp move(<<move::binary-size(1), next::binary>>, robot) when move == "A" do
    {cx, cy} = robot.position
    {_, _, {x, y}} = @moves[robot.direction]
    move(next, %{robot | position: {cx + x, cy + y}})
  end

  defp move(_, _), do: {:error, "invalid instruction"}
end
