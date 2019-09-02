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
      Account.calculate_and_update_balance(account)
    end)
    |> Repo.transaction()
  end

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
      Account.update_account_balance(transaction.account_id)
    end)
  end
end
