defmodule HelloWeb.TweetViewTest do
  use HelloWeb.ConnCase, async: true

  import Phoenix.View
  import Hello.Factory

  describe "index" do
    setup do
      favorites = insert_list(3, :favorite)
      tweets = Enum.map(favorites, fn favorite -> favorite.tweet end)

      {:ok, tweets: tweets}
    end

    test "shows tweet form if logged in", %{conn: conn, tweets: tweets} do
      conn = init_test_session(conn, current_user_id: "1")

      content =
        render_to_string(HelloWeb.TweetView, "index.html", conn: conn, tweets: tweets, user_id: 1)

      assert content =~ "Tweet"
    end

    test "shows favorite/unfavorite if logged in", %{conn: conn, tweets: tweets} do
      conn = init_test_session(conn, current_user_id: "1")

      content =
        render_to_string(HelloWeb.TweetView, "index.html", conn: conn, tweets: tweets, user_id: 1)

      assert content =~ "Tweet"
    end

    test "only shows tweets if not logged in", %{conn: conn, tweets: tweets} do
      conn = init_test_session(conn, current_user_id: nil)

      content =
        render_to_string(HelloWeb.TweetView, "index.html", conn: conn, tweets: tweets, user_id: "")

      refute content =~ "<button type=\"submit\">Tweet</button>"
      refute content =~ "delete"
    end
  end
end
