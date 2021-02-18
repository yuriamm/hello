defmodule HelloWeb.LogoutController do
  @moduledoc """
  This is the logout module. It handles user logout.
  """
  use HelloWeb, :controller

  @doc """
  Logs out user.
  """
  @spec delete(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Successfully signed out!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
