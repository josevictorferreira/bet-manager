defmodule BetManagerWeb.BookmakerController do
  use BetManagerWeb, :controller
  alias BetManager.Bookmaker

  def create(conn, %{"name" => name, "logo" => logo}) do
    user = conn |> current_user!()
    case Bookmaker.create_bookmaker(%{"name" => name, "logo" => logo, "user_id" => user.id}) do
      {:ok, bookmaker} ->
        conn
        |> put_status(:ok)
        |> render("show.json", bookmaker)
      {:error, reason} -> conn |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
    end
  end

  def update(conn, %{"id" => id, "bookmaker" => %{"name" => name, "logo" => logo}}) do
    case conn |> current_user!() do
      nil -> conn |> send_default_error_resp()
      user ->
        bookmaker = id
        |> String.to_integer()
        |> Bookmaker.get_bookmaker!()
        bookmaker_user = bookmaker.user_id
        case user.id do
          new_user when new_user == bookmaker_user ->
            case Bookmaker.update_bookmaker(bookmaker, %{"name" => name, "logo" => logo}) do
              {:ok, %Bookmaker{} = new_bookmaker} ->
                conn
                |> render("show.json", new_bookmaker)
              {:error, reason} ->
                conn
                |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
            end
          _ -> conn |> send_default_error_resp()
        end
    end
  end

  def show(conn, %{"id" => id}) do
    case conn |> current_user!() do
      nil -> conn |> send_default_error_resp()
      user ->
        bookmaker = id
        |> String.to_integer()
        |> Bookmaker.get_bookmaker!()
        bookmaker_user = bookmaker.user_id
        case user.id do
          value when value == bookmaker_user or bookmaker_user == nil ->
            conn |> render("show.json", bookmaker)
          _ -> conn |> send_default_error_resp()
        end
    end
  end

  def index(conn, %{}) do
    case conn |> current_user!() do
      nil -> conn |> send_default_error_resp()
      user ->
        bookmakers = Bookmaker.bookmakers_by_user_formatted(user.id)
        conn |> render("index.json", %{data: bookmakers})
    end
  end

  def delete(conn, %{"id" => id}) do
    case current_user(conn) do
      {:error, _} -> conn |> send_default_error_resp()
      {:ok, current_user} ->
        case Bookmaker.get_bookmaker!(id) do
          nil -> conn |> send_default_error_resp()
          bookmaker ->
            bookmaker_user = bookmaker.id
            case current_user.id do
              new_user when new_user == bookmaker_user ->
                with {:ok, %Bookmaker{} = _} <- Bookmaker.delete_bookmaker(bookmaker) do
                  conn |> send_default_success_resp()
                end
              _ -> conn |> send_default_error_resp()
            end
        end
    end
  end
end
