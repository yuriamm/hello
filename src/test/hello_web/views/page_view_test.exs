defmodule HelloWeb.PageViewTest do
  use HelloWeb.ConnCase, async: true

  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }
  ##TODO:Write Test for is logged in
  test "show logout if logged in", %{conn: conn} do
    content =
      conn
      |> post(Routes.registration_path(conn, :create), %{user: @valid_registration})
      |> get(Routes.page_path(conn, :index))
      |> html_response(200)

      assert content =~ "Logout"
  end
end
