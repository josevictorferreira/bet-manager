defmodule BetManagerWeb.UserControllerTest do
  use BetManagerWeb.ConnCase

  # alias BetManager.User

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    [conn: conn]
  end

  # test "index/2 responds with all users" do
  #   users = [
  #     %{email: "test@test.com", password: "Test123"},
  #     %{email: "test2@test.com", password: "Test123"}
  #   ]

  #   [{:ok, user1}, {:ok, user2}] = Enum.map(users, &User.create_user(&1))

  #   response =
  #     conn
  #     |> get(Routes.user_path(conn, :index))
  #     |> json_response(200)

  #   %{
  #     "data" => {
  #       %{"email" => user1_resp, "inserted_at" => _, "updated_at" => _},
  #       %{"email" => user2_resp, "inserted_at" => _, "updated_at" => _}
  #     },
  #     "status" => status
  #   } = response

  #   assert status == "success"
  #   assert user1 == user1_resp
  #   assert user2 == user2_resp
  # end

  describe "create/2" do
    test "Creates and responds with a newly created user if attributes are valid", %{conn: conn} do
      response =
        conn
        |> put_req_header("accept", "application/json")
        |> post(Routes.user_path(conn, :create), %{
          "email" => "test@test.com",
          "password" => "Test123"
        })
        |> json_response(200)

      %{
        "status" => status,
        "data" => %{
          "email" => user_email,
          "id" => _,
          "inserted_at" => _
        }
      } = response

      assert status == "success"
      assert user_email == "test@test.com"
    end

    test "Returns an error and does not create a user if attributes are invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create), %{
          "email" => "testtest.com",
          "password" => "Test123"
        })
        |> json_response(200)

      %{
        "status" => status,
        "message" => message
      } = response

      assert status == "error"
      assert message == %{"email" => ["has invalid format"]}
    end
  end

  # describe "show/2" do
  #   test "Responds with user info if user is found"
  #   test "Responds with a message indicating user not found"
  # end

  # describe "update/2" do
  #   test "Edits, and responds with the user if attributes are valid"
  #   test "Returns an error and does not edit the user if attributes are invalid"
  # end

  # test "delete/2 and responds with :ok if the user was deleted"
end
