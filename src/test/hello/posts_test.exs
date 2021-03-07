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
end
