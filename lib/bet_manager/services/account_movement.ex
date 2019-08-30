defmodule BetManager.Services.AccountMovement do
  alias Ecto.Multi
  import Ecto
  alias BetManager.Bet
  alias BetManager.Transaction
  alias BetManager.Account

  def create_bet(params) do
    account_id = params["account_id"]

    changeset = Bet.changeset(%Bet{}, params)

    Multi.new()
    |> Multi.insert(:bet, changeset)
    |> Multi.update(:account, Account.update_account_balance(account_id))
  end

  def create_transaction(params) do
    changeset = Transaction.changeset(%Transaction{}, params)

    Multi.new()
    |> Multi.insert(:transaction, changeset)
    |> Multi.update(:account, fn %{transaction: transaction} ->
      IO.inspect(transaction)
      Account.update_account_balance(transaction.account_id)
    end)
  end
end
