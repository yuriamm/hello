defmodule HelloWeb.LoginViewTest do
  use HelloWeb.ConnCase, async: true

  test "has expected form fields", %{conn: conn} do
    content = 
        conn 
        |> get(Routes.login_path(conn, :index)) 
        |> html_response(200)
    Enum.map(["Username", "Password"], fn item ->
      assert content =~ item
    end)
  end
end