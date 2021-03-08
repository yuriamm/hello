defmodule Hello.Posts do
  import Ecto.Query
  alias Hello.Repo

  alias Hello.Posts.Tweet
  alias Hello.Posts.Favorite

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

  @doc """
  Gets favorites for a tweet.
  """
  @spec get_favorite_by_tweet!(integer()) :: non_neg_integer() | nil
  def get_favorite_by_tweet!(tweet_id) do
    Favorite
    |> where(tweet_id: ^tweet_id)
    |> select([t], count(t.id))
    |> Repo.one()
  end

  @doc """
  Gets favorites by user id.
  """
  @spec get_favorite_by_user(integer(), integer()) :: boolean()
  def get_favorite_by_user(user_id, tweet_id) do
    Favorite
    |> where(user_id: ^user_id, tweet_id: ^tweet_id)
    |> Repo.exists?()
  end

  @doc """
  Favorite a tweet.
  """
  @spec favorite(map()) :: {:ok, Favorite.t()} | {:error, Ecto.Changeset.t()}
  def favorite(params) do
    %Favorite{}
    |> Favorite.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Unfavorite a tweet.
  """
  @spec unfavorite(integer(), integer()) :: {:ok, Favorite.t()} | {:error, Ecto.Changeset.t()}
  def unfavorite(tweet_id, user_id) do
    Favorite
    |> where([f], f.tweet_id == ^tweet_id and f.user_id == ^user_id)
    |> Repo.delete()
  end
end
