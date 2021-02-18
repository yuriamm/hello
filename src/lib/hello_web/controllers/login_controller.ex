defmodule HelloWeb.LoginController do
  @moduledoc """
  This is the login module. It handles user login.
  """
  use HelloWeb, :controller

  alias Hello.Login
  alias Hello.Repo

  @doc """
  Shows the login page.
  """
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Handles user login.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"session" => session_params}) do
    case Login.login(session_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "You're logged in!")
        |> redirect(to: Routes.page_path(conn, :index))

      :error ->
        conn
        |> put_flash(:error, "Wrong username/password!")
        |> render("index.html")
    end
  end
end
