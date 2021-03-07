defmodule Hello.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :tweet_id, references(:tweets)
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:favorites, [:user_id, :tweet_id])
  end
end
