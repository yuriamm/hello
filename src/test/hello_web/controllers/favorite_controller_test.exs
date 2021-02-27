defmodule HelloWeb.FavoriteControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Posts

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:favorite) do
    {:ok, favorite} = Posts.create_favorite(@create_attrs)
    favorite
  end

  describe "index" do
    test "lists all favorites", %{conn: conn} do
      conn = get(conn, Routes.favorite_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Favorites"
    end
  end

  describe "new favorite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.favorite_path(conn, :new))
      assert html_response(conn, 200) =~ "New Favorite"
    end
  end

  describe "create favorite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.favorite_path(conn, :create), favorite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.favorite_path(conn, :show, id)

      conn = get(conn, Routes.favorite_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Favorite"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.favorite_path(conn, :create), favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Favorite"
    end
  end

  describe "edit favorite" do
    setup [:create_favorite]

    test "renders form for editing chosen favorite", %{conn: conn, favorite: favorite} do
      conn = get(conn, Routes.favorite_path(conn, :edit, favorite))
      assert html_response(conn, 200) =~ "Edit Favorite"
    end
  end

  describe "update favorite" do
    setup [:create_favorite]

    test "redirects when data is valid", %{conn: conn, favorite: favorite} do
      conn = put(conn, Routes.favorite_path(conn, :update, favorite), favorite: @update_attrs)
      assert redirected_to(conn) == Routes.favorite_path(conn, :show, favorite)

      conn = get(conn, Routes.favorite_path(conn, :show, favorite))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, favorite: favorite} do
      conn = put(conn, Routes.favorite_path(conn, :update, favorite), favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Favorite"
    end
  end

  describe "delete favorite" do
    setup [:create_favorite]

    test "deletes chosen favorite", %{conn: conn, favorite: favorite} do
      conn = delete(conn, Routes.favorite_path(conn, :delete, favorite))
      assert redirected_to(conn) == Routes.favorite_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.favorite_path(conn, :show, favorite))
      end
    end
  end

  defp create_favorite(_) do
    favorite = fixture(:favorite)
    %{favorite: favorite}
  end
end
