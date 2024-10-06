defmodule Monitoring.Repo.Migrations.CreateCarrefourTable do
  use Ecto.Migration

  def change do
    create table(:carrefour, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :price, :integer
      add :day, :utc_datetime
      timestamps()
    end

  end
end
