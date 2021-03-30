defmodule HelloWeb.API.FavoriteView do
  use HelloWeb, :view

  def render("success.json", _) do
    %{
      message: "success"
    }
  end

  def render("error.json", _) do
    %{
      message: "error"
    }
  end

  def render("favorite.json", %{tweet: tweet}) do
    %{
      message: "favorited",
      id: tweet.id
    }
  end
end
