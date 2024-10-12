defmodule Monitoring.Schemas.MonitoringPrices do
  use Ecto.Schema
  import Ecto.Changeset
  alias Monitoring.Repo
  alias Monitoring.Schemas.Stores, as: Stores

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "monitoring_prices" do
    field :name, :string
    field :price, :integer
    field :day, :utc_datetime
    belongs_to :store, Stores, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = ch, attrs \\ %{}) do
    ch
    |> cast(attrs, [:name, :price, :day])
    |> validate_required([:name, :price, :day])
  end

  def insert(%{name: _, price: _, day: _, store: store_name} = attrs) do
    case Stores.get_store(store_name) do
      nil ->
        Stores.insert_stores(%{name: store_name})

      store ->
        %__MODULE__{}
        |> changeset(attrs)
        |> put_assoc(:store, store)
        |> Repo.insert()
    end
  end
end
