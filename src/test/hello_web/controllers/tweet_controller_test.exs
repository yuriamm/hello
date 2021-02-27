defmodule HelloWeb.TweetControllerTest do
  use HelloWeb.ConnCase, async: true

  alias Hello.Accounts
  alias Hello.Posts

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        password: "password",
        password_confirmaton: "password",
        username: "username"
      })

    {:ok, tweet} = Posts.create_tweet(%{tweet: "tweet"}, user.id)

    {:ok, tweet: tweet}
  end

  describe "index" do
    test "lists all tweets if logged in", %{conn: conn} do
      conn =
        conn
        |> post(Routes.session_path(conn, :create),
          session: %{username: "username", password: "password"}
        )
        |> get(Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ "tweet"
    end

    test "lists all tweets if not logged in", %{conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ "tweet"
    end
  end

  describe "create tweet" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.session_path(conn, :create),
          session: %{username: "username", password: "password"}
        )
        |> post(Routes.tweet_path(conn, :create), tweet: %{tweet: "valid_tweet"})
        |> get(Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ "valid_tweet"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.session_path(conn, :create),
          session: %{username: "username", password: "password"}
        )
        |> post(Routes.tweet_path(conn, :create), tweet: %{tweet: nil})

      assert get_flash(conn, :error) == "tweet: can't be blank"
      assert html_response(conn, 200) =~ "tweet"
    end
  end

  describe "delete tweet" do
    test "deletes chosen tweet", %{conn: conn, tweet: tweet} do
      conn = delete(conn, Routes.tweet_path(conn, :delete, tweet.id))

      assert get_flash(conn, :info) == "Tweet deleted successfully."
    end
  end
end
