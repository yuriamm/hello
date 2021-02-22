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
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{username: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error messages when username is nil" do
      changeset = User.changeset(%User{}, %{username: nil, password: "password"})
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{username: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error messages when empty password passed in" do
      changeset = User.changeset(%User{}, %{username: "username", password: ""})
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{password: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error messages when password is nil" do
      changeset = User.changeset(%User{}, %{username: "username", password: nil})
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{password: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error messages when shorter username passed in" do
      changeset = User.changeset(%User{}, %{username: "five5", password: "password"})
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{username: ["should be at least %{count} character(s)"]}
      refute changeset.valid?
    end

    test "should return error messages when shorter password passed in" do
      changeset = User.changeset(%User{}, %{username: "username", password: "five5"})
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{password: ["should be at least %{count} character(s)"]}
      refute changeset.valid?
    end

    test "should return error messages when password confirmation doesn't match" do
      changeset =
        User.changeset(%User{}, %{
          username: "username",
          password: "password",
          password_confirmation: "invaid_password"
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{password_confirmation: ["does not match confirmation"]}
      refute changeset.valid?
    end

    test "should return error messages when the user already exists" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)

      {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_attrs)

      refute changeset.valid?

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{username: ["has already been taken"]}
    end
  end
end
