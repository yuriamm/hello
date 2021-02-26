defmodule Hello.SessionTest do
  use Hello.DataCase

  alias Hello.Accounts
  alias Hello.Session

  describe "login/1" do
    alias Hello.Accounts.User

    @valid_registration %{
      username: "username",
      password: "password",
      password_confirmaton: "password"
    }
    @valid_attrs %{username: "username", password: "password"}
    @invalid_attrs %{username: nil, password: nil}

    setup do
      Accounts.create_user(@valid_registration)

      :ok
    end

    test "logins user with valid data" do
      assert {:ok, %User{}} = Session.login(@valid_attrs)
    end

    test "doesn't login user with invalid data" do
      assert {:error, "Username is empty."} = Session.login(@invalid_attrs)
    end
  end
end
