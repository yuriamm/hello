defmodule HelloWeb.TweetController do
  @moduledoc """
  This is the tweet module. It handles tweets related functionality.
  """
  use HelloWeb, :controller

  @doc """
  Shows the home page.
  """
  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
