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

  def create_account!(params) do
    case create_account(params) do
      {:ok, %{account: account, transaction: _, balance: _}} -> {:ok, account}
      {:error, reason} -> {:error, reason}
    end
  end

  def create_bet(params) do
    Multi.new()
    |> Multi.insert(:bet, Bet.changeset(%Bet{}, params))
    |> Multi.run(:balance, fn _, %{bet: bet} ->
      Account.calculate_and_update_balance(bet.account_id)
    end)
    |> Repo.transaction()
  end

  def create_bet!(params) do
    case create_bet(params) do
      {:ok, %{bet: bet, balance: _}} -> {:ok, bet}
      {:error, reason} -> {:error, reason}
    end
  end

  def create_transaction(params) do
    Multi.new()
    |> Multi.insert(:transaction, Transaction.changeset(%Transaction{}, params))
    |> Multi.run(:balance, fn _, %{transaction: transaction} ->
      Account.calculate_and_update_balance(transaction.account_id)
    end)
    |> Repo.transaction()
  end

  def create_transaction!(params) do
    case create_transaction(params) do
      {:ok, %{transaction: transaction, balance: _}} -> {:ok, transaction}
      {:error, reason} -> {:error, reason}
    end
  end

  def update_bet(%Bet{} = bet, attrs) do
    Multi.new()
    |> Multi.update(:bet, Bet.changeset(bet, attrs))
    |> Multi.run(:balance, fn _, %{bet: new_bet} ->
      change_params = [:odd, :result, :value, :event_date, :account_id]

      if Enum.any?(Map.keys(attrs), fn v -> v in change_params end) do
        Account.calculate_and_update_balance(bet.account_id)
      else
        {:ok, new_bet}
      end
    end)
    |> Multi.run(:balance_second_account, fn _, changes ->
      if :account_id in Map.keys(attrs) do
        Account.calculate_and_update_balance(attrs[:account_id])
      else
        {:ok, changes}
      end
    end)
    |> Repo.transaction()
  end

  def update_bet!(%Bet{} = bet, attrs) do
    case update_bet(bet, attrs) do
      {:ok, %{bet: bet, balance: _, balance_second_account: _}} ->
        {:ok, bet}

      {:error, changes} ->
        {:error, changes}
    end
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    Multi.new()
    |> Multi.update(:transaction, Transaction.changeset(transaction, attrs))
    |> Multi.run(:balance, fn _, %{transaction: _} ->
      Account.calculate_and_update_balance(transaction.account_id)
    end)
    |> Multi.run(:balance_second_account, fn _, changes ->
      if :account_id in Map.keys(attrs) do
        Account.calculate_and_update_balance(attrs[:account_id])
      else
        {:ok, changes}
      end
    end)
    |> Repo.transaction()
  end

  def update_transaction!(%Transaction{} = transaction, attrs) do
    case update_transaction(transaction, attrs) do
      {:ok, %{transaction: transaction, balance: _, balance_second_account: _}} ->
        {:ok, transaction}

      {:error, changes} ->
        {:error, changes}
    end
  end

  def delete_bet(%Bet{} = bet) do
    account_id = bet.account_id

    Multi.new()
    |> Multi.delete(:delete, bet)
    |> Multi.run(:balance, fn _, _ ->
      Account.calculate_and_update_balance(account_id)
    end)
    |> Repo.transaction()
  end

  def delete_bet!(%Bet{} = bet) do
    case delete_bet(bet) do
      {:ok, %{delete: bet, balance: _}} -> {:ok, bet}
      {:error, changes} -> changes
    end
  end
end
