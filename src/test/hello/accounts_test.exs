defmodule Hello.AccountsTest do
  use Hello.DataCase

  alias Hello.Accounts
  alias Hello.Accounts.User

  describe "create_user/1" do
    @valid_attrs %{
      username: "username",
      password: "password",
      password_confirmaton: "password"
    }
    @invalid_attrs %{username: nil, password: nil}

    test "creates a user with valid data" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "username"
      assert Repo.get(User, user.id) != nil
    end

    test "inserts encrypted_password not original password into user table" do
      {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.encrypted_password != "password"
    end

    test "returns error changeset with empty username and password" do
      result = Accounts.create_user(@invalid_attrs)
      assert match?({:error, %Ecto.Changeset{}}, result)
    end
  end
end
