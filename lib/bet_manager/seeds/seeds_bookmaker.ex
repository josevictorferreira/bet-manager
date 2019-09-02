defmodule BetManager.Seeds.SeedsBookmaker do
  alias BetManager.Bookmaker

  def seed! do
    custom_seed_data()
    |> Enum.each(fn x ->
      {:ok, _} = Bookmaker.create_bookmaker(x)
    end)
  end

  def clear! do
    Bookmaker.delete_all()
  end

  defp custom_seed_data do
    [
      %{
        name: "Bet365",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/11/Bet365-Loyalty-Bonus-102x34.png"
      },
      %{
        name: "Unibet",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/09/unibet-logo-102x34.png"
      },
      %{
        name: "Bwin",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2018/12/bwin-logo-102x34.png"
      },
      %{
        name: "William Hill",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/09/williamhill-logo-102x34.png"
      },
      %{
        name: "Betfair",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2018/12/betfair-logo-102x34.png"
      },
      %{
        name: "Sportingbet",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2017/03/sportingbet-logo5-102x34.png"
      },
      %{
        name: "1xBet",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/10/1xbet-logo-1-102x34.png"
      },
      %{
        name: "Bet-at-home",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/09/betathome-logo3-102x34.png"
      },
      %{
        name: "Marathonbet",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/11/marathonbet-logo-1-102x34.png"
      },
      %{
        name: "Pinnacle",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2016/09/pinacle-logo-102x34.png"
      },
      %{
        name: "Betway",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2019/04/Betway-logo_102x34.jpg"
      },
      %{
        name: "Paddypower",
        logo: "https://www.bookmakers.bet/wp-content/uploads/2017/02/paddypower-logo3-102x34.png"
      }
    ]
  end
end
