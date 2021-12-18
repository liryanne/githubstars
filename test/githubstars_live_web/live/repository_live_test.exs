defmodule GithubstarsLiveWeb.RepositoryLiveTest do
  use GithubstarsLiveWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GithubstarsLive.Repositories

  @create_attrs %{id: 1, username: "username", description: "some description", html_url: "some html_url", language: "some language", name: "some name", tags: []}
  @update_attrs %{id: 1, username: "username", description: "some updated description", html_url: "some updated html_url", language: "some updated language", name: "some updated name", tags: []}
  @invalid_attrs %{description: nil, html_url: nil, language: nil, name: nil, tags: nil, username: nil}

  defp fixture(:repository) do
    {:ok, repository} = Repositories.create_repository(@create_attrs)
    repository
  end

  defp create_repository(_) do
    repository = fixture(:repository)
    %{repository: repository}
  end

  describe "Index" do
    setup [:create_repository]

    test "lists all repositories", %{conn: conn, repository: repository} do
      {:ok, _index_live, html} = live(conn, Routes.repository_index_path(conn, :index, repository.username))

      assert html =~ "Listing Repositories"
      assert html =~ repository.description
    end
  end
end
