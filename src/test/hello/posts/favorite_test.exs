defmodule Hello.Posts.FavoriteTest do
  use Hello.DataCase

  import Ecto.Repo
  import Hello.Factory

  alias Hello.Posts.Favorite

  describe "changeset" do
    setup do
      favorite = insert(:favorite)

      {:ok, favorite: favorite}
    end

    test "should be valid when input params are valid", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: favorite.tweet.id,
          user_id: favorite.tweet.user_id
        })

      assert changeset.valid?
    end

    test "should return error message when tweet id is empty", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: "",
          user_id: favorite.tweet.user_id
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet_id: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when tweet id is nil", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: nil,
          user_id: favorite.tweet.user_id
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet_id: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when tweet id is invalid", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: "a",
          user_id: favorite.tweet.user_id
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{tweet_id: ["is invalid"]}
      refute changeset.valid?
    end

    test "should return error message when user id is empty", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: favorite.tweet.id,
          user_id: ""
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{user_id: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when user id is nil", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: favorite.tweet.id,
          user_id: nil
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{user_id: ["can't be blank"]}
      refute changeset.valid?
    end

    test "should return error message when user id is invalid", %{favorite: favorite} do
      changeset =
        Favorite.changeset(%Favorite{}, %{
          tweet_id: favorite.tweet.id,
          user_id: "a"
        })

      error_message = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

      assert error_message == %{user_id: ["is invalid"]}
      refute changeset.valid?
    end
  end
end
