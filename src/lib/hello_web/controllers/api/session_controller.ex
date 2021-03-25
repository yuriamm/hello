defmodule HelloWeb.API.SessionController do
  @moduledoc """
  Session API Controller.
  """
  use HelloWeb, :controller

  alias Hello.Session

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"password" => password, "username" => username}) do
    case Session.login(%{password: password, username: username}) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> render("success.json", user_id: user.id)

      {:error, "Error in verifying password."} ->
        render(conn, "error.json")

      {:error, "User doesn't exist."} ->
        render(conn, "error.json")

      {:error, "Username is empty."} ->
        render(conn, "error.json")
    end
  end

  @spec delete(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> render("success.json")
  end
end
