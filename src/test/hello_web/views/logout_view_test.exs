defmodule HelloWeb.LogoutViewTest do
  use HelloWeb.ConnCase, async: true

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
