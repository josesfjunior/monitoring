defmodule Monitoring.Repo do
  use Ecto.Repo,
    otp_app: :monitoring,
    adapter: Ecto.Adapters.Postgres
end
