defmodule Hello.Login do
  alias Hello.Accounts.User
  alias Hello.Repo

  @doc """
  Receives user info and do authentication.
  """
  @spec login(map()) :: {:ok, User.t() | nil} | :error
  def login(%{"password" => password, "username" => username}) do
    user = Repo.get_by(User, username: username)

    #IS IT EVEN POSSIBLE TO PATTERN MATCH WHEN HANDLING ERRORS...
    case authenticate(user, password) do
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
end
