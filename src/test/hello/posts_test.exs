defmodule Hello.PostsTest do
  use Hello.DataCase

  alias Hello.Posts

  describe "tweets" do
    alias Hello.Posts.Tweet

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def tweet_fixture(attrs \\ %{}) do
      {:ok, tweet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_tweet()

      tweet
    end

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Posts.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Posts.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      assert {:ok, %Tweet{} = tweet} = Posts.create_tweet(@valid_attrs)
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{} = tweet} = Posts.update_tweet(tweet, @update_attrs)
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_tweet(tweet, @invalid_attrs)
      assert tweet == Posts.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Posts.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Posts.change_tweet(tweet)
    end
  end
end
