defmodule HelloWeb.LoginController do
    use HelloWeb, :controller

    alias Hello.User
    alias Hello.Repo

    def index(conn, _params) do
        render conn, "index.html"
    end

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

    def login(params, repo) do
        user = repo.get_by(User, username: params["username"])
        case authenticate(user, params["password"]) do
            true -> {:ok, user}
            _    -> :error
        end
    end

    defp authenticate(user, password) do
        case user do
            nil -> false
            _   -> Bcrypt.verify_pass(password, user.encrypted_password)
        end   
    end

    def get_current_user(conn) do
        case conn.assigns[:current_user] do
            nil ->
                Plug.Conn.get_session(conn, :current_user)
            current_user ->
                current_user
        end
  end
end