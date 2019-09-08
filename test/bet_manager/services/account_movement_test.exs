defmodule BetManager.Services.AccountMovementTest do
  use ExUnit.Case

  alias BetManager.Repo
  alias BetManager.User
  alias BetManager.Tipster
  alias BetManager.Account
  alias BetManager.Services.AccountMovement

  @user_attrs %{email: "test@test.com", password: "Test123"}
  @bet_attrs %{
    description: "Sao Paulo vs Corinthians - Over 2.5 goals",
    value: 25,
    odd: 1.9,
    event_date: nil,
    tipster_id: nil,
    account_id: nil,
    user_id: nil,
    sport_id: 1
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, user} = User.create_user(@user_attrs)
    {:ok, tipster} = Tipster.create_tipster(%{name: "Myself", user_id: user.id})
    {:ok, %{account: account, transaction: transaction, balance: _}} = AccountMovement.create_account(%{
      user_id: user.id,
      initial_balance: 400.0,
      bookmaker_id: 1,
      name: "Custom Account 1",
      currency_code: "BRL"
    })
    [user: user, tipster: tipster, account: account, transaction: transaction]
  end

  test "Check initial balance", %{user: _, tipster: _, account: account, transaction: transaction} do
    new_account = Account.get_account!(account.id)
    assert transaction.type == "deposit"
    assert transaction.value == 400.0
    assert new_account.balance == 400.0
  end

  test "Add a bet to account", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 375.0
  end

  test "Add a winning bet to a account and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "win"
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 447.5
  end

  test "Add a losing bet to a account and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "lose"
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 375.0
  end

  test "Add a half win bet to a account and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "half win"
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 411.25
  end

  test "Add a half lost bet to a account and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "half lost"
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 387.50
  end

  test "Add a refund bet to a account and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "refund"
    }))
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 400.0
  end

  test "Add a deposit to a account and check balance", %{user: _, tipster: _, account: account, transaction: _} do
    {:ok, %{transaction: _, balance: _}} = AccountMovement.create_transaction(%{
      type: "deposit",
      value: 200.0,
      date: DateTime.utc_now() |> DateTime.to_string(),
      account_id: account.id
    })
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 600.0
  end

  test "Add a withdraw to a account and check balance", %{user: _, tipster: _, account: account, transaction: _} do
    {:ok, %{transaction: _, balance: _}} = AccountMovement.create_transaction(%{
      type: "withdraw",
      value: 200.0,
      date: DateTime.utc_now() |> DateTime.to_string(),
      account_id: account.id
    })
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 200.0
  end

  test "Add a win bet and then add a withdraw transaction and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id,
      result: "win"
    }))
    {:ok, %{transaction: _, balance: _}} = AccountMovement.create_transaction(%{
      type: "withdraw",
      value: 200.0,
      date: DateTime.utc_now() |> DateTime.to_string(),
      account_id: account.id
    })
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 247.50
  end

  test "Add a bet without result and then add a withdraw transaction and check balance", %{user: user, tipster: tipster, account: account, transaction: _} do
    {:ok, %{bet: _, balance: _}} = AccountMovement.create_bet(Map.merge(@bet_attrs, %{
      event_date: DateTime.utc_now() |> DateTime.to_string,
      tipster_id: tipster.id,
      account_id: account.id,
      user_id: user.id
    }))
    {:ok, %{transaction: _, balance: _}} = AccountMovement.create_transaction(%{
      type: "withdraw",
      value: 200.0,
      date: DateTime.utc_now() |> DateTime.to_string(),
      account_id: account.id
    })
    new_account = Account.get_account!(account.id)
    assert new_account.balance == 175.00
  end
end
