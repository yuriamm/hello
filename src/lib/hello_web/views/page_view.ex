defmodule HelloWeb.PageView do
  use HelloWeb, :view

  @doc """
  Returns current user.
  """
  # CURRENT USER ID IS NOT PASSED IN HERE
  @spec is_logged_in(Plug.Conn.t()) :: boolean()
  def is_logged_in(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    not is_nil(user_id)
  end
end
