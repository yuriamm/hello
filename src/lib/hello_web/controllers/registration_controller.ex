defmodule HelloWeb.RegistrationController do
  @moduledoc """
  This is the registration module. It handles user registration.
  """

  use HelloWeb, :controller

  alias Hello.User
  alias Hello.Repo

  @doc """
  Shows the registration page.
  """
  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", changeset: changeset
  end

  @doc """
  Registers users. 
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    case create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Successfully signed up!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  defp create_user(params \\ %{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end