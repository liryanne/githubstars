defmodule GithubstarsLive.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories, primary_key: false) do
      add :id, :integer, primary_key: true
      add :username, :string, primary_key: true
      add :name, :string
      add :description, :text
      add :html_url, :string
      add :language, :string
      add :tags, {:array, :string}

      timestamps()
    end

  end
end
