defmodule BetManager.Seeds.SeedsCurrency do
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
    case read_file() do
      {:ok, result} ->
        {:ok, result
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

  defp read_file do
    filepath = file_path()
    with {:ok, body} <- File.read(filepath),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  defp file_path do
    base_dir = File.cwd!
    filename = Application.get_env(:bet_manager, BetManager.SeedsCurrency)[:seed_file]
    Path.join([base_dir, 'priv', 'data', filename])
  end
end
