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

  def current_user(conn) do
    case is_signed_in?(conn) do
      true -> {:ok, conn.assigns[:signed_user]}
      _ -> {:error, :logged_out}
    end
  end

  def current_user!(conn) do
    case is_signed_in?(conn) do
      true -> conn.assigns[:signed_user]
      _ -> nil
    end
  end

  def is_signed_in?(conn) do
    conn.assigns[:signed_in]
  end

  def translate_error({msg, opts}) do
    String.replace(msg, "%{count}", to_string(opts[:count]))
  end
  def translate_error(msg), do: msg

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end