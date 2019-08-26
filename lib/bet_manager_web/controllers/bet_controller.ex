defmodule BetManagerWeb.BetController do
  use BetManagerWeb, :controller
  alias BetManager.Bet

  @default_params %{"result" => "undefined"}

  def create(conn, %{
      "description" => description,
      "odd" => odd,
      "result" => _,
      "value" => value,
      "tipster_id" => tipster_id,
      "account_id" => account_id,
      "sport_id" => sport_id
    } = params) do
    new_params = Map.merge(@default_params, params)
    user = conn |> current_user!()
    case Bet.create_bet(%{
      "description" => description,
      "odd" => odd,
      "result" => new_params.result,
      "value" => value,
      "tipster_id" => tipster_id,
      "account_id" => account_id,
      "sport_id" => sport_id,
      "user_id" => user.id
      }) do
        {:ok, bet} ->
          conn
          |> put_status(:ok)
          |> render("show.json", bet)

        {:error, reason} ->
          conn |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
      end
  end

  def update(conn, %{"id" => id, "bet" => %{
    "description" => description,
    "odd" => odd,
    "result" => result,
    "value" => value,
    "tipster_id" => tipster_id,
    "account_id" => account_id,
    "sport_id" => sport_id
    }}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        bet =
          id
          |> String.to_integer()
          |> Bet.get_bet!()
        bet_usuer = bet.user_id
        case user.id do
          new_user when new_user == bet_user ->
            case Bet.update_bet(bet, %{""})
        end
    end
  end
end
