defmodule GithubstarsLive.Repositories do
  import Ecto.Query, warn: false
  alias GithubstarsLive.Repo

  alias GithubstarsLive.Repositories.Repository

  def list_repositories(username) do
    list_repositories(username, "")
  end

  def list_repositories(username, search_tag) do
    tags =
      from r in Repository,
      select: %{id: r.id, tag: fragment("unnest(tags)")}

    query =
      from r in Repository,
      left_join: t in subquery(tags), on: r.id == t.id,
      where: r.username == ^(username) and ((ilike(t.tag, ^("%#{search_tag}%")) and ^(search_tag) != "") or ^(search_tag) == ""),
      select: r,
      distinct: true,
      order_by: r.name

      Repo.all(query)
  end

  def get_repository!(username, id) do
    Repo.get_by!(Repository, username: username, id: id)
  end

  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  defp create_repositories(repositories) do
    new_repositories = repositories
                      |> Enum.map(&Map.put(&1, :inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)))
                      |> Enum.map(&Map.put(&1, :updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)))

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all, Repository, new_repositories, on_conflict: :nothing)
    |> GithubstarsLive.Repo.transaction()
  end

  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  def change_repository(%Repository{} = repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end

  def get_repositories(username) do
    url = "https://api.github.com/users/" <> username <> "/starred"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Poison.decode!(body)
        repositories =
          Enum.map json, fn(repo) ->
            %{
              id: repo["id"],
              name: repo["name"],
              html_url: repo["html_url"],
              language: repo["language"],
              description: repo["description"],
              username: username,
              tags: []
            }
          end
        _repositories_add = create_repositories(repositories)
        repositories
    end
  end
end
