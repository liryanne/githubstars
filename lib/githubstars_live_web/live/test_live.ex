defmodule GithubstarsLiveWeb.TestLive do
  use GithubstarsLiveWeb, :live_view

  def mount(_params, _session, socket) do
    send(self(), :load_data)
    {:ok, assign(socket, query: "", results: nil, loading: true)}
  end

  def handle_info(:load_data, socket) do
    Process.sleep(3000) # it imitates the long query to the database
    results = [%{name: "Monica", age: 22}, %{name: "Blanca", age: 21}]
    {:noreply, assign(socket, loading: false, results: results)}
  end

 end
