defmodule HelloWeb.API.RegistrationController do
  @moduledoc """
  Registration API Controller.
  """
  use HelloWeb, :controller

  alias Hello.Accounts

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> render("success.json", user_id: user.id)

      {:error, %Ecto.Changeset{}} ->
        render(conn, "error.json")
    end
  end
end
