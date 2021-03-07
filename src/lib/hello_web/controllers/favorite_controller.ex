defmodule HelloWeb.FavoriteController do
  use HelloWeb, :controller

  alias Hello.Posts

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

  def delete(conn, %{"id" => tweet_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    cond do
      !user_id ->
        conn
        |> put_flash(:error, "You must login.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      !Posts.get_favorite_by_user(user_id, tweet_id) ->
        conn
        |> put_flash(:error, "Failed to unfavorite.")
        |> redirect(to: Routes.tweet_path(conn, :index))

      true ->
        Posts.unfavorite(tweet_id, user_id)

        conn
        |> put_flash(:info, "Unfavorited successfully.")
        |> redirect(to: Routes.tweet_path(conn, :index))
    end
  end
end
