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

  alias Hello.Posts.Favorite

  @doc """
  Returns the list of favorites.
  """
  def list_favorites(tweet, user) do
  end

  @doc """
  Gets a single favorite.
  """
  def get_favorite!(tweet, user) do
    query = from(f in Favorite, where: f.tweet_id == ^tweet.id and f.user_id == ^user.id)

    case Repo.one(query) do
      %Favorite{} -> Map.put(tweet, :favorited, true)
      _ -> tweet
    end
  end

  @doc """
  Creates a favorite.
  """
  def favorite(params) do
    %Favorite{}
    |> Favorite.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Deletes a favorite.
  """
  def unfavorite(tweet, user) do
    Favorite
    |> Repo.get_by!(user_id: user.id, tweet_id: tweet.id)
    |> Repo.delete()
  end
end
