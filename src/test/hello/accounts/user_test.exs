# TODO: write test for changeset
defmodule Hello.Accounts.UserTest do
  use Hello.DataCase
  import Ecto.Repo

  alias Hello.Accounts
  alias Hello.Accounts.User

  describe "changeset" do
    @valid_attrs %{
      username: "username",
      password: "password",
      password_confirmaton: "password"
    }

    test "should insert data into users table when it has correct length" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "should return error messages when empty username passed in" do
      changeset = User.changeset(%User{}, %{username: "", password: "password"})
      assert changeset.errors[:username] != nil
      refute changeset.valid?
    end

    test "should return error messages when shorter username passed in" do
      changeset = User.changeset(%User{}, %{username: "five", password: "password"})
      assert changeset.errors[:username] != nil
      refute changeset.valid?
    end

    test "should return error messages when password confirmation doesn't match" do
      changeset =
        User.changeset(%User{}, %{
          username: "username",
          password: "password",
          password_confirmation: "invaid_password"
        })

      assert changeset.errors[:password_confirmation] != nil
      refute changeset.valid?
    end

    test "should return error messages when the user already exists" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)

      duplicated_user =
        User.changeset(%User{}, %{
          username: "username",
          password: "password",
          password_confirmation: "password"
        })

      assert {:error, changeset} = Repo.insert(duplicated_user)
      assert changeset.errors[:username] != nil
      refute changeset.valid?
    end
  end
end
