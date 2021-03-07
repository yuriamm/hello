defmodule Hello.Posts.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.Accounts.User

  @minimum_tweet_length 1
  @maximum_tweet_length 140

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          tweet: String.t(),
          user: User.t()
        }
  schema "tweets" do
    field :tweet, :string, size: @maximum_tweet_length
    belongs_to :user, User

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = tweet, params) do
    tweet
    |> cast(params, [:tweet, :user_id])
    |> validate_required([:tweet, :user_id])
    |> validate_length(:tweet, min: @minimum_tweet_length, max: @maximum_tweet_length)
  end
end
