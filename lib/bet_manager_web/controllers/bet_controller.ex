defmodule BetManagerWeb.BetController do
  use BetManagerWeb, :controller
  alias BetManager.Bet
  alias BetManager.Repo

  @default_params %{"result" => "undefined"}

  def create(conn, %{} = params) do
    new_params = Map.merge(@default_params, params)
    user = conn |> current_user!()

    case Bet.create_bet(%{
           "description" => new_params["description"],
           "odd" => new_params["odd"],
           "result" => new_params["result"],
           "value" => new_params["value"],
           "event_date" => new_params["event_date"],
           "tipster_id" => new_params["tipster_id"],
           "account_id" => new_params["account_id"],
           "sport_id" => new_params["sport_id"],
           "user_id" => user.id
         }) do
      {:ok, bet} ->
        new_bet =
          bet
          |> Repo.preload([:user, :tipster, :sport, account: [:bookmaker, currency: :country]])

        conn
        |> put_status(:ok)
        |> render("show.json", new_bet)

      {:error, reason} ->
        conn |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
    end
  end

  def update(conn, %{"id" => id, "bet" => %{} = params}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        new_params =
          params
          |> Map.delete("user_id")

        bet =
          id
          |> String.to_integer()
          |> Bet.get_bet!()

        bet_user = bet.user_id

        case user.id do
          new_user when new_user == bet_user ->
            case Bet.update_bet(bet, new_params) do
              {:ok, %Bet{} = new_bet} ->
                bet_values =
                  new_bet
                  |> Repo.preload([
                    :user,
                    :tipster,
                    :sport,
                    account: [:bookmaker, currency: :country]
                  ])

                conn
                |> render("show.json", bet_values)

              {:error, reason} ->
                conn
                |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
            end

          _ ->
            conn |> send_default_error_resp()
        end
    end
  end

  def show(conn, %{"id" => id}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        bet =
          id
          |> String.to_integer()
          |> Bet.get_bet!()

        bet_user = bet.user_id

        case user.id do
          value when value == bet_user ->
            conn |> render("show.json", bet)

          _ ->
            conn |> send_default_error_resp()
        end
    end
  end

  def index(conn, %{}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        bets = Bet.bets_by_user_formatted(user.id)
        conn |> render("index.json", %{data: bets})
    end
  end

  def delete(conn, %{"id" => id}) do
    case current_user(conn) do
      {:error, _} ->
        conn |> send_default_error_resp()

      {:ok, current_user} ->
        case Bet.get_bet!(id) do
          nil ->
            conn |> send_default_error_resp()

          bet ->
            bet_user = bet.user_id

            case current_user.id do
              new_user when new_user == bet_user ->
                with {:ok, %Bet{} = _} <- Bet.delete_bet(bet) do
                  conn |> send_default_success_resp()
                end

              _ ->
                conn |> send_default_error_resp()
            end
        end
    end
  end
end
