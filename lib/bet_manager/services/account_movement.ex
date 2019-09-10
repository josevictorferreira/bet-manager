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
      {:ok, account: account, transaction: _, balance: _} -> {:ok, account}
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
      {:ok, account: account, balance: _} -> {:ok, account}
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
      {:ok, transaction: transaction, balance: _} -> {:ok, transaction}
      {:error, reason} -> {:error, reason}
    end
  end

  def update_bet(%Bet{} = bet, attrs) do
    Multi.new()
    |> Multi.update(:bet, Bet.changeset(bet, attrs))
    |> Multi.run(:balance, fn _, %{bet: new_bet} ->
      change_params = [:odd, :result, :value, :event_date, :account_id]
      changed = Enum.any?(attrs, fn v -> v in change_params end)

      case changed do
        true ->
          Account.calculate_and_update_balance(new_bet.account_id)

        false ->
          {:ok, new_bet}
      end
    end)
    |> Multi.run(:balance_second_account, fn _, %{:ok, value} ->
      if :account_id in attrs do
        Account.calculate_and_update_balance(attrs[:account_id])
      else
        {:ok, value}
      end
    end)
    |> Repo.transaction()
  end

  def update_account(%Account{} = account, attrs) do
    Multi.new()
    |> Multi.update(:account, Account.changeset(account, attrs))
    |> Multi.run(:balance, fn param, %{account: new_account} ->
      balance_attrs = []
      IO.inspect(param)
      IO.inspect(new_account)
    end)
    |> Repo.transaction()
  end
end
