defmodule Hello.PostsTest do
  use Hello.DataCase
  import Hello.Factory

  alias Hello.Posts
  alias Hello.Posts.Tweet

  setup do
    user = insert(:user)

    tweet = insert(:tweet)

    {:ok, user: user, tweet: tweet}
  end

  describe "get_all_tweets/0" do
    test "returns all tweets", %{tweet: tweet} do
      tweets = Posts.get_all_tweets()
      result = Enum.map(tweets, fn tweet -> tweet.tweet end)
      assert result == [tweet.tweet]
    end
  end

  describe "get_tweet!/1" do
    test "returns the tweet with given id", %{tweet: tweet} do
      assert Posts.get_tweet!(tweet.id).id == tweet.id
    end
  end

  describe "create_tweet/1" do
    test "with valid data creates a tweet", %{user: user} do
      assert {:ok, %Tweet{}} = Posts.create_tweet(%{"tweet" => "ddd", "user_id" => user.id})
    end

    test "with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Posts.create_tweet(%{"tweet" => nil, "user_id" => user.id})
    end
  end

  describe "delete_tweet/1" do
    test "deletes the tweet", %{tweet: tweet} do
      assert {:ok, %Tweet{}} = Posts.delete_tweet(tweet.id)
      assert Posts.get_tweet!(tweet.id) == nil
    end
  end

  describe "favorites" do
    alias Hello.Posts.Favorite

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def favorite_fixture(attrs \\ %{}) do
      {:ok, favorite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_favorite()

      favorite
    end

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Posts.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Posts.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      assert {:ok, %Favorite{} = favorite} = Posts.create_favorite(@valid_attrs)
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{} = favorite} = Posts.update_favorite(favorite, @update_attrs)
    end

    test "update_favorite/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_favorite(favorite, @invalid_attrs)
      assert favorite == Posts.get_favorite!(favorite.id)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Posts.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_favorite!(favorite.id) end
    end

    test "change_favorite/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Posts.change_favorite(favorite)
    end
  end
end
