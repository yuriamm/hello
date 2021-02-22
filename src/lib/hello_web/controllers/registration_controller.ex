defmodule HelloWeb.RegistrationController do
  @moduledoc """
  This is the registration module. It handles user registration.
  """

  use HelloWeb, :controller

  alias Hello.Accounts.User
  alias Hello.Accounts

  @doc """
  Shows the registration page.
  """
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Registers users.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{} = user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Successfully signed up!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
