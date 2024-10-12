defmodule Monitoring.Repo.Migrations.CreateStoreTables do
  use Ecto.Migration

  def change do
    create table(:stores, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      timestamps()
    end
  end
end
