defmodule Monitoring.Repo.Migrations.CreateMonitoringPricesTable do
  use Ecto.Migration

  def change do
    create table(:monitoring_prices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :price, :integer
      add :day, :utc_datetime
      add :store_id, references(:stores, type: :uuid, on_delete: :delete_all)
      timestamps()
    end

    create index(:monitoring_prices, [:store_id])
  end
end
