defmodule Monitoring.Schemas.Products do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Monitoring.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :name, :string
    field :store, :string
    field :link, :string
    field :monitoring, :boolean, default: true
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = ch,attrs \\ %{}) do
    ch
    |> cast(attrs, [:name, :store, :link, :monitoring])
    |> validate_required([:name, :store, :link, :monitoring])
  end

  def insert_products(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
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

  end

end
