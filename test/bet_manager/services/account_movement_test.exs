defmodule BetManager.Services.AccountMovementTest do
  use ExUnit.Case

  alias BetManager.Repo
  alias BetManager.User
  alias BetManager.Tipster
  alias BetManager.Account
  alias BetManager.Services.AccountMovement

  @user_attrs %{email: "teste@testando.com", password: "Teste123"}

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    {:ok, tipster: []}
  end

  test "Check initial balance", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, user} = User.create_user(@user_attrs)
    {:ok, %{account: account, transaction: _, balance: acc_with_balance}} = AccountMovement.create_account(%{
      user_id: user.id,
      initial_balance: 400.0,
      bookmaker_id: 1,
      name: "Custom Account 1",
      currency_code: "BRL"
    })
    assert acc_with_balance.balance == 400.0
  end

end
