defmodule Hello.AccountsTest do
  use Hello.DataCase

  import Ecto.Repo

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
      assert Repo.get(User, user.id) != nil
    end

    test "inserts encrypted_password into users table" do
      {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert Bcrypt.verify_pass("password", user.encrypted_password) == true
    end

    test "returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
