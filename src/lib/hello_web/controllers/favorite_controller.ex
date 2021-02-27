defmodule HelloWeb.FavoriteController do
  use HelloWeb, :controller

  alias Hello.Posts
  alias Hello.Posts.Favorite

  def index(conn, _params) do
    favorites = Posts.list_favorites()
    render(conn, "index.html", favorites: favorites)
  end

  def new(conn, _params) do
    changeset = Posts.change_favorite(%Favorite{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"favorite" => favorite_params}) do
    case Posts.create_favorite(favorite_params) do
      {:ok, favorite} ->
        conn
        |> put_flash(:info, "Favorite created successfully.")
        |> redirect(to: Routes.favorite_path(conn, :show, favorite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    favorite = Posts.get_favorite!(id)
    render(conn, "show.html", favorite: favorite)
  end

  def edit(conn, %{"id" => id}) do
    favorite = Posts.get_favorite!(id)
    changeset = Posts.change_favorite(favorite)
    render(conn, "edit.html", favorite: favorite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "favorite" => favorite_params}) do
    favorite = Posts.get_favorite!(id)

    case Posts.update_favorite(favorite, favorite_params) do
      {:ok, favorite} ->
        conn
        |> put_flash(:info, "Favorite updated successfully.")
        |> redirect(to: Routes.favorite_path(conn, :show, favorite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", favorite: favorite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    favorite = Posts.get_favorite!(id)
    {:ok, _favorite} = Posts.delete_favorite(favorite)

    conn
    |> put_flash(:info, "Favorite deleted successfully.")
    |> redirect(to: Routes.favorite_path(conn, :index))
  end
end
