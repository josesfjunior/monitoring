defmodule Monitoring.Schemas.Products do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Monitoring.Repo
  alias Monitoring.Schemas.Stores, as: Stores

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :name, :string
    field :link, :string
    field :monitoring, :boolean, default: true
    belongs_to :store, Stores, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = ch, attrs \\ %{}) do
    ch
    |> cast(attrs, [:name, :link, :monitoring])
    |> validate_required([:name, :link, :monitoring])
  end

  def insert_products(%{name: _, link: _, store: store_name} = attrs) do
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

  def get_products do
    Repo.all(__MODULE__)
  end

  def get_product(id) do
    Repo.get(__MODULE__, id)
  end

  def get_products_to_monitorign() do
    from(
      m in __MODULE__,
      where: m.monitoring == true
    )
    |> Repo.all()
    |> Repo.preload(:store)
  end
end
