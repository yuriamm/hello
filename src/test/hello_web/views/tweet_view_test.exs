defmodule HelloWeb.TweetViewTest do
  use HelloWeb.ConnCase, async: true

  describe "index" do
    test "shows tweet form if logged in", %{conn: conn} do
      content =
        conn
        |> post(Routes.registration_path(conn, :create), %{
          user: %{
            username: "username",
            password: "password",
            password_confirmation: "password"
          }
        })
        |> get(Routes.tweet_path(conn, :index))
        |> html_response(200)

      assert content =~ "Tweet"
    end

    test "shows delete if the user is logged in and is tweeted by the user", %{conn: conn} do
      content =
        conn
        |> post(Routes.registration_path(conn, :create), %{
          user: %{
            username: "username",
            password: "password",
            password_confirmation: "password"
          }
        })
        |> post(Routes.tweet_path(conn, :create), %{tweet: %{tweet: "tweet"}})
        |> get(Routes.tweet_path(conn, :index))
        |> html_response(200)

      assert content =~ "delete"
    end

    test "only shows tweets if not logged in", %{conn: conn} do
      content =
        conn
        |> get(Routes.page_path(conn, :index))
        |> html_response(200)

      refute content =~ "Tweet"
      refute content =~ "delete"
    end
  end
end
