defmodule Hello.Login do
  alias Hello.User

  @spec login(map(), Ecto.Repo.t()) :: {:ok, Ecto.Schema.t() | nil} | :error
  def login(params, repo) do
    user = repo.get_by(User, username: params["username"])

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _ -> :error
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
