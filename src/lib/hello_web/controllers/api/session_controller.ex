defmodule HelloWeb.API.SessionController do
  @moduledoc """
  Session API Controller.
  """
  use HelloWeb, :controller

  alias Hello.Session

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"password" => password, "username" => username}) do
    case Session.login(%{password: password, username: username}) do
      {:ok, %{id: id}} ->
        conn
        |> put_session(:current_user_id, id)
        |> render("success.json", user_id: id)

      {:error, _} ->
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
