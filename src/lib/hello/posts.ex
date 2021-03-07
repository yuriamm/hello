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
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @spec get_tweet!(integer()) :: Tweet.t()
  def get_tweet!(id) do
    Tweet
    |> Repo.get(id)
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
  @spec delete_tweet(Tweet.t()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Gets favorites for a tweet.
  """
  def get_favorite!(tweet, user) do
    query = from(f in Favorite, where: f.tweet_id == ^tweet.id and f.user_id == ^user.id)

    case Repo.one(query) do
      %Favorite{} -> Map.put(tweet, :favorited, true)
      _ -> tweet
    end
  end

  @doc """
  Favorite a tweet.
  """
  def favorite(user, tweet) do
    %Favorite{}
    |> Favorite.changeset(user, tweet)
    |> Repo.insert()
  end

  @doc """
  Unfavorite a tweet.
  """
  def unfavorite(tweet, user) do
    Favorite
    |> Repo.get_by!(user_id: user.id, tweet_id: tweet.id)
    |> Repo.delete()
  end
end
