defmodule HelloWeb.LogoutControllerTest do
  use HelloWeb.ConnCase, async: true

  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }

  setup do
    conn = build_conn()
    user = %{user: @valid_registration}
    post(conn, Routes.registration_path(conn, :create), user)
    {:ok, conn: conn}
  end

  test "should logout user", %{conn: conn} do
    assert delete(conn, Routes.logout_path(conn, :delete)).status == 302
  end
end
