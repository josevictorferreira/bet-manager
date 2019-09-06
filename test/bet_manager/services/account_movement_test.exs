defmodule BetManager.Services.AccountMovementTest do
  use ExUnit.Case

  alias BetManager.Repo
  alias BetManager.User
  alias BetManager.Tipster
  alias BetManager.Account
  alias BetManager.Transaction
  alias BetManager.Services.AccountMovement

  @user_attrs %{email: "custom_test@test.com", password: "Teste123"}

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, :auto)

    {:ok, user} = User.create_user(@user_attrs)
    {:ok, tipster} = Tipster.create_tipster(%{name: "GodOfGambling", user_id: user.id})
    {:ok, %{account: account, transaction: transaction, balance: _}} = AccountMovement.create_account(%{
      user_id: user.id,
      initial_balance: 400.0,
      bookmaker_id: 1,
      name: "Custom Account 1",
      currency_code: "BRL"
    })

    on_exit fn ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Repo, :auto)
      transaction.id
      |> Transaction.get_transaction!()
      |> Transaction.delete_transaction()
      account.id
      |> Account.get_account!()
      |> Account.delete_account()
      tipster.id
      |> Tipster.get_tipster!()
      |> Tipster.delete_tipster()
      user.id
      |> User.get_user!()
      |> User.delete_user()
      :ok
    end

    {:ok, user: user, account: account, tipster: tipster}
  end

  test "Check initial balance", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    account = state[:account]
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 400.0
  end

  test "Add a bet to account", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    account = state[:account]
    tipster = state[:tipster]
    user = state[:user]

    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(%{
      description: "Sao Paulo vs Corinthians - Over 2.5 goals",
      value: 25,
      odd: 1.9,
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      sport_id: 1
    })
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 375.0
  end

end
