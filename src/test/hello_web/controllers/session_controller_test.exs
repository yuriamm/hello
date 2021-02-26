defmodule HelloWeb.SessionControllerTest do
  use HelloWeb.ConnCase, async: true

  @valid_attrs %{username: "username", password: "password"}
  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }
  @invalid_username %{username: "incorrect_username", password: "password"}
  @invalid_password %{username: "username", password: "incorrect_password"}

  setup do
    conn = build_conn()
    post(conn, Routes.registration_path(conn, :create), user: @valid_registration)
    {:ok, conn: conn}
  end

  describe "should login" do
    test "with correct username and password", %{conn: conn} do
      assert post(conn, Routes.session_path(conn, :create), session: @valid_attrs).status == 302
    end
  end

  describe "should not login" do
    test "with incorrect username", %{conn: conn} do
      assert post(conn, Routes.session_path(conn, :create), session: @invalid_username).status ==
               200
    end

    test "with incorrect password", %{conn: conn} do
      assert post(conn, Routes.session_path(conn, :create), session: @invalid_password).status ==
               200
    end
  end

  test "should logout user", %{conn: conn} do
    assert delete(conn, Routes.session_path(conn, :delete)).status == 302
  end
end
