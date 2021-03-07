defmodule HelloWeb.TweetControllerTest do
  use HelloWeb.ConnCase, async: true
  import Hello.Factory

  describe "logged in user" do
    setup %{conn: conn} do
      tweet = insert(:tweet)

      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{username: tweet.user.username, password: "password"}
        )

      {:ok, conn: conn, tweet: tweet}
    end

    test "can list all tweets", %{conn: conn, tweet: tweet} do
      conn = get(conn, Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ tweet.tweet
    end

    test "can tweet when data is valid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.tweet_path(conn, :create), tweet: %{tweet: "valid_tweet"})
        |> get(Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ "valid_tweet"
    end

    test "can be redirected to index after tweeted successfully", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: %{tweet: "valid_tweet"})

      assert redirected_to(conn) == Routes.tweet_path(conn, :index)
    end

    test "can't tweet when data is invalid", %{conn: conn, tweet: tweet} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: %{tweet: nil})

      assert html_response(conn, 200) =~ tweet.tweet
    end

    test "can see errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: %{tweet: nil})

      assert get_flash(conn, :error) == "tweet: can't be blank"
    end

    test "can delete the user's own tweet", %{conn: conn, tweet: tweet} do
      conn =
        conn
        |> delete(Routes.tweet_path(conn, :delete, tweet.id))
        |> get(Routes.tweet_path(conn, :index))

      refute html_response(conn, 200) =~ tweet.tweet
    end
  end

  describe "not logged in user" do
    setup do
      insert(:user)
      tweet = insert(:tweet)

      {:ok, tweet: tweet}
    end

    test "lists all tweets if not logged in", %{tweet: tweet, conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ tweet.tweet
    end

    test "can't tweet", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: %{tweet: "valid_tweet"})

      refute html_response(conn, 200) =~ "valid_tweet"
    end

    test "can't delete tweet", %{conn: conn, tweet: tweet} do
      conn =
        conn
        |> delete(Routes.tweet_path(conn, :delete, tweet.id))
        |> get(Routes.tweet_path(conn, :index))

      assert html_response(conn, 200) =~ tweet.tweet
    end
  end
end
