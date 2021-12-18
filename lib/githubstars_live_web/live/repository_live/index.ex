defmodule GithubstarsLiveWeb.RepositoryLive.Index do
  use GithubstarsLiveWeb, :live_view

  alias GithubstarsLive.Repositories
  #alias GithubstarsLive.Repositories.Repository

  @impl true
  def mount(params, _session, socket) do
    username = params["username"]
    {:ok, assign(socket, :repositories, list_repositories(username))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"username" => username, "id" => id}) do
    socket
    |> assign(:page_title, "Edit Repository")
    |> assign(:repository, Repositories.get_repository!(username, id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Repositories")
    |> assign(:repository, nil)
  end

  defp list_repositories(username) do
    Repositories.list_repositories(username)
  end
end
