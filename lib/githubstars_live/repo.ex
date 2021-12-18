defmodule GithubstarsLive.Repo do
  use Ecto.Repo,
    otp_app: :githubstars_live,
    adapter: Ecto.Adapters.Postgres
end
