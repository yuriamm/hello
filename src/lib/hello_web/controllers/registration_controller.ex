defmodule HelloWeb.RegistrationController do
  @moduledoc """
  This is the registration module. It handles user registration.
  """

  use HelloWeb, :controller

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
  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Successfully signed up!")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        error_message =
          errors
          |> Enum.map(fn {key, errors} -> "#{key}: #{Enum.join(errors, ", ")}" end)
          |> Enum.join("\n")

        conn
        |> put_flash(:error, error_message)
        |> render("index.html")
    end
  end
end
