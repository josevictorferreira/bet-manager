defmodule BetManagerWeb.UserController do
  use BetManagerWeb, :controller
  alias BetManager.User

  def create(conn, %{"email" => email, "password" => password}) do
    case User.create_user(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user)
      {:error, reason} -> conn |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
    end
  end

  def update(conn, %{"id" => id, "user" => %{"password" => password}}) do
    user_id = String.to_integer(id)
    case current_user(conn) do
      {:error, _} -> conn |> send_resp(200, Poison.encode!(%{"status" => "error"}))
      {:ok, current_user} ->
        case current_user.id do
          user_id ->
            user = User.get_user!(user_id)
            with {:ok, %User{} = user} <- User.update_user(user, %{"password" => password}) do
              render(conn, "show.json", user)
            end
          _ -> conn |> send_default_error_resp()
        end
    end
  end

  def show(conn, %{"id" => id}) do
    user_id = String.to_integer(id)
    case current_user(conn) do
      {:error, _} -> conn |>  send_resp(200, Poison.encode!(%{"status" => "error"}))
      {:ok, current_user} ->
        case current_user.id do
          user_id ->
            user = User.get_user!(user_id)
            render(conn, "show.json", user)
          _ -> conn |> send_default_error_resp()
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = String.to_integer(id)
    case current_user(conn) do
      {:error, _} -> conn |> send_default_error_resp()
      {:ok, current_user} ->
        case current_user.id do
          user_id ->
            user = User.get_user!(user_id)
            with {:ok, %User{} = user} <- User.delete_user(user) do
              conn |> send_default_success_resp()
            end
          _ ->
            conn |> send_default_error_resp()
        end
    end
  end

end
