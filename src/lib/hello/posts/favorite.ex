defmodule Hello.Posts.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    belongs_to :user, Hello.Accounts.User
    belongs_to :tweet, Hello.Posts.Tweet

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [])
    |> validate_required([])
  end
end
