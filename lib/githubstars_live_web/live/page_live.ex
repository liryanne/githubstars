defmodule GithubstarsLiveWeb.PageLive do
  use GithubstarsLiveWeb, :live_view

  alias GithubstarsLive.Repositories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "",  loading: false)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    send(self(), {:load_data, query})
    {:noreply,  assign(socket, query: query , loading: true)}
  end

  @impl true
  def handle_info({:load_data, query}, socket) do
    _repos = Repositories.get_repositories(query)
    {:noreply,
    socket |> redirect(to: Routes.repository_index_path(socket, :index, query))}
  end
end
