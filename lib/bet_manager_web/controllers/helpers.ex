defmodule BetManagerWeb.Helpers do
  import Plug.Conn
  import Phoenix.Controller

  def send_default_error_resp(conn) do
    conn
    |> send_json_resp(%{"status" => "error"})
  end

  def send_default_success_resp(conn) do
    conn
    |> send_json_resp(%{"status" => "success"})
  end

  def send_json_resp(conn, data, status_code \\ 200) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(status_code, Poison.encode!(data))
  end
end