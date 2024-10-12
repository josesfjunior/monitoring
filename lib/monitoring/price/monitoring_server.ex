defmodule Monitoring.Price.MonitoringServer do
  use GenServer
  alias Monitoring.Schemas.Products
  alias Monitoring.Stores.Carrefour, as: GCarrefour

  @verify 12 * 60 * 60 * 1000 # hours


  def start_link(params \\ %{}) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  def init(initial_state) do
    {:ok, initial_state, {:continue, :init_state}}
  end

  def handle_continue(:init_state, state) do
    products = Products.get_products_to_monitorign()
    Process.send_after(self(), :inicializate, 1000)
    {:noreply, state |> Map.put(:products, products)}
  end

  def handle_info(:inicializate, %{products: products} = state) do
    carrefour_servers = products
    |> Enum.filter(fn product -> product.store == "carrefour" end)
    |> Enum.map(fn product -> GCarrefour.start_link(
      %{link: product.link, name: product.name, refresh_hour: @verify}
    ) end)
    |> Enum.map(fn {_, pid} -> pid end)

    {:noreply, state |> Map.put(:carrefour_servers, carrefour_servers)}
  end
end
