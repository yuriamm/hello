defmodule HelloWeb.API.TweetController do
  @moduledoc """
  Tweet API Controller.
  """
  use HelloWeb, :controller

  alias Hello.Posts

  @doc """
  Shows the home page.
  """
  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    tweets = Posts.get_all_tweets()
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    render(conn, "index.json", tweets: tweets, user_id: user_id)
  end

  @doc """
  Handles tweet function.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, tweet_params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    params = Map.put(tweet_params, "user_id", user_id)

    case Posts.create_tweet(params) do
      {:ok, _} ->
        render(conn, "success.json")

      {:error, %Ecto.Changeset{}} ->
        render(conn, "error.json")
    end
  end

  @doc """
  Handles deleting tweet function.
  """
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    case Posts.delete_tweet(id, user_id) do
      {:ok, _} ->
        render(conn, "success.json")

      {:error, _} ->
        render(conn, "error.json")
    end
  end
end
