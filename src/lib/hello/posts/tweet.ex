defmodule Hello.Posts.Tweets do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tweets" do
    field :tweet, :string, size: 140
    belongs_to :user, Hello.Accounts.User

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = tweet, params \\ %{}) do
    tweet
    |> cast(params, [:tweet])
    |> validate_required([:tweet])
    |> validate_length(:tweet, min: 1, max: 140)
  end
end
