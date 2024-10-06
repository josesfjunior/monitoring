defmodule Monitoring.Schemas.Carrefour do
  use Ecto.Schema
  import Ecto.Changeset
  alias Monitoring.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "carrefour" do
    field :name, :string
    field :price, :integer
    field :day, :utc_datetime
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = ch,attrs \\ %{}) do
    ch
    |> cast(attrs, [:name, :price, :day])
    |> validate_required([:name, :price, :day])
  end

  def insert_carrefour(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end


end
