defmodule Hello.Accounts do
  alias Hello.Accounts.User
  alias Hello.Repo

  @doc """
  Creates a user.
  """
  @spec create_user(map()) :: {:ok, User.t() | nil} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
