defmodule HelloWeb.API.TweetView do
  use HelloWeb, :view

  alias HelloWeb.API.TweetView

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
      users_favorited: Enum.map(tweet.favorites, fn favorite -> favorite.user_id end)
    }
  end

  def render("success.json", _) do
    %{
      message: "success"
    }
  end

  def render("error.json", _) do
    %{
      message: "error"
    }
  end
end
