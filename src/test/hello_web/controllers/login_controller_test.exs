defmodule HelloWeb.LoginControllerTest do
  use HelloWeb.ConnCase, async: true

  @valid_attrs %{username: "username", password: "password"}
  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }
  @invalid_username %{username: "username", password: "incorrect_password"}
  @invalid_password %{username: "username", password: "incorrect_password"}

  setup do
    conn = build_conn()
    user = %{user: @valid_registration}
    post(conn, Routes.registration_path(conn, :create), user)
    {:ok, conn: conn}
  end

  test "should not login with incorrect username or password", %{conn: conn} do
    assert post(conn, Routes.login_path(conn, :create), session: @invalid_username).status == 200
    assert post(conn, Routes.login_path(conn, :create), session: @invalid_password).status == 200
  end

  test "should login with correct username and password", %{conn: conn} do
    assert post(conn, Routes.login_path(conn, :create), session: @valid_attrs).status == 302
  end
end
