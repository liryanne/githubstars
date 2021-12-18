defmodule GithubstarsLive.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}

  schema "repositories" do
    field :description, :string
    field :html_url, :string
    field :language, :string
    field :name, :string
    field :tags, {:array, :string}
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:id ,:username, :name, :description, :html_url, :language, :tags])
    |> validate_required([:id, :username, :name, :description, :html_url, :language, :tags])
  end
end
