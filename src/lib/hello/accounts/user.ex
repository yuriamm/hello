defmodule Hello.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @minimum_password_length 6
  @minimum_username_length 6

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          username: String.t(),
          password: String.t(),
          encrypted_password: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  schema "users" do
    field(:username, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:encrypted_password, :string)

    has_many(:tweets, Hello.Posts.Tweet)
    has_many(:favorites, Hello.Posts.Favorite)

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> put_encrypt_password()
    |> validate_required([:username, :password, :encrypted_password])
    |> validate_length(:password, min: @minimum_password_length)
    |> validate_length(:username, min: @minimum_username_length)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
  end

  defp put_encrypt_password(changeset) do
    password = get_change(changeset, :password, "")
    encrypted_password = Bcrypt.hash_pwd_salt(password)
    put_change(changeset, :encrypted_password, encrypted_password)
  end
end
