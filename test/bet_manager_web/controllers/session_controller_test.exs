defmodule BetManagerWeb.SessionControllerTest do
  use BetManagerWeb.ConnCase

  alias BetManager.User
  alias BetManager.AuthToken

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    [conn: conn]
  end

  describe "create/2" do
    test "Creates and responds with a newly created auth token, if the user data is valid", %{
      conn: conn
    } do
      {:ok, user} =
        User.create_user(%{
          "email" => "test@test.com",
          "password" => "Test123"
        })

      IO.inspect(user.id)
      auth_token = AuthToken.get_last_by_user(user.id)

      response =
        conn
        |> put_req_header("accept", "application/json")
        |> post(Routes.session_path(conn, :create), %{
          "email" => "test@test.com",
          "password" => "Test123"
        })
        |> json_response(200)

      %{"data" => %{"token" => token}} = response

      assert token == auth_token.token
    end
  end
end
