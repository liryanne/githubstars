defmodule GithubstarsLive.RepositoriesTest do
  use GithubstarsLive.DataCase

  alias GithubstarsLive.Repositories

  describe "repositories" do
    alias GithubstarsLive.Repositories.Repository

    @valid_attrs %{id: 1, username: "username", description: "some description", html_url: "some html_url", language: "some language", name: "some name", tags: []}
    @update_attrs %{id: 1, username: "username", description: "some updated description", html_url: "some updated html_url", language: "some updated language", name: "some updated name", tags: []}
    @invalid_attrs %{description: nil, html_url: nil, language: nil, name: nil, tags: nil, username: nil}

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Repositories.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Repositories.list_repositories(repository.username) == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Repositories.get_repository!(repository.username, repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Repositories.create_repository(@valid_attrs)
      assert repository.description == "some description"
      assert repository.html_url == "some html_url"
      assert repository.language == "some language"
      assert repository.name == "some name"
      assert repository.tags == []
      assert repository.username == "username"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repositories.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{} = repository} = Repositories.update_repository(repository, @update_attrs)
      assert repository.description == "some updated description"
      assert repository.html_url == "some updated html_url"
      assert repository.language == "some updated language"
      assert repository.name == "some updated name"
      assert repository.tags == []
      assert repository.username == "username"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Repositories.update_repository(repository, @invalid_attrs)
      assert repository == Repositories.get_repository!(repository.username, repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Repositories.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Repositories.get_repository!(repository.username, repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Repositories.change_repository(repository)
    end
  end
end
