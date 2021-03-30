defmodule HelloWeb.API.RegistrationController do
  @moduledoc """
  Registration API Controller.
  """
  use HelloWeb, :controller

  alias Hello.Accounts

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, %{id: id}} ->
        conn
        |> put_session(:current_user_id, id)
        |> render("success.json", user_id: id)

      {:error, %Ecto.Changeset{}} ->
        render(conn, "error.json")
    end
  end
end
