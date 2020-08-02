defmodule Card do
  @type t :: %Card{
          rank: String.t(),
          suit: String.t(),
          weight: integer()
        }

  defstruct rank: nil, suit: nil, weight: nil

  @ranks ~w(2 3 4 5 6 7 8 9 10 J Q K A)

  @ranks_weights @ranks |> Enum.with_index(2) |> Enum.into(%{})

  def new(card), do: card |> String.split_at(-1) |> to_card
  defp to_card({rank, suit}), do: %{rank: rank, suit: suit, weight: @ranks_weights[rank]}
end
