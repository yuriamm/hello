defmodule HelloWeb.API.SessionView do
  use HelloWeb, :view

  alias HelloWeb.API.TweetView

  def render("index.json", %{tweets: tweets}) do
    %{tweets: render_many(tweets, TweetView, "tweet.json")}
  end

  def render("success.json", %{user_id: user_id}) do
    %{
      message: "success",
      user_id: user_id
    }
  end

  def render("error.json", _) do
    %{
      message: "error"
    }
  end
end
