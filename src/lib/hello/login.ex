defmodule Hello.Login do
  alias Hello.Accounts.User
  alias Hello.Repo

  @doc """
  Receives user info and do authentication.
  """
  @spec login(map()) :: {:ok, User.t() | nil} | :error
  def login(%{"password" => password, "username" => username}) do
    user = Repo.get_by(User, username: username)

    if Bcrypt.verify_pass(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, "Error in verifying password."}
    end
  end
end
