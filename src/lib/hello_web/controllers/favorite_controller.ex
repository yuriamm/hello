defmodule HelloWeb.FavoriteController do
  @moduledoc """
  This is favorite module. It handles favorite related functionality.
  """
  use HelloWeb, :controller

  alias Hello.Posts

  @doc """
  Favorite tweets.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"tweet_id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    params = %{user_id: user_id, tweet_id: tweet_id}

    case Posts.favorite(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Favorited.")
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
        |> redirect(to: Routes.tweet_path(conn, :index))
    end
  end

  @doc """
  Unfavorite tweets.
  """
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    IO.inspect(user_id)

    cond do
      !user_id ->
        IO.inspect(label: 'youaa?')

        conn
        |> put_flash(:error, "You must login.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      !Posts.get_favorite_by_user(user_id, tweet_id) ->
        IO.inspect(label: 'a?')

        conn
        |> put_flash(:error, "Failed to unfavorite.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      true ->
        Posts.unfavorite(tweet_id, user_id)
        IO.inspect(label: 'you?')

        conn
        |> put_flash(:info, "Unfavorited successfully.")
        |> redirect(to: Routes.tweet_path(conn, :index))
    end
  end
end
