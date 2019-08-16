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

defmodule SeedCountry do
  alias BetManager.Country
  alias BetManager.Repo

  def seed do
    case get_countries_from_api do
      {:ok, data} ->
        IO.puts("Starting seeding country data.")
        data |> Enum.each(fn x -> Country.create_country(x) end)
        IO.puts("Done seeding country data.")
      {:error, reason} ->
        IO.puts(reason)
    end
  end

  def clear do
    Country.delete_all()
    IO.puts("Deleted all data in Country db.")
  end

  def get_countries_from_api do
    case HTTPoison.get("https://restcountries.eu/rest/v2/all") do
      {:ok, result} ->
        {:ok, Poison.decode!(result) |> Enum.map(
                fn x -> %{code: x.alpha2Code,
                          name: x.name,
                          flag: x.flag,
                          region: x.region} end)}
      {:error, _} -> {:error, "Unable to reach Country API."}
    end
  end
end