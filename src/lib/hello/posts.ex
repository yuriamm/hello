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
    |> preload(:user)
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single tweet by id.
  """
  @spec get_tweet!(integer()) :: Tweet.t()
  def get_tweet!(id) do
    Tweet
    |> preload(:user)
    |> Repo.get(id)
  end

  @doc """
  Creates a tweet.
  """
  @spec create_tweet(map()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def create_tweet(tweet) do
    %Tweet{}
    |> Tweet.changeset(tweet)
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
