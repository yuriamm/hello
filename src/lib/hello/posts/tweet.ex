defmodule Hello.Posts.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :tweet, :string, size: 140
    belongs_to :user, Hello.Accounts.User

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [])
    |> validate_required([])
  end
end
