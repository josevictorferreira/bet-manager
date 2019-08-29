defmodule BetManagerWeb.TransactionController do
  use BetManagerWeb, :controller
  alias BetManager.Transaction
  alias BetManager.Account
  alias BetManager.Repo

  def create(conn, %{"value" => value, "type" => type, "date" => date, "account_id" => account_id}) do
    case conn |> current_user!() |> account_same_user?(account_id) do
      true ->
        case Transaction.create_transaction(%{
               "value" => value,
               "type" => type,
               "date" => date,
               "account_id" => account_id
             }) do
          {:ok, transaction} ->
            new_transaction =
              transaction
              |> Repo.preload(account: [:bookmaker, currency: :country])

            conn
            |> put_status(:ok)
            |> render("show.json", new_transaction)

          {:error, reason} ->
            conn
            |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
        end

      false ->
        conn |> send_default_error_resp()
    end
  end

  def update(conn, %{"id" => id, "transaction" => %{} = transaction_params}) do
    transaction = Transaction.get_transaction!(id)

    case conn |> current_user!() |> account_same_user?(transaction.account_id) do
      true ->
        case Transaction.update_transaction(transaction, transaction_params) do
          {:ok, %Transaction{} = new_transaction} ->
            full_transaction =
              new_transaction
              |> Repo.preload(account: [:bookmaker, currency: :country])

            conn
            |> put_status(:ok)
            |> render("show.json", full_transaction)

          {:error, reason} ->
            conn
            |> send_json_resp(%{"status" => "error", "message" => translate_errors(reason)})
        end

      false ->
        conn |> send_default_error_resp()
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Transaction.get_transaction!(id)

    case conn |> current_user!() |> account_same_user?(transaction.account_id) do
      true ->
        conn |> render("show.json", transaction)

      false ->
        conn |> send_default_error_resp()
    end
  end

  def index(conn, %{}) do
    case conn |> current_user!() do
      nil ->
        conn |> send_default_error_resp()

      user ->
        transactions = Transaction.transactions_by_user_formatted(user.id)
        conn |> render("index.json", %{data: transactions})
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transaction.get_transaction!(id)

    case conn |> current_user!() |> account_same_user?(transaction.account_id) do
      true ->
        with {:ok, %Transaction{} = _} <- Transaction.delete_transaction(transaction) do
          conn |> send_default_success_resp()
        end

      false ->
        conn |> send_default_error_resp()
    end
  end

  defp account_same_user?(user, account_id) do
    case Account.get_account!(account_id) do
      nil ->
        false

      account ->
        account_user_id = account.user_id

        case user.id do
          user_id when user_id == account_user_id ->
            true

          _ ->
            false
        end
    end
  end
end
