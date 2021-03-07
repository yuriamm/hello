defmodule HelloWeb.SessionViewTest do
  use HelloWeb.ConnCase, async: true

  import Phoenix.View

  test "has expected form fields", %{conn: conn} do
    conn = init_test_session(conn, current_user_id: "1")

    content = render_to_string(HelloWeb.SessionView, "index.html", conn: conn)

    Enum.map(["Username", "Password"], fn item ->
      assert content =~ item
    end)
  end
end
