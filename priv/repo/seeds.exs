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

alias BetManager.SeedsCountry
alias BetManager.SeedsCurrency
alias BetManager.SeedsSport
alias BetManager.SeedsBookmaker

SeedsCountry.seed!()

SeedsCurrency.seed!()

SeedsSport.seed!()

SeedsBookmaker.seed!()
