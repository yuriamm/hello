defmodule Hello.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :tweet, :text, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:tweets, [:user_id])
  end
end
