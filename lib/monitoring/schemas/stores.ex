defmodule Monitoring.Schemas.Stores do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Monitoring.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "stores" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = ch, attrs \\ %{}) do
    ch
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def insert_stores(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!()
  end

  def get_stores do
    Repo.all(__MODULE__)
  end

  def get_store(name) do
    from(
      s in __MODULE__,
      where: s.name == ^name
    )
    |> Repo.one()
  end
end
