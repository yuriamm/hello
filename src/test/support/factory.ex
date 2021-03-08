defmodule Hello.Factory do
  use ExMachina.Ecto, repo: Hello.Repo

  alias Hello.Accounts.User
  alias Hello.Posts.Tweet
  alias Hello.Posts.Favorite

  def user_factory do
    %User{
      username: sequence(:username, &"User #{&1}"),
      password: "password",
      password_confirmation: "password",
      encrypted_password: Bcrypt.hash_pwd_salt("password")
    }
  end

  def tweet_factory do
    %Tweet{
      tweet: sequence(:tweet, &"Tweet #{&1}"),
      user: build(:user)
    }
  end

  def favorite_factory do
    user = insert(:user)

    %Favorite{
      tweet: insert(:tweet, user: user),
      user: user
    }
  end

  def with_favorite(%User{} = user) do
    tweet = insert(:tweet, user: user)
    insert(:favorite, tweet: tweet, user: user)
    user
  end

  def with_favorite(%Tweet{} = tweet) do
    insert(:favorite, tweet: tweet, user: tweet.user)
    tweet
  end
end
