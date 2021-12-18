defmodule GithubstarsLiveWeb.Api.RepositoryControllerTest do
  use GithubstarsLiveWeb.ConnCase

  alias GithubstarsLive.Repositories
  alias GithubstarsLive.Repositories.Repository

  @create_attrs %{
    description: "some description",
    html_url: "some html_url",
    language: "some language",
    name: "some name",
    tags: [],
    username: "username",
    id: 1
  }
  @update_attrs %{
    description: "some updated description",
    html_url: "some updated html_url",
    language: "some updated language",
    name: "some updated name",
    tags: [],
    username: "username",
    id: 1
  }
  @invalid_attrs %{id: 1, description: nil, html_url: nil, language: nil, name: nil, tags: nil, username: nil}

  def fixture(:repository) do
    {:ok, repository} = Repositories.create_repository(@create_attrs)
    repository
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all repositories by username", %{conn: conn} do
      conn = get(conn, Routes.repository_path(conn, :index, "username"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "update repository" do
    setup [:create_repository]

    test "renders repository when data is valid", %{conn: conn, repository: %{id: id, username: username} = repository} do
      conn = put(conn, Routes.repository_path(conn, :update, username, id), repository: @update_attrs)


      assert %{
        "description" => "some updated description",
        "html_url" => "some updated html_url",
        "id" => 1,
        "language" => "some updated language",
        "name" => "some updated name",
        "tags" => []
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, repository: %{id: id, username: username} = repository} do
      conn = put(conn, Routes.repository_path(conn, :update, username, id), repository: @invalid_attrs)
      assert json_response(conn, 422) != %{}
    end
  end

  defp create_repository(_) do
    repository = fixture(:repository)
    %{repository: repository}
  end
end
