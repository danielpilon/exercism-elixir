defmodule Hand do
  defstruct source: nil,
            cards: [],
            category: nil,
            weight: nil,
            score: [],
            ranks_freq: [],
            suits_freq: []

  @categories [
    :high_card,
    :one_pair,
    :two_pair,
    :three_of_a_kind,
    :ace_low_straight,
    :ace_high_straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush
  ]

  @categories_weights @categories |> Enum.with_index(0) |> Enum.into(%{})

  @ace_low_straight [2, 3, 4, 5, 14]

  def new(hand),
    do:
      %Hand{source: hand}
      |> parse_cards()
      |> with_frequencies()
      |> with_category()
      |> with_score()

  defp parse_cards(%{source: source} = hand), do: %{hand | cards: source |> Enum.map(&Card.new/1)}

  defp with_frequencies(%{cards: cards} = hand) do
    suits_freq = cards |> frequencies_by(& &1.suit)
    ranks_freq = cards |> frequencies_by(& &1.rank)

    %Hand{hand | suits_freq: suits_freq, ranks_freq: ranks_freq}
  end

  defp with_category(hand) do
    category =
      cond do
        straight_flush?(hand) -> :straight_flush
        four_of_a_kind?(hand) -> :four_of_a_kind
        full_house?(hand) -> :full_house
        flush?(hand) -> :flush
        three_of_a_kind?(hand) -> :three_of_a_kind
        two_pair?(hand) -> :two_pair
        one_pair?(hand) -> :one_pair
        ace_high_straight?(hand) -> :ace_high_straight
        ace_low_straight?(hand) -> :ace_low_straight
        high_card?(hand) -> :high_card
      end

    %Hand{hand | category: category, weight: @categories_weights[category]}
  end

  defp with_score(%Hand{category: :high_card, cards: cards} = hand) do
    score = cards |> Enum.map(& &1.weight) |> Enum.sort(:desc)

    %Hand{hand | score: score}
  end

  defp with_score(%Hand{category: :ace_low_straight} = hand),
    do: %Hand{hand | score: [5, 4, 3, 2, 1]}

  defp with_score(%Hand{cards: cards} = hand) do
    score =
      cards
      |> Enum.map(& &1.weight)
      |> Enum.frequencies()
      |> Enum.sort_by(&{elem(&1, 1), elem(&1, 0)}, :desc)
      |> Enum.map(&elem(&1, 0))

    %Hand{hand | score: score}
  end

  defp straight_flush?(hand), do: straight?(hand) && flush?(hand)
  defp flush?(%Hand{suits_freq: suits_freq}), do: suits_freq == [5]
  defp full_house?(%Hand{ranks_freq: ranks_freq}), do: ranks_freq == [3, 2]
  defp four_of_a_kind?(%Hand{ranks_freq: ranks_freq}), do: ranks_freq == [4, 1]
  defp three_of_a_kind?(%Hand{ranks_freq: ranks_freq}), do: ranks_freq == [3, 1, 1]
  defp two_pair?(%Hand{ranks_freq: ranks_freq}), do: ranks_freq == [2, 2, 1]
  defp one_pair?(%Hand{ranks_freq: ranks_freq}), do: ranks_freq == [2, 1, 1, 1]

  defp straight?(hand), do: ace_high_straight?(hand) || ace_low_straight?(hand)

  defp ace_low_straight?(%Hand{cards: cards}),
    do: cards |> Enum.map(& &1.weight) |> Enum.sort() == @ace_low_straight

  defp ace_high_straight?(%Hand{cards: cards}) do
    {min, max} = cards |> Enum.map(& &1.weight) |> Enum.min_max()
    max - min == 4
  end

  defp high_card?(_hand), do: :high_card

  defp frequencies_by(cards, mapper),
    do: cards |> Enum.map(mapper) |> Enum.frequencies() |> Map.values() |> Enum.sort(:desc)
end
