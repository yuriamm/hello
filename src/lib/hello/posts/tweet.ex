defmodule Hello.Posts.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  @minimum_tweet_length 1
  @maximum_tweet_length 140

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          tweet: String.t()
        }
  schema "tweets" do
    field :tweet, :string, size: @maximum_tweet_length

    field :favorited, :boolean, virtual: true, default: false
    field :favorites_count, :integer, virtual: true, default: 0

    belongs_to :user, Hello.Accounts.User, foreign_key: :user_id
    has_many :favorites, Hello.Posts.Favorite, foreign_key: :user_id

    timestamps()
  end

  @spec changeset(map(), map(), integer()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = tweet, params, user_id) do
    tweet
    |> cast(params, [:tweet])
    |> validate_required([:tweet])
    |> validate_length(:tweet, min: @minimum_tweet_length, max: @maximum_tweet_length)
    |> put_change(:user_id, user_id)
  end
end
