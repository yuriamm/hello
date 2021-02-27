defmodule Hello.Posts.TweetTest do
  use Hello.DataCase

  import Ecto.Repo
  import Hello.Factory

  alias Hello.Posts.Tweet

  describe "changeset" do
    setup do
      user = insert(:user)

      {:ok, user: user}
    end

    test "should be valid when input data is valid", %{user: user} do
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
