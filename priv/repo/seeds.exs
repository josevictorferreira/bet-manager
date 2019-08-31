# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BetManager.Repo.insert!(%BetManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BetManager.Seeds.SeedsCountry
alias BetManager.Seeds.SeedsCurrency
alias BetManager.Seeds.SeedsSport
alias BetManager.Seeds.SeedsBookmaker

SeedsCountry.seed!()

SeedsCurrency.seed!()

SeedsSport.seed!()

SeedsBookmaker.seed!()
