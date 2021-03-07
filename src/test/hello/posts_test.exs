defmodule Hello.PostsTest do
  use Hello.DataCase
  import Hello.Factory

  alias Hello.Posts
  alias Hello.Posts.Tweet
  alias Hello.Posts.Favorite

  setup do
    user = insert(:user)

    tweet = insert(:tweet)

    {:ok, user: user, tweet: tweet}
  end

  describe "get_all_tweets/0" do
    test "returns all tweets", %{tweet: tweet} do
      tweets = Posts.get_all_tweets()
      result = Enum.map(tweets, fn tweet -> tweet.tweet end)

      assert Enum.all?(result, &(&1 in [tweet.tweet]))
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

  describe "get_favorite_by_tweet/1" do
    test "returns number of favorites by tweet id", %{user: user, tweet: tweet} do
      favorite = insert(:favorite, user: user, tweet: tweet)
      assert Posts.get_favorite_by_tweet!(favorite.tweet.id) == 1
    end
  end

  describe "get_favorite_by_user/2" do
    test "returns boolean for whether the user favorited the tweet", %{user: user, tweet: tweet} do
      insert(:favorite, user: user, tweet: tweet)
      assert Posts.get_favorite_by_user(user.id, tweet.id) == true
    end
  end

  describe "favorite/1" do
    test "favorites a tweet", %{tweet: tweet} do
      assert {:ok, %Favorite{}} = Posts.favorite(%{tweet_id: tweet.id, user_id: tweet.user_id})
    end

    test "returns error changeset with invalid data", %{tweet: tweet} do
      assert {:error, %Ecto.Changeset{}} =
               Posts.favorite(%{tweet_id: nil, user_id: tweet.user_id})
    end
  end

  describe "unfavorite/2" do
    test "deletes the favorite from a tweet", %{user: user, tweet: tweet} do
      insert(:favorite, user: user, tweet: tweet)
      assert {:ok, %Favorite{}} = Posts.unfavorite(tweet.id, user.id)
      assert Posts.get_favorite_by_tweet!(tweet.id) == 0
    end
  end
end
