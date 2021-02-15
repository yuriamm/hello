defmodule HelloWeb.LoginController do
    @moduledoc """
    This is the login module. It handles user login.
    """
    use HelloWeb, :controller

    alias Hello.User
    alias Hello.Repo

    @doc """
    Shows the login page.
    """
    def index(conn, _params) do
        render conn, "index.html"
    end

    @doc """
    Handles user login.
    """
    @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
    def create(conn, %{"session" => session_params}) do
        case login(session_params, Repo) do
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

    defp login(params, repo) do
        user = repo.get_by(User, username: params["username"])
        case authenticate(user, params["password"]) do
            true -> {:ok, user}
            _    -> :error
        end
    end

    defp authenticate(user, password) when is_map(user) and is_binary(password) do
        Bcrypt.verify_pass(password, user.encrypted_password)   
    end

    defp authenticate(_, _) do
        {:error, "Incorrect arguments."}
    end
    
    @doc """
    Returns current user.
    """
    @spec get_current_user(Plug.Conn.t()) :: Plug.Conn.t()
    def get_current_user(conn) do
        case conn.assigns[:current_user] do
            nil ->
                Plug.Conn.get_session(conn, :current_user)
            current_user ->
                current_user
        end
  end
end