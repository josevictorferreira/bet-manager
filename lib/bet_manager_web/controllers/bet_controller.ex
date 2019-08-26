defmodule BetManagerWeb.BetController do
  use BetManagerWeb, :controller
  alias BetManager.Bet

  @default_params %{"result" => "undefined"}

  def create(conn, %{} = params) do
    new_params = Map.merge(@default_params, params)
    user = conn |> current_user!()

    case Bet.create_bet(%{
           "description" => new_params["description"],
           "odd" => new_params["odd"],
           "result" => new_params["result"],
           "value" => new_params["value"],
           "tipster_id" => new_params["tipster_id"],
           "account_id" => new_params["account_id"],
           "sport_id" => new_params["sport_id"],
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

  def update(conn, %{
        "id" => id,
        "bet" => %{
          "description" => description,
          "odd" => odd,
          "result" => result,
          "value" => value,
          "tipster_id" => tipster_id,
          "account_id" => account_id,
          "sport_id" => sport_id
        }
      }) do
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
          new_user when new_user == bet_user ->
            case Bet.update_bet(bet, %{
                   "description" => description,
                   "odd" => odd,
                   "result" => result,
                   "value" => value,
                   "tipster_id" => tipster_id,
                   "account_id" => account_id,
                   "sport_id" => sport_id
                 }) do
              {:ok, %Bet{} = new_bet} ->
                conn
                |> render("show.json", new_bet)

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