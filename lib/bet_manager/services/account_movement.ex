defmodule BetManager.Services.AccountMovement do
  alias Ecto.Multi
  alias BetManager.Bet
  alias BetManager.Transaction
  alias BetManager.Account
  alias BetManager.Repo

  def create_account(params) do
    Multi.new()
    |> Multi.insert(:account, Account.changeset(%Account{}, params))
    |> Multi.run(:transaction, fn _, %{account: account} ->
      Transaction.create_transaction(%{
        value: account.initial_balance,
        type: "deposit",
        date: DateTime.utc_now() |> DateTime.to_string(),
        account_id: account.id
      })
    end)
    |> Multi.run(:balance, fn _, %{account: account, transaction: _} ->
      Account.calculate_and_update_balance(account.id)
    end)
    |> Repo.transaction()
  end

  def create_bet(params) do
    Multi.new()
    |> Multi.insert(:bet, Bet.changeset(%Bet{}, params))
    |> Multi.run(:balance, fn _, %{bet: bet} ->
      Account.calculate_and_update_balance(bet.account_id)
    end)
    |> Repo.transaction()
  end

  def create_transaction(params) do
    Multi.new()
    |> Multi.insert(:transaction, Transaction.changeset(%Transaction{}, params))
    |> Multi.run(:balance, fn _, %{transaction: transaction} ->
      Account.calculate_and_update_balance(transaction.account_id)
    end)
    |> Repo.transaction()
  end
end
