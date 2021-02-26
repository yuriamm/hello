defmodule HelloWeb.SignupControllerTest do
  use HelloWeb.ConnCase, async: true

  @valid_registration %{
    username: "username",
    password: "password",
    password_confirmation: "password"
  }

  test "should signup", %{conn: conn} do
    assert post(conn, Routes.registration_path(conn, :create), user: @valid_registration).status ==
             302
  end
end
