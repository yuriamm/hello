defmodule HelloWeb.FavoriteControllerTest do
  use HelloWeb.ConnCase
  import Hello.Factory

  describe "logged in user" do
    setup %{conn: conn} do
      tweet = insert(:tweet)
      favorite = insert(:favorite)

      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: favorite.tweet.user.username, password: "password"}
        )

      {:ok, conn: conn, tweet: tweet, favorite: favorite}
    end

    test "can favorite", %{conn: conn, tweet: tweet} do
      conn = post(conn, Routes.favorite_path(conn, :create, tweet_id: tweet.id))

      assert get_flash(conn, :info) =~ "Favorited."
      assert html_response(conn, 302)
    end

    # TODO:
    # test "can unfavorite", %{conn: conn, favorite: favorite} do
    #   conn = delete(conn, Routes.favorite_path(conn, :delete, favorite.tweet_id))

    #   assert get_flash(conn, :info) =~ "Unfavorited successfully."
    # end
  end

  describe "not logged in user" do
    setup do
      tweet = insert(:tweet)
      favorite = insert(:favorite)

      {:ok, tweet: tweet, favorite: favorite}
    end

    test "can't favorite", %{conn: conn, tweet: tweet} do
      conn = post(conn, Routes.favorite_path(conn, :create, tweet_id: tweet.id))

      assert get_flash(conn, :error) =~ "user_id: can't be blank"
    end

    test "can't unfavorite", %{conn: conn, tweet: tweet, favorite: favorite} do
      conn = delete(conn, Routes.tweet_path(conn, :delete, favorite.tweet_id))

      assert get_flash(conn, :error) =~ "You must login."
      assert html_response(conn, 302)
    end
  end
end
