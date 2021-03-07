defmodule HelloWeb.TweetController do
  @moduledoc """
  This is the tweet module. It handles tweets related functionality.
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
    render(conn, "index.html", tweets: tweets, user_id: user_id)
  end

  @doc """
  Handles tweet function.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"tweet" => tweet_params}) do
    tweets = Posts.get_all_tweets()
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    params = Map.put(tweet_params, "user_id", user_id)

    case Posts.create_tweet(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Tweeted.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        error_message =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)
          |> Enum.map(fn {key, errors} -> "#{key}: #{Enum.join(errors, ", ")}" end)
          |> Enum.join("\n")

        conn
        |> put_flash(:error, error_message)
        |> render("index.html", tweets: tweets, user_id: user_id)
    end
  end

  @doc """
  Handles deleting tweet function.
  """
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    cond do
      !user_id ->
        conn
        |> put_flash(:error, "You must login.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      Posts.get_tweet!(id).user_id != user_id ->
        conn
        |> put_flash(:error, "Failed to delete tweet.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      true ->
        Posts.delete_tweet(id)

        conn
        |> put_flash(:info, "Tweet deleted successfully.")
        |> redirect(to: Routes.tweet_path(conn, :index))
    end
  end
end
