defmodule HelloWeb.SessionController do
  @moduledoc """
  This is the session module. It handles user session.
  """
  use HelloWeb, :controller

  @doc """
  Shows the login page.
  """
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
