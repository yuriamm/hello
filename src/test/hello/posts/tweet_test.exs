defmodule Hello.Posts.TweetTest do
  use Hello.DataCase

  import Ecto.Repo

  alias Hello.Accounts
  alias Hello.Posts.Tweet

  describe "changeset" do
    setup do
      {:ok, user} =
        Accounts.create_user(%{
          password: "password",
          password_confirmaton: "password",
          username: "username"
        })

      {:ok, user: user}
    end

    test "should insert data into tweets table when it has valid data", %{user: user} do
      changeset = Tweet.changeset(%Tweet{}, %{tweet: "tweet"}, user.id)

      assert changeset.valid?
    end

    test "should return error message when input is empty", %{user: user} do
      changeset = Tweet.changeset(%Tweet{}, %{tweet: ""}, user.id)
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when input is nil", %{user: user} do
      changeset = Tweet.changeset(%Tweet{}, %{tweet: nil}, user.id)
      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when input exceeds maximum length", %{user: user} do
      changeset =
        Tweet.changeset(
          %Tweet{},
          %{
            tweet:
              "Testing is an important part of developing software. In this lesson we’ll look at how to test our Elixir code with ExUnit and some best practices for doing so."
          },
          user.id
        )

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet: ["should be at most %{count} character(s)"]}
      refute changeset.valid?
    end
  end
end
