defmodule GithubstarsLiveWeb.RepositoryLive.FormComponent do
  use GithubstarsLiveWeb, :live_component

  alias GithubstarsLive.Repositories

  @impl true
  def update(%{repository: repository} = assigns, socket) do
    changeset = Repositories.change_repository(repository)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"repository" => repository_params}, socket) do
    changeset =
      socket.assigns.repository
      |> Repositories.change_repository(repository_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"repository" => repository_params}, socket) do
    save_repository(socket, socket.assigns.action, repository_params)
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_redirect(socket, to: socket.assigns.return_to)}
  end

  defp save_repository(socket, :edit, repository_params) do

    tags = String.split(repository_params["tags"], ",")
           |> Enum.map(fn x -> String.trim(x) end)
           |> Enum.uniq()

    case Repositories.update_repository(socket.assigns.repository, %{repository_params | "tags" => tags}) do
      {:ok, _repository} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repository updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
