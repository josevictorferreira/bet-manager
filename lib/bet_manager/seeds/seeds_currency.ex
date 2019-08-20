defmodule BetManager.SeedsCurrency do
  alias BetManager.Currency

  def seed! do
    case get_currencies_from_api() do
      {:ok, data} ->
        IO.puts("Starting seeding currency data.")
        data |> Enum.each(fn x -> Currency.create_currency(x) end)
        IO.puts("Done seeding currency data.")
      {:error, reason} ->
        IO.puts(reason)
    end
  end

  def clear! do
    Currency.delete_all()
    IO.puts("Deleted all data in Currency db.")
  end

  defp get_currencies_from_api do
    data_api = Application.get_env(:bet_manager, BetManager.SeedsCurrency)[:seed_data]
    case HTTPoison.get(data_api) do
      {:ok, result} ->
        {:ok, Poison.decode!(result.body)
              |> Enum.map(fn {_, x} ->
                %{code: x["code"],
                  name: x["name"],
                  name_plural: x["name_plural"],
                  symbol: x["symbol"],
                  country_code: x["country_code"],
                  decimal_digits: x["decimal_digits"],
                  rounding: x["rounding"]} end)}
      {:error, _} -> {:error, "Unable to reach Currency API."}
    end
  end
end