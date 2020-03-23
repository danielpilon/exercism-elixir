defmodule Tournament do
  @results %{
    "win" => :win,
    "loss" => :loss,
    "draw" => :draw
  }
  @points %{
    :won => 3,
    :lost => 0,
    :drawn => 1
  }
  @team_results %{:won => 0, :lost => 0, :drawn => 0, :played => 0, :points => 0}
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> get_matches_results
    |> compute_matches
    |> sort_results
    |> make_scoreboard
  end

  defp get_matches_results(input) do
    input
    |> Enum.map(&String.split(&1, ";"))
    |> Enum.filter(&(Enum.count(&1) === 3))
    |> Enum.map(&parse_match_result/1)
  end

  defp compute_matches(results), do: results |> Enum.reduce(%{}, &compute_match/2)

  defp sort_results(results), do: results |> Enum.sort(&compare_scores/2)

  defp make_scoreboard(scoreboard) do
    scores =
      scoreboard
      |> Enum.map(&make_team_score/1)

    header = "#{String.pad_trailing("Team", 31)}| MP |  W |  D |  L |  P"
    [header | scores] |> Enum.join("\n")
  end

  defp parse_match_result([team_a, team_b, result]), do: {@results[result], team_a, team_b}

  defp compute_match({:win, winner, loser}, table), do: compute_match(winner, loser, table)
  defp compute_match({:loss, loser, winner}, table), do: compute_match(winner, loser, table)

  defp compute_match({:draw, team_a, team_b}, table),
    do:
      table
      |> Map.put(team_a, update_tounament(Map.get(table, team_a, @team_results), :drawn))
      |> Map.put(team_b, update_tounament(Map.get(table, team_b, @team_results), :drawn))

  defp compute_match(_, table), do: table

  defp compute_match(winner, loser, table) do
    table
    |> Map.put(winner, update_tounament(Map.get(table, winner, @team_results), :won))
    |> Map.put(loser, update_tounament(Map.get(table, loser, @team_results), :lost))
  end

  defp make_team_score(
         {team,
          %{
            :won => won,
            :lost => lost,
            :drawn => drawn,
            :played => played,
            :points => points
          }}
       ) do
    "#{String.pad_trailing(team, 31)}|  #{played} |  #{won} |  #{drawn} |  #{lost} |  #{points}"
  end

  defp update_tounament(team_results, result) do
    team_results
    |> Map.put(result, Map.get(team_results, result, 0) + 1)
    |> Map.put(:played, Map.get(team_results, :played, 0) + 1)
    |> Map.put(:points, Map.get(team_results, :points, 0) + @points[result])
  end

  defp compare_scores({t1, %{:points => p1}}, {t2, %{:points => p2}}),
    do: p1 > p2 || (p1 == p2 && t1 < t2)
end
