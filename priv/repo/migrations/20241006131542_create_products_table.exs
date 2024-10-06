defmodule Monitoring.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :store, :string
      add :link, :string
      add :monitoring, :boolean, default: true
      timestamps()
    end

  end
end
