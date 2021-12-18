defmodule GithubstarsLiveWeb.Api.RepositoryView do
  use GithubstarsLiveWeb, :view
  alias GithubstarsLiveWeb.Api.RepositoryView

  def render("index.json", %{repositories: repositories}) do
    %{data: render_many(repositories, RepositoryView, "repository.json")}
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, RepositoryView, "repository.json")}
  end

  def render("repository.json", %{repository: repository}) do
    %{id: repository.id,
      name: repository.name,
      description: repository.description,
      html_url: repository.html_url,
      language: repository.language,
      tags: repository.tags}
  end
end
