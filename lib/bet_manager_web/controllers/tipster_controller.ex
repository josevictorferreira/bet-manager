defmodule BetManagerWeb.TipsterController do
  use BetManagerWeb, :controller
  alias BetManager.Tipster

  def create(conn, %{"name" => name}) do
    user = conn |> current_user!()

    case Tipster.create_tipster(%{"name" => name, "user_id" => user.id}) do
      {:ok, tipster} ->
        conn
        |> put_status(:ok)
        |> render("show.json", tipster)

      {:error, reason} ->
        conn |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
    end
  end

  def update(conn, %{"id" => id, "tipster" => %{"name" => name}}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        tipster =
          id
          |> String.to_integer()
          |> Tipster.get_tipster!()

        tipster_user = tipster.user_id

        case user.id do
          new_user when new_user == tipster_user ->
            case Tipster.update_tipster(tipster, %{"name" => name}) do
              {:ok, %Tipster{} = new_tipster} ->
                conn
                |> render("show.json", new_tipster)

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
        tipster =
          id
          |> String.to_integer()
          |> Tipster.get_tipster!()

        tipster_user = tipster.user_id

        case user.id do
          value when value == tipster_user ->
            conn |> render("show.json", tipster)

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
        tipsters = Tipster.tipsters_by_user_formatted(user.id)
        conn |> render("index.json", %{data: tipsters})
    end
  end

  def delete(conn, %{"id" => id}) do
    case current_user(conn) do
      {:error, _} ->
        conn |> send_default_error_resp()

      {:ok, current_user} ->
        case Tipster.get_tipster!(id) do
          nil ->
            conn |> send_default_error_resp()

          tipster ->
            tipster_user = tipster.user_id

            case current_user.id do
              new_user when new_user == tipster_user ->
                with {:ok, %Tipster{} = _} <- Tipster.delete_tipster(tipster) do
                  conn |> send_default_success_resp()
                end

              _ ->
                conn |> send_default_error_resp()
            end
        end
    end
  end
end
