defmodule BetManagerWeb.AccountController do
  use BetManagerWeb, :controller
  alias BetManager.Account
  alias BetManager.Repo

  def create(conn, %{
        "name" => name,
        "initial_balance" => init_balance,
        "currency_code" => currency_code,
        "bookmaker_id" => bookmaker_id
      }) do
    user = conn |> current_user!
    user_id = user.id

    case Account.create_account(%{
           name: name,
           initial_balance: init_balance,
           currency_code: currency_code,
           bookmaker_id: bookmaker_id,
           user_id: user_id
         }) do
      {:ok, account} ->
        new_account = account |> Repo.preload([:bookmaker, currency: :country])

        conn
        |> put_status(:ok)
        |> render("show.json", new_account)

      {:error, reason} ->
        conn |> send_json_resp(%{status: "error", message: translate_errors(reason)})
    end
  end

  def show(conn, %{"id" => id}) do
    case conn |> current_user! do
      nil ->
        conn |> send_default_error_resp()

      user ->
        account =
          id
          |> String.to_integer()
          |> Account.get_account!()

        account_user = account.user.id

        case user.id do
          user_id when user_id == account_user ->
            conn |> render("show.json", account)

          _ ->
            conn |> send_default_error_resp()
        end
    end
  end

  def index(conn, %{}) do
    case current_user(conn) do
      {:error, _} ->
        conn |> send_default_error_resp()

      {:ok, current_user} ->
        accounts = Account.accounts_by_user_formatted(current_user.id)
        conn |> render("index.json", %{data: accounts})
    end
  end

  def delete(conn, %{"id" => id}) do
    case current_user(conn) do
      {:error, _} ->
        conn |> send_default_error_resp()

      {:ok, current_user} ->
        case Account.get_account!(id) do
          nil ->
            conn |> send_default_error_resp()

          account ->
            account_user = account.user_id

            case current_user.id do
              new_user when new_user == account_user ->
                with {:ok, %Account{} = _} <- Account.delete_account(account) do
                  conn |> send_default_success_resp()
                end

              _ ->
                conn |> send_default_error_resp()
            end
        end
    end
  end

  def update(conn, %{
        "id" => id,
        "account" => %{
          "name" => name,
          "currency_code" => currency_code,
          "bookmaker_id" => bookmaker_id
        }
      }) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        account =
          id
          |> String.to_integer()
          |> Account.get_account!()

        account_user = account.user_id

        case user.id do
          new_user when new_user == account_user ->
            case Account.update_account(account, %{
                   "name" => name,
                   "currency_code" => currency_code,
                   "bookmaker_id" => bookmaker_id
                 }) do
              {:ok, %Account{} = new_account} ->
                conn
                |> render("show.json", new_account)

              {:error, reason} ->
                conn
                |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
            end

          _ ->
            conn |> send_default_error_resp()
        end
    end
  end
end
