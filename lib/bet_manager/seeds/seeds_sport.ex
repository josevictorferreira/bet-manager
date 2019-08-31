defmodule BetManager.Seeds.SeedsSport do
  alias BetManager.Sport

  def seed! do
    hard_seed_data()
  end

  def clear! do
    Sport.delete_all()
  end

  defp hard_seed_data do
    data_list()
    |> Enum.each(fn x ->
      %{name: x}
      |> Sport.create_sport()
    end)
  end

  defp data_list do
    [
      "Australian Football",
      "Baseball",
      "Basketball",
      "Boxing",
      "Crossfit",
      "Ciclism",
      "Darts",
      "Entertainment",
      "Football",
      "Formula 1",
      "Golf",
      "Handball",
      "Hockey",
      "Mixed Martial Arts",
      "Politics",
      "Rugby",
      "Snooker",
      "Soccer",
      "Tennis",
      "Voleyball",
      "League of Legends",
      "Counter Strike",
      "DOTA",
      "Rainbow Six",
      "Overwatch",
      "Fortnite",
      "PUBG",
      "Chess"
    ]
  end
end
