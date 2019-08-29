defmodule BetManager.Services.AccountMovement do
  alias Ecto.Multi
  import Ecto
  alias BetManager.Bet
  alias BetManager.Transaction
  alias BetManager.Account

  def create_bet(params) do
    account_id = params["account_id"]

    Multi.new()
    |> Multi.insert(:bet, Bet.create_bet(params))
    |> Multi.update(:account, Account.update_account_balance(account_id))
  end

  def create_transaction(params) do
    account_id = params["account_id"]

    Multi.new()
    |> Multi.insert(:transaction, Transaction.create_transaction(params))
    |> Multi.update(:account, Account.update_account_balance(account_id))
  end
end
