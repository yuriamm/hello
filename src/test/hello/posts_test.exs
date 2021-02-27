defmodule Hello.PostsTest do
  use Hello.DataCase
  import Hello.Factory

  alias Hello.Posts
  alias Hello.Posts.Tweet

  setup do
    user = insert(:user)

    {:ok, tweet} =
      %Tweet{}
      |> Tweet.changeset(%{"tweet" => "ddd"}, user.id)
      |> Repo.insert()

    {:ok, user: user, tweet: tweet}
  end

  describe "get_all_tweets/0" do
    test "returns all tweets" do
      tweets = Posts.get_all_tweets()
      result = Enum.map(tweets, fn tweet -> tweet.tweet end)
      assert result == ["ddd"]
    end
  end

  describe "get_tweet!/1" do
    test "returns the tweet with given id", %{tweet: tweet} do
      assert Posts.get_tweet!(tweet.id) == tweet
    end
  end

  describe "create_tweet/2" do
    test "with valid data creates a tweet", %{user: user} do
      assert {:ok, %Tweet{}} = Posts.create_tweet(%{"tweet" => "ddd"}, user.id)
    end

    test "with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Posts.create_tweet(%{"tweet" => nil}, user.id)
    end
  end

  describe "delete_tweet/1" do
    test "deletes the tweet", %{tweet: tweet} do
      assert {:ok, %Tweet{}} = Posts.delete_tweet(tweet.id)
      assert Posts.get_tweet!(tweet.id) == nil
    end
  end
end
