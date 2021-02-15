defmodule Hello.User do
    use Ecto.Schema

    import Ecto.Changeset

    alias Hello.User

    schema "users" do
        field :username, :string
        field :password, :string, virtual: true
        field :password_confirmation, :string, virtual: true
        field :encrypted_password, :string
        timestamps()
    end

    def changeset(%User{} = user, params \\ %{}) do
        user
        |> cast(params, [:username, :password])
        |> validate_required([:username, :password])
        |> validate_length(:password, min: 6)
        |> validate_length(:username, min: 6)
        |> validate_confirmation(:password)
        |> unique_constraint(:username)
        |> encrypt_password
    end

    defp encrypt_password(changeset) do
        password = get_change(changeset, :password)
        if password do
            encrypted_password = Bcrypt.hash_pwd_salt(password)
            put_change(changeset, :encrypted_password, encrypted_password)
        else
            changeset
        end
    end
end