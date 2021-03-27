defmodule HelloWeb.API.FavoriteController do
  @moduledoc """
  Favorite API Controller.
  """

  use HelloWeb, :controller

  alias Hello.Posts

  @doc """
  Favorite tweets.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    params = %{user_id: user_id, tweet_id: tweet_id}

    case Posts.favorite(params) do
      {:ok, _} ->
        render(conn, "success.json")

      {:error, %Ecto.Changeset{}} ->
        render(conn, "error.json")
    end
  end

  @doc """
  Unfavorite tweets.
  """
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    case Posts.unfavorite(tweet_id, user_id) do
      {1, nil} ->
        render(conn, "success.json")

      _ ->
        render(conn, "error.json")
    end
  end
end
