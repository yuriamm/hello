defmodule Hello.Posts.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Posts.Tweet
  alias Hello.Accounts.User

  @typedoc """
  A favorite post is chosen by a user.
  ## Associations
  user - the user that the like belongs to
  posts - the post that received the like
  """
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          tweet: Tweet.t(),
          user: User.t()
        }
  schema "favorites" do
    belongs_to :tweet, Hello.Posts.Tweet
    belongs_to :user, Hello.Accounts.User

    timestamps()
  end

  def changeset(favorite, params) do
    favorite
    |> cast(params, [:user_id, :tweet_id])
    |> validate_required([:user_id, :tweet_id])
    |> unique_constraint(:user_id, name: :favorites_user_id_tweet_id_index)
  end
end
