defmodule GithubstarsLiveWeb.Api.RepositoryController do
  use GithubstarsLiveWeb, :controller

  alias GithubstarsLive.Repositories
  alias GithubstarsLive.Repositories.Repository

  action_fallback GithubstarsLiveWeb.FallbackController

  def git(conn, %{"username" => username}) do
    repositories = Repositories.get_repositories(username)
    render(conn,"index.json", repositories: repositories)
  end

  def index(conn, params) do
    username = params["username"]
    tag = Map.get(params, "tag", "")
    repositories = Repositories.list_repositories(username, tag)
    render(conn, "index.json", repositories: repositories)
  end

  def update(conn, %{"id" => id, "username" => username, "repository" => repository_params}) do
    repository = Repositories.get_repository!(username, id)

    with {:ok, %Repository{} = repository} <- Repositories.update_repository(repository, repository_params) do
      render(conn, "show.json", repository: repository)
    end
  end
end
