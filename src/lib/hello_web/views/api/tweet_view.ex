defmodule HelloWeb.API.TweetView do
  use HelloWeb, :view

  alias HelloWeb.API.TweetView
  alias Hello.Posts

  def render("index.json", %{tweets: tweets}) do
    %{
      tweets: render_many(tweets, TweetView, "tweet.json")
    }
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      id: tweet.id,
      tweet: tweet.tweet,
      user_id: tweet.user_id,
      users_favorited: Enum.map(tweet.favorites, fn favorite -> favorite.user_id end),
      favorited_count: Posts.get_favorite_by_tweet!(tweet.id)
    }
  end

  def render("new.json", %{tweet: tweet}) do
    %{
      message: "tweeted",
      tweet: tweet.tweet,
      id: tweet.id,
      user_id: tweet.user_id,
      users_favorited: [],
      favorited_count: 0
    }
  end

  def render("delete.json", _) do
    %{
      message: "deleted"
    }
  end

  def render("error.json", _) do
    %{
      message: "error"
    }
  end
end
