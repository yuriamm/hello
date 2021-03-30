defmodule HelloWeb.RegistrationController do
  @moduledoc """
  This is the registration module. It handles user registration.
  """
  use HelloWeb, :controller

  @doc """
  Shows the registration page.
  """
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
