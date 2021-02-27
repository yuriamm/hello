defmodule Hello.Posts do
  import Ecto.Query
  alias Hello.Repo

  alias Hello.Posts.Tweet

  @doc """
  Gets all tweets.
  """
  @spec get_all_tweets :: Tweet.t() | {:error, String.t()}
  def get_all_tweets do
    Tweet
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single tweet by id.
  """
  @spec get_tweet!(integer()) :: Tweet.t()
  def get_tweet!(id) do
    Repo.get(Tweet, id)
  end

  @doc """
  Creates a tweet.
  """
  @spec create_tweet(map(), integer()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def create_tweet(tweet, user_id) do
    %Tweet{}
    |> Tweet.changeset(tweet, user_id)
    |> Repo.insert()
  end

  @doc """
  Deletes a tweet.
  """
  @spec delete_tweet(integer()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def delete_tweet(id) do
    Tweet
    |> Repo.get_by!(id: id)
    |> Repo.delete()
  end
end
