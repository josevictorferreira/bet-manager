alias BetManager.Seeds.SeedsCountry
alias BetManager.Seeds.SeedsCurrency
alias BetManager.Seeds.SeedsSport
alias BetManager.Seeds.SeedsBookmaker
alias BetManager.Country
alias BetManager.Currency
alias BetManager.Sport
alias BetManager.Bookmaker
alias BetManager.Repo

if Country |> Repo.all() == [] do
  SeedsCountry.seed!()
end
if Currency |> Repo.all() == [] do
  SeedsCurrency.seed!()
end
if Sport |> Repo.all() == [] do
  SeedsSport.seed!()
end
if Bookmaker |> Repo.all() == [] do
  SeedsBookmaker.seed!()
end
