defmodule Hello.Session do
  alias Hello.Accounts.User
  alias Hello.Repo

  @doc """
  Receives user info and do authentication.
  """
  @spec login(map()) :: {:ok, User.t()} | {:error, String.t()}
  def login(%{username: nil}) do
    {:error, "Username is empty."}
  end

  def login(%{password: password, username: username}) do
    user = Repo.get_by(User, username: username)

    cond do
      !user ->
        {:error, "User doesn't exist."}

      !Bcrypt.verify_pass(password, user.encrypted_password) ->
        {:error, "Error in verifying password."}

      true ->
        {:ok, user}
    end
  end

  @doc """
  Returns if an user is logged in.
  """
  @spec is_logged_in(Plug.Conn.t()) :: boolean()
  def is_logged_in(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    not is_nil(user_id)
  end
end
