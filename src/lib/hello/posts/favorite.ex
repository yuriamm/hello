defmodule Hello.Posts.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    belongs_to :user, Hello.Accounts.User
    belongs_to :tweet, Hello.Posts.Tweet

    timestamps()
  end

  @doc false
  def changeset(favorite, params) do
    favorite
    |> cast(params, [:user_id, :tweet_id])
    |> validate_required([:user_id, :tweet_id])
    |> unique_constraint(:user_id, name: :favorites_user_id_tweet_id_index)
  end
end
