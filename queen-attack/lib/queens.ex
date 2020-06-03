defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @valid_colors [:black, :white]
  @line_template '_ _ _ _ _ _ _ _'

  defguardp valid_range?(position) when position > -1 and position < 8

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    black = opts[:black]
    white = opts[:white]

    with :ok <- valid_colors?(opts),
         :ok <- valid_position?(black),
         :ok <- valid_position?(white),
         :ok <- different_position?(black, white) do
      %Queens{black: black, white: white}
    else
      {:error, reason} -> raise ArgumentError, message: reason
    end
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{white: white, black: black}),
    do:
      @line_template
      |> List.duplicate(8)
      |> place_queen(white, 'W')
      |> place_queen(black, 'B')
      |> Enum.join("\n")

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {black_row, black_column}, white: {white_row, white_column}})
      when black_row === white_row or black_column === white_column or
             abs(black_row - white_row) == abs(black_column - white_column),
      do: true

  def can_attack?(_queens), do: false

  defp valid_colors?([]), do: :ok

  defp valid_colors?([{color, _position} | colors]) when color in @valid_colors,
    do: valid_colors?(colors)

  defp valid_colors?(_colors), do: {:error, "invalid color"}

  defp valid_position?(nil), do: :ok
  defp valid_position?({row, column}) when valid_range?(row) and valid_range?(column), do: :ok
  defp valid_position?(_position), do: {:error, "invalid position"}

  defp different_position?(position1, position2) when position1 === position2,
    do: {:error, "same position"}

  defp different_position?(_position1, _position2), do: :ok

  defp place_queen(board, nil, _queen_name), do: board

  defp place_queen(board, {row, column}, queen_name),
    do:
      board
      |> List.update_at(row, &place_queen_in_row(&1, column * 2, queen_name))

  defp place_queen_in_row(row, column, queen_name),
    do:
      row
      |> List.replace_at(column, queen_name)
end
