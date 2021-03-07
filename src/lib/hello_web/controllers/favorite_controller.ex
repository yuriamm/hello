defmodule HelloWeb.FavoriteController do
  use HelloWeb, :controller

  alias Hello.Posts
  alias Hello.Posts.Favorite

  def create(conn, %{"tweet_id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    params = %{user_id: user_id, tweet_id: tweet_id}

    with {:ok, %Favorite{}} <- Posts.favorite(params) do
      # tweets = Blog.get_all_tweets()
      render(conn, "index.html", tweet: Posts.get_favorite!(tweet_id, user_id))
    end
  end

  def delete(conn, %{"tweet_id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    params = %{user_id: user_id, tweet_id: tweet_id}

    with {:ok, _} <- Posts.unfavorite(params) do
      # tweets = Blog.get_all_tweets()
      render(conn, "show.json", tweet: Posts.get_favorite!(tweet_id, user_id))
    end
  end
end
