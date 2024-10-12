defmodule Monitoring.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :link, :string
      add :monitoring, :boolean, default: true
      add :store_id, references(:stores, type: :uuid, on_delete: :delete_all)
      timestamps()
    end

    create index(:products, [:store_id])
  end
end
