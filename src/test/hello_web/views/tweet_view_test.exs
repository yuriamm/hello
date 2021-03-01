defmodule HelloWeb.TweetViewTest do
  use HelloWeb.ConnCase, async: true

  import Phoenix.View
  import Hello.Factory

  describe "index" do
    test "shows tweet form if logged in", %{conn: conn} do
      conn = init_test_session(conn, current_user_id: "1")
      tweets = build_list(3, :tweet)

      content =
        render_to_string(HelloWeb.TweetView, "index.html",
          conn: conn,
          tweets: tweets,
          user_id: 1
        )

      assert content =~ "Tweet"
    end

    test "only shows tweets if not logged in", %{conn: conn} do
      conn = init_test_session(conn, current_user_id: nil)
      tweets = build_list(3, :tweet)

      content =
        render_to_string(HelloWeb.TweetView, "index.html",
          conn: conn,
          tweets: tweets,
          user_id: ""
        )

      refute content =~ "<button type=\"submit\">Tweet</button>"
      refute content =~ "delete"
    end
  end
end
