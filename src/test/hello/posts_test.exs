defmodule Hello.PostsTest do
  use Hello.DataCase

  alias Hello.Accounts
  alias Hello.Posts
  alias Hello.Posts.Tweet

  def user_fixture do
    {:ok, user} =
      Accounts.create_user(%{
        password: "password",
        password_confirmaton: "password",
        username: "username"
      })

    user
  end

  describe "get_all_tweets/0" do
    test "returns all tweets" do
      user = user_fixture()

      {:ok, %Tweet{}} = Posts.create_tweet(%{"tweet" => "ddd"}, user.id)
      tweets = Posts.get_all_tweets()
      result = Enum.map(tweets, fn tweet -> tweet.tweet end)
      assert result == ["ddd"]
    end
  end

  describe "get_tweet!/1" do
    test "returns the tweet with given id" do
      user = user_fixture()
      {:ok, tweet} = Posts.create_tweet(%{"tweet" => "ddd"}, user.id)

      assert Posts.get_tweet!(tweet.id) == tweet
    end
  end

  describe "create_tweet/2" do
    test "with valid data creates a tweet" do
      user = user_fixture()
      assert {:ok, %Tweet{}} = Posts.create_tweet(%{"tweet" => "ddd"}, user.id)
    end

    test "with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.create_tweet(%{"tweet" => nil}, user.id)
    end
  end

  describe "delete_tweet/1" do
    test "deletes the tweet" do
      user = user_fixture()
      {:ok, tweet} = Posts.create_tweet(%{"tweet" => "ddd"}, user.id)
      assert {:ok, %Tweet{}} = Posts.delete_tweet(tweet)
      assert Posts.get_tweet!(tweet.id) == nil
    end
  end
end
