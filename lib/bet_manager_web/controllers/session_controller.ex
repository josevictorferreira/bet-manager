defmodule BetManagerWeb.SessionController do
  use BetManagerWeb, :controller
  alias BetManager.User

  def create(conn, %{"email" => email, "password" => password}) do
    case User.sign_in(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render("show.json", auth_token)
      {:error, reason} ->
        conn
        |> send_json_resp(%{"status" => "error", "message" => reason}, 401)
    end
  end

  def delete(conn, _) do
    case User.sign_out(conn) do
      {:error, reason} -> conn |> send_json_resp(%{"status" => "error", "message" => reason}, 400)
      {:ok, _} -> conn |> send_json_resp(%{"status" => "success", "message" => "Signed out."}, 200)
    end
  end

  def revoke(conn, _) do
    case User.revoke(conn) do
      {:error, reason} -> conn |> send_json_resp(%{"status" => "error", "message" => reason}, 400)
      {:ok, _} -> conn |> send_default_success_resp()
    end
  end
end
