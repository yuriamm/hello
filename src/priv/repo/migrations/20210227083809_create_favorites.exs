defmodule Hello.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do

      timestamps()
    end

  end
end
