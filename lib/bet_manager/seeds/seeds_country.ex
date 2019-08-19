defmodule BetManager.SeedsCountry do
  alias BetManager.Country

  def seed! do
    case get_countries_from_api() do
      {:ok, data} ->
        IO.puts("Starting seeding country data.")
        data |> Enum.each(fn x -> Country.create_country(x) end)
        hard_seed_data()
        IO.puts("Done seeding country data.")
      {:error, reason} ->
        IO.puts(reason)
    end
  end

  def clear! do
    Country.delete_all()
    IO.puts("Deleted all data in Country db.")
  end

  defp get_countries_from_api do
    case HTTPoison.get("https://restcountries.eu/rest/v2/all") do
      {:ok, result} ->
        {:ok, Poison.decode!(result.body)
              |> Enum.filter( fn x ->
                  !( !x["alpha2Code"] or
                  !x["name"] or
                  !x["flag"] or
                  !x["region"]) end
                )
              |> Enum.map(fn x ->
                  %{code: x["alpha2Code"],
                    name: x["name"],
                    flag: x["flag"],
                    region: x["region"]} end)}
      {:error, _} -> {:error, "Unable to reach Country API."}
    end
  end

  defp hard_seed_data do
    Country.create_country(%{
        code: "EU",
        name: "European Union",
        region: "Europe",
        flag: "https://upload.wikimedia.org/wikipedia/commons/b/b7/Flag_of_Europe.svg"
      })
  end
end
