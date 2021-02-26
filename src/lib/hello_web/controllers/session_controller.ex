defmodule HelloWeb.SessionController do
  @moduledoc """
  This is the session module. It handles user session.
  """
  use HelloWeb, :controller

  alias Hello.Session

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
  def create(conn, %{"session" => %{"password" => password, "username" => username}}) do
    case Session.login(%{password: password, username: username}) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You're logged in!")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:error, "Error in verifying password."} ->
        conn
        |> put_flash(:error, "Wrong username/password!")
        |> render("index.html")

      {:error, "User doesn't exist."} ->
        conn
        |> put_flash(:error, "User doesn't exist.")
        |> render("index.html")

      {:error, "Username is empty."} ->
        conn
        |> put_flash(:error, "Username can't be empty.")
        |> render("index.html")
    end
  end

  @doc """
  Logs out user.
  """
  @spec delete(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Successfully signed out!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
