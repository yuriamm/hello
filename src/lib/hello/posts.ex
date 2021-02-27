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

  ## Examples

      iex> list_favorites()
      [%Favorite{}, ...]

  """
  def list_favorites do
    Repo.all(Favorite)
  end

  @doc """
  Gets a single favorite.

  Raises `Ecto.NoResultsError` if the Favorite does not exist.

  ## Examples

      iex> get_favorite!(123)
      %Favorite{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite!(id), do: Repo.get!(Favorite, id)

  @doc """
  Creates a favorite.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %Favorite{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(attrs \\ %{}) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favorite.

  ## Examples

      iex> update_favorite(favorite, %{field: new_value})
      {:ok, %Favorite{}}

      iex> update_favorite(favorite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite(%Favorite{} = favorite, attrs) do
    favorite
    |> Favorite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%Favorite{} = favorite) do
    Repo.delete(favorite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite changes.

  ## Examples

      iex> change_favorite(favorite)
      %Ecto.Changeset{data: %Favorite{}}

  """
  def change_favorite(%Favorite{} = favorite, attrs \\ %{}) do
    Favorite.changeset(favorite, attrs)
  end
end
