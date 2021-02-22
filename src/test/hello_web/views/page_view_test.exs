defmodule HelloWeb.PageViewTest do
  use HelloWeb.ConnCase, async: true

  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }

  test "show logout if logged in", %{conn: conn} do
    content =
      conn
      |> post(Routes.registration_path(conn, :create), %{user: @valid_registration})
      |> get(Routes.page_path(conn, :index))
      |> html_response(200)

    assert content =~ "Logout"
  end

  test "has expected form fields", %{conn: conn} do
    content =
      conn
      |> get(Routes.page_path(conn, :index))
      |> html_response(200)

    Enum.map(["Login", "Register"], fn item ->
      assert content =~ item
    end)
  end
end
